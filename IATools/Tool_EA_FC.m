function [EA_Struct] = Tool_EA_FC(City, ANS_GROUP)
    %% 融合进化规划和差分进化的进化算法
    %  tsp_solve_struct 包含有City 城市坐标
    %                        route 已优化的路径，表示点顺序
    %                        cate 与City对应
    
    %% 算法终止参数，最大迭代次数
    MaxIter = 100%;length(ANS_GROUP) * 100;
    
    %% 算法主体
    popSize = 30;
    
    %% 初始化种群
    % 种群的表示方法 矩阵 张量表示不熟悉，用cell
    popST{1} = Cal_Ans_Sheet_Group(ANS_GROUP);
    for i = 1:popSize
        popST{i} = popST{1};
    end
    
    %% 计算父代适应度 初始化进去
    %防止计算过小
    maxd = 0;
    for i = 1:popSize
        popFit(i) = Cal_Route_Dist_FC(City, ANS_GROUP, popST{i});
        if maxd < popFit(i)
            maxd = popFit(i);
        end
    end
    for i = 1:popSize
        popFit(i) = sqrt(maxd/popFit(i));
    end
    %适应度接近1, 避免结果太小出现大误差
    
    %% 进入循环 设定终止条件
    iter = 1;
    opt = 1;
    while iter <= MaxIter
    
        %% 差分算子 暂时没有想法
        
        %% 交叉算子
        % 随机选择两个父代进行交叉
        %popNext1 = Cal_Cross(popST);
        popNext1 = popST;
        %% 父代和子代进行变异
        % 出生和成长都会有变异，出生变异概率大
        popNext2 = Cal_Mutate(popST, 0.01, 0.01);
        
        popNext3 = Cal_Mutate(popNext1, 0.01, 0.01);
        %% 当前有4倍种群
        NewPop = [popST, popNext1, popNext2, popNext3];
        %% 评估适应度
        for i = (popSize+1):(popSize*4)
            popFit(i) = Cal_Route_Dist_FC(City, ANS_GROUP, NewPop{i});
            popFit(i) = sqrt(maxd/popFit(i));
        end
        %% 选择进入下一代，直接选择最优后代
        [M I] = sort(popFit,'descend');
        popST = NewPop(I(1:(popSize/2)));
        popST((popSize/2+1):popSize) = NewPop(randsample(1:(popSize*4),popSize/2,'false'));
        iter = iter + 1
        opt(iter) = M(1);
        %plot(popFit)
    end
    
    %选择最优后代
    BestPop = popST{1};
    %计算最优路径
    [Rdist Route] = Cal_Route_Dist_FC(City, ANS_GROUP, BestPop);
    EA_Struct.dist = Rdist;
    EA_Struct.route = Route;
    EA_Struct.opt = opt;
end

function [popNext] = Cal_Mutate(popST, probf, probg)
    %变异为每列循环进行，最后一列变异概率更大
    popSize = length(popST);
    popNext = {};
    for i = 1:popSize
        temp = popST{i};
        SS = [];
        featu = size(temp,2);
        for h = 1:(featu -1)
            if h == 1
                pop = unique(temp(:,1),'stable');
                %随机选择两个位置交换
                if length(pop) > 3 && rand < probf
                    p = randsample(1:length(pop),2,'false');
                    npop = pop;
                    npop(p) = pop([p(2) p(1)]);
                    for j = 1:length(npop)
                        SS = [SS; temp(temp(:,1) == npop(j),:)];
                    end
                else
                    SS = temp;
                end
            else
                mstr = "";
                for j = 1:size(temp,1)
                    mstr(j) = strjoin(temp(j,1:(h-1))+"",'');
                end
                pop1 = unique(mstr,'stable');
                for j = 1:length(pop1)
                    sub1 = SS(pop1(j) == mstr,:);
                    sub1_pop = unique(sub1(:,h),'stable');
                    %随机选择两个位置交换
                    SP = [];
                    if length(sub1_pop) > 3 && rand < probf
                        p = randsample(1:length(sub1_pop),2,'false');
                        npop = sub1_pop;
                        npop(p) = sub1_pop([p(2) p(1)]);
                        for k = 1:length(npop)
                            SP = [SP; sub1(sub1(:,h) == npop(k),:)];
                        end
                        SS(pop1(j) == mstr,:) = SP;
                    end
                end
            end
        end
        for h = 1:size(SS,1)
            if rand < probg
                SS(h,end) = ~SS(h,end)+0;
            end
        end
        popNext{i} = SS;
    end
end


function [popNext] = Cal_Cross(popST)
    popSize = length(popST);
    popNext = {};
    for i = 1:(popSize/2) %默认种群偶数
        Rselect = randsample(1:popSize,2,'false');
        F1 = popST{Rselect(1)};
        F2 = popST{Rselect(2)};
        
        %染色体片段大于3才进行交叉
        S1 = [];
        S2 = [];
        for h = 1:(size(F1,2)-1)%最后一列不作为主要部分参加，因为只有0，1取值
            
            if h == 1
                %判断此时群体由多少个点
                pop1 = unique(F1(:,1),'stable');
                pop2 = unique(F2(:,1),'stable');
                if length(pop1) > 3
                    %pop1和pop2进行交叉
                    %随机一个断点
                    p = randsample(2:(length(pop1)-1),1);
                    T1 = pop1(1:p);
                    res1 = setdiff(pop2, T1, 'stable');
                    T1 = [T1; res1];
                    T2 = pop2(1:p);
                    res2 = setdiff(pop1, T2, 'stable');
                    T2 = [T2; res2];
                    for j = 1:length(unique(pop1))
                        S1 = [S1; F1(F1(:,1) == T1(j),:)];
                        S2 = [S2; F2(F2(:,1) == T2(j),:)];
                    end
                end
            else
                %判断有多少个大类
                %将1:h-1列数据变为字符串
                mstr1 = "";
                mstr2 = "";
                for j = 1:size(S1,1)
                    mstr1(j) = strjoin(S1(j,1:(h-1))+"",'');
                    mstr2(j) = strjoin(S2(j,1:(h-1))+"",'');
                end
                pop1 = unique(mstr1,'stable');
                pop2 = unique(mstr2,'stable');
                
                %针对每个大类下的小类进行计算
                for j = 1:length(pop1)
                   
                    % 判断种群大小
                    sub1 = S1(pop1(j) == mstr1,:);
                    sub2 = S2(pop1(j) == mstr2,:);
                    sub1_pop = unique(sub1(:,h),'stable');
                    sub2_pop = unique(sub2(:,h),'stable');
                    SS1 = [];
                    SS2 = [];
                    if length(sub1_pop) > 3
                        p = randsample(2:(length(sub1_pop)-1),1);
                        T1 = sub1_pop(1:p);
                        res1 = setdiff(sub2_pop, T1, 'stable');
                        T1 = [T1; res1];
                        T2 = sub2_pop(1:p);
                        res2 = setdiff(sub1_pop, T2, 'stable');
                        T2 = [T2; res2];
                        for k = 1:length(sub1_pop)
                            SS1 = [SS1; sub1(sub1(:,h) == T1(k),:)];
                            SS2 = [SS2; sub2(sub2(:,h) == T2(k),:)];
                        end
                        S1(pop1(j) == mstr1,:) = SS1;
                        S2(pop1(j) == mstr2,:) = SS2;
                    end
                end
            end
        end
        popNext{2*i} = S2;
        popNext{2*i-1} = S1;
    end
end

function [popNext] = Cal_Diff(popST)
    LL = length(popNext);
    popNext = popST;
    coef1 = 0.5;
    for i = 1:LL
        Rselect = randsample(MY_setdiff(1:LL,i),2,'false');
        F1 = popNext{Rselect(1)};
        F2 = popNext{Rselect(2)};
        F = popNext{i};
        % 计算F1 和 F2的差, 每列单独计算
        Fdiff = 1:size(F,2);
        for h = 1:length(Fdiff)
            Fdiff(h) = F +  coef1 * (F1(:,h) - F2(:,h));
            %对Fdiff进行排序
        end
    end
end


