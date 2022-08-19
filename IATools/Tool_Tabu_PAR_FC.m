%% tabu + 变异进化算法 主程序
function [Tabu] = Tool_Tabu_PAR_FC(City, ANS_GROUP)
    %% 算法框架
    tt1 = tic;
    popSheet = Cal_Ans_Sheet_Group(ANS_GROUP);
    %% 给定算法参数，产生初始解，禁忌表为空
    % 根据popSheet生成指定数量的tabu结构体
    mstr = "";
    [nrow ncol] = size(popSheet);
    Num = 1;
    NumSt.IDNum = 0;
    for i = 1:nrow
        for j = 1:(ncol-2)  %最后两列不参与禁忌搜索
            mstr(Num) = num2str(popSheet(i,1:j),'%03d');
            Num = Num + 1;
            %NumSt(Num).IDNum = zeros(1,ncol-2);
            NumSt(Num).IDNum(1:j) = popSheet(i,1:j);
        end
    end
    [mstr_UN ia]= unique(mstr);
    Num = length(mstr_UN);
    %对每个smtr建立初始禁忌表
    %第一层
    TabuSheet.ID = "0";
    TabuSheet.IDNum = 0;
    TabuSheet.Sheet = zeros(length(unique(popSheet(:,1))));
    for i = 1:Num
        TabuSheet(i+1).ID = mstr_UN(i);
        TabuSheet(i+1).Sheet = zeros(sum(mstr == mstr_UN(i)));
        TabuSheet(i+1).IDNum = NumSt(ia(i)+1).IDNum;
    end
    mstr_UN = ["0" mstr_UN];
    % 初始化参数
    TabuL = 10; %禁忌记忆长度 实际动态调节
    Candi = 50; %每次选择的最多领域个数
    %CandiSolu = {}; %候选解集合 ps 每个解是cell中的一个mat
    S0 = popSheet; %初始解 
    BestL = Cal_Route_Dist_FC(City, ANS_GROUP,popSheet); %当前最优解 数组
    
    HBest = BestL; %历史最优的解
    HBestR = popSheet; %历史最优解对应的路径
    
    iter = 1; %迭代次数
    MaxIter = Num; %最大迭代次数
    genBest = 0; %每次循环得到的最优解
    
    MuteProb = 0.2 * (0.1 + sqrt(1/Num));
    while iter <= MaxIter
        %iter
        % 计算邻域
        CandiSolu = Cal_Neib(S0, Candi, mstr_UN);
      
        % 计算邻域解的表现
        NeibFit = 0;
        parfor i = 1:Candi
            [Rdist Route] = Cal_Route_Dist_FC(City, ANS_GROUP, CandiSolu{i});
            NeibFit(i) =  Rdist;
        end
        
        CandiSoluMute = CandiSolu;
        parfor i = 1:Candi
            %变异
            for h = 1:size(S0,1)
                if rand < MuteProb
                    CandiSoluMute{i}(h,end) = ~CandiSoluMute{i}(h,end)+0;
                end
            end
            [Rdist Route] = Cal_Route_Dist_FC(City, ANS_GROUP, CandiSoluMute{i});
            NeibFit = [NeibFit Rdist];
        end
        CandiSolu = [CandiSolu CandiSoluMute];
        [C IDX] = sort(NeibFit);
        %如果候选解比目前的最优解好，则直接赋值到最新的，更新禁忌表
        if NeibFit(IDX(1)) < HBest
            BestL(iter+1) = NeibFit(IDX(1));
            HBest = NeibFit(IDX(1));
            HBestR = CandiSolu{IDX(1)};
            S0 = CandiSolu{IDX(1)};
            % 赋值选择的这个对应禁忌表中值
            [TabuSheet  istabu] = Cal_Loc_Change(S0, CandiSolu{IDX(1)}, TabuSheet);
        else
            %如果候选解没有比当前解更好，则考虑禁忌表的情况
            %首先判断禁忌表中没有限制的候选解，如果有，则选择第一个作为新解
            %每个子部分都没有限制
            %BestL(iter+1) = BestL(iter);
            
            parfor i = 1:(Candi*2)
                [temp istabu(i)] = Cal_Loc_Change(S0, CandiSolu{IDX(i)}, TabuSheet);
            end
            
            if sum(istabu) ~= Candi
                indp = find(istabu == 0,1);
                [TabuSheet  istabu] = Cal_Loc_Change(S0, ...
                    CandiSolu{IDX(indp)}, TabuSheet);
                BestL(iter+1) = NeibFit(IDX(indp));
                BestL(iter+1) = NeibFit(IDX(indp));
                S0 = CandiSolu{IDX(indp)};
            else
                [TabuSheet  istabu] = Cal_Loc_Change(S0, ...
                    CandiSolu{IDX(1)}, TabuSheet);
                BestL(iter+1) = NeibFit(IDX(1));
                S0 = CandiSolu{IDX(1)};
            end
        end
        
        %统一更新禁忌表
        for i = 1:length(TabuSheet)
            temp = TabuSheet(i).Sheet;
            temp(temp ~= 0) = temp(temp ~= 0) - 1;
            TabuSheet(i).Sheet = temp;
        end
        
        iter = iter + 1;
    end
    Tabu.length = HBest;
    Tabu.BestL = BestL;
    Tabu.route = HBestR;
    Tabu.time = toc(tt1);
end

%% 计算两个种群的交换的位置，返回新的禁忌表
function [TabuSheet istabu] = Cal_Loc_Change(pop1, pop2, TabuSheet)
    %pop1是原始的
    %pop2是最新的
    %返回pop2与pop1的改变的点位，返回tabusheet
    %动态禁忌长度，根据数据长度确定
    
    %判断当前的更新是否在以前的禁忌表当中
    %注意每层都有在进行，因此判定条件为每个子表都不同
    
    istabu = 0;
    %查看第一层是否有变换
    L1 = unique(pop1(:,1),'stable');
    L2 = unique(pop2(:,1),'stable');
    
    pos1 = 0; %第一次出现变化的位置
    pos2 = 0; %最后一次出现变化的位置
    
    for i = 1:length(L1)
        if L1(i) ~= L2(i)
            if pos1 == 0
                pos1 = L1(i);
            end
            pos2 = L1(i);
        end
    end
    if pos1 ~= 0
        %仅更新上三角区域
        if pos1 > pos2
            if TabuSheet(1).Sheet(pos2,pos1) ~= 0
                istabu = istabu + 1; %有更新到禁忌表中的
            else
            end
            TabuSheet(1).Sheet(pos2,pos1) = length(L1);
        else
            if TabuSheet(1).Sheet(pos1,pos2) ~= 0
                istabu = istabu + 1;
            else
            end
            TabuSheet(1).Sheet(pos1,pos2) = length(L1);
        end
    end
    %需要多层循环，恼火
    for i = 2:length(TabuSheet)
%         mstr = TabuSheet(i).ID;
%         mstr = convertStringsToChars(mstr);
%         tc = [];
%         while ~isempty(mstr)
%             tc = [tc str2num(mstr(1:3))];
%             mstr(1:3) = [];
%         end
        tc = TabuSheet(i).IDNum;
        %找到哪些行是这一个类的，记录行的id
%         fid1 = [];
%         fid2 = [];
%         tcL = length(tc);
%         temp1 = pop1(:,1:tcL);
%         temp2 = pop2(:,1:tcL);
%         for h = 1:size(pop1,1)
%             if temp1(h,:) == tc
%                 fid1 = [fid1 h];
%             end
%             
%             if temp2(h,:) == tc
%                 fid2 = [fid2 h];
%             end
%         end
%         
        tcL = length(tc);

        Matr = pop1(:,1:tcL) - tc;
        Matr = sum(abs(Matr),2);
        fid1 = find(Matr == 0);

        Matr = pop2(:,1:tcL) - tc;
        Matr = sum(abs(Matr),2);
        fid2 = find(Matr == 0);
        
        
%         fid1 = Cal_Mat_Ary(pop1(:,1:tcL), tc);
%         fid2 = Cal_Mat_Ary(pop2(:,1:tcL), tc);
        
        if length(fid1) > 2
            %如果fid只有一个数，则肯定没有计算的必要
            route1 = pop1(fid1, length(tc)+1);
            route2 = pop2(fid2, length(tc)+1);

            L1 = unique(route1,'stable');
            L2 = unique(route2,'stable');

            pos1 = 0; %第一次出现变化的位置
            pos2 = 0; %最后一次出现变化的位置

            for h = 1:length(L1)
                if L1(h) ~= L2(h)
                    if pos1 == 0
                        pos1 = L1(h);
                    end
                    pos2 = L1(h);
                end
            end
            if pos1 ~= 0
                %仅更新上三角区域
                if pos1 > pos2
                    if TabuSheet(i).Sheet(pos2,pos1) ~= 0
                        istabu = istabu + 1; %有更新到禁忌表中的
                    else
                    end
                    TabuSheet(i).Sheet(pos2,pos1) = length(L1);
                else
                    if TabuSheet(i).Sheet(pos1,pos2) ~= 0
                        istabu = istabu + 1;
                    else
                    end
                    TabuSheet(i).Sheet(pos1,pos2) = length(L1);
                end
            end
        end
    end
    
    if istabu >= 1
        istabu = 1;
    else
        istabu = 0;
    end
end


function fid = Cal_Mat_Ary(Matr, Arry)
    fid = [];
    for h = 1:size(Matr,1)
        if ~(Matr(h,:) - Arry)  
            fid = [fid h];
        end
    end
end


%% 给定起点，初始化一个种群
function Neib = Cal_Neib(popSheet, Candi, mstr_UN)
    %每个子单位只更新一段
    %给定一个2opt概率
    probOpt = 0.2*(0.1 + sqrt(1/length(mstr_UN)));
    
    %计算Candi次
    Neib = repelem({popSheet},Candi);
    %第一层的2opt
    route = unique(popSheet(:,1),'stable');
    if length(route)>2
        %candi次2opt
        for i = 1:Candi
            if probOpt > rand
                route_i = opt2(route); %有可能没有那么多组合，但是不重要
                temp = [];
                for h = 1:length(route_i)
                    temp = [temp ; popSheet(popSheet(:,1) == route_i(h),:)];
                end
                Neib{i} = temp;
            end
        end
    end
    
    for i = 2:length(mstr_UN)
        %解析为数字数组
        temp = convertStringsToChars(mstr_UN(i));
        tc = [];
        while ~isempty(temp)
            tc = [tc str2num(temp(1:3))];
            temp(1:3) = [];
        end
        %找到哪些行是这一个类的，记录行的id
        fid = [];
        for h = 1:size(popSheet,1)
            if popSheet(h,1:length(tc)) == tc
                fid = [fid h];
            end
        end
        %当前路径顺序
        route = popSheet(fid,length(tc)+1);
        route_u = unique(route,'stable');
        if length(route) > 2
            %candi次2opt
            for h = 1:Candi
                if probOpt > rand
                    route_i = opt2(route_u);
                    temp = [];
                    for j = 1:length(route_i)
                        temp = [temp ; popSheet(fid(route==route_i(j)),:)];
                    end
                    %neib{h}里面再找到对应的行
                    gid = [];
                    for j = 1:size(popSheet,1)
                        if Neib{h}(j,1:length(tc)) == tc
                            gid = [gid j];
                        end
                    end
                    Neib{h}(gid,:) = temp;
                end
            end
        end
    end
end