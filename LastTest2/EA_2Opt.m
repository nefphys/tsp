function EA_Struct = EA_2Opt(ANS_GROUP, City, calLayer, popSize, EAmaxIt, optMaxIt)
    %ans_group 本身不会有什么变化，因此后续只需要进行查找
    t1 = datetime;
    %calLayer = 3;
    %popSize = 50;
    BestLine = 0;
    BestRo = 0;
    
    %EAmaxIt = 100;
    %optMaxIt = 1e3;
    
     %初始解情况
    [Rdist Route] = Cal_Route_Dist_FC(City, ANS_GROUP, 0);
    % 首先生成目标染色体形式
    [New_Group Chrom SCity] = Cal_Layer_Group(calLayer, ANS_GROUP, City);
    bestGroup = New_Group;
    BestRo = Chrom;
    BKS = Rdist;
    BestLine(1) = Rdist;
   
    
    %% 2-opt 生成种群
    initPop = repmat(0,popSize,length(Chrom));
    initFit = [];
    init_Group = repelem({New_Group},popSize);
    [TCity allDist New_Mat CCBP toDist] = Cal_2Opt_EA_Pre(Chrom, New_Group, SCity, optMaxIt);
    for i = 1:popSize
        [TSP_Struct AGN] = Cal_2Opt_EA(Chrom, New_Group, TCity, optMaxIt, allDist, New_Mat, CCBP, toDist);
        initPop(i,:) = TSP_Struct.route;
        initFit(i) = TSP_Struct.length;
        init_Group{i} = AGN;
    end
    %figure(1);
    iter = 0;
    
  
    %进入遗传算法中
    while iter < EAmaxIt
        %交叉 - 单点交叉，即每层选择一个，进入则变为单点
        %单点交叉变异生成子代
        nextPop = Cal_Cross_EA(initPop);
        %变异
        nextPop = Cal_Mutate_EA(nextPop);
        %对种群进行2opt计算，并行计算
        newxtFit = [];
        next_Group = init_Group;
        for i = 1:popSize
            [TCity allDist New_Mat CCBP toDist] = Cal_2Opt_EA_Pre(nextPop(i,:), init_Group{i}, SCity, optMaxIt);
            [TSP_Struct temp_Group] = Cal_2Opt_EA(nextPop(i,:), New_Group, TCity, optMaxIt, allDist, New_Mat, CCBP, toDist);
            next_Group{i} = temp_Group;
            nextPop(i,:) = TSP_Struct.route;
            newxtFit(i) = TSP_Struct.length;
        end
        
        tempfit = [initFit newxtFit];
        % [ix iy] = sort(tempfit);
        tempPop = [initPop; nextPop];
        tempGroup = [init_Group next_Group];
        [initPop sl] = Cal_Select_EA(tempfit, tempPop, popSize);
        init_Group = tempGroup(sl);
        
        initFit = [];
        for i = 1:popSize
            [TCity allDist New_Mat CCBP toDist] = Cal_2Opt_EA_Pre(initPop(i,:), init_Group{i}, SCity, optMaxIt);
            [TSP_Struct temp_Group] = Cal_2Opt_EA(initPop(i,:), New_Group, TCity, optMaxIt, allDist, New_Mat, CCBP, toDist);
            init_Group{i} = temp_Group;
            initPop(i,:) = TSP_Struct.route;
            initFit(i) = TSP_Struct.length;
        end
        
        
        %plot(initFit)
        %initPop = tempPop(iy(1:popSize),:);
        %initFit = tempfit(iy(1:popSize));
        %结束
        iter = iter + 1;
        bkp = min(initFit);
        
        if BKS > bkp
            BKS = bkp;
            BestLine(iter+1) = bkp;
            BestRo = initPop(initFit == bkp,:);
            bestGroup = init_Group{initFit == bkp};
        else
            BestLine(iter+1) = BestLine(iter);
        end
    end
    
    %[REVStruct] = Cal_2Opt_EA(BestRo, New_Group, SCity, 0); %还原路径
    [route1 dist1] = Cal_New_Dist(bestGroup, BestRo(1,:), City);
    EA_Struct.dist = dist1;
    EA_Struct.route = route1;
    EA_Struct.bestline = BestLine;
    EA_Struct.time = seconds(datetime - t1);
end


function nextPop = Cal_Cross_EA(mPop)
    nextPop = mPop;
    [R C] = size(mPop);
    CL = 2:C;
    for i = 1:(R/2)
        s1 = mPop(i*2-1,:);
        s2 = mPop(i*2,:);
        P = randsample(CL,1);
        t1 = s1(1:P);
        t1 = [t1 setdiff(s2,t1,'stable')];
        t2 = s2(1:P);
        t2 = [t2 setdiff(s1,t2,'stable')];
        nextPop(i*2-1,:) = t1;
        nextPop(i*2,:) = t2;
    end
end

function nextPop = Cal_Mutate_EA(mPop)
    [R C] = size(mPop);
    CL = 2:C;
    for i = 1:R
        P = randsample(CL,2,'false');
        t = mPop(i,P(1));
        mPop(i,P(1)) = mPop(i,P(2));
        mPop(i,P(2)) = t;
    end
    nextPop = mPop;
end


function [selecPop sl] = Cal_Select_EA(mfit, mpop, popsize)
    %始终保留最优种群一半
    IF = 2;
    selecPop = mpop(1:popsize,:);
    [mx my] = sort(mfit);
    selecPop(1:(popsize/IF),:) = mpop(my(1:(popsize/IF)),:);
    
    LL = (popsize/IF+1):length(mfit);
    sl = [];
    mfit = mfit(my(LL));
    sl(1:(popsize/IF)) = my(1:(popsize/IF));
    for i = (popsize/IF+1):popsize
        mprob = 1 ./ mfit; % 大的概率小
        mprob = mprob /sum(mprob);
        %mprob = 1/mprob;
        for h = 2:length(mprob)
            mprob(h) = mprob(h) + mprob(h-1);
        end
        for h = 1:length(mprob)
            if rand > mprob(h)
                selecPop(i,:) = mpop(my(LL(h)),:);
                sl(i) = my(LL(h));
                LL(h) = [];
                mfit(h) = [];
                break
            end
        end
    end
end
