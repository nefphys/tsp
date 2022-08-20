function EA_Struct = EA_PAR_2Opt(ANS_GROUP, City, calLayer, popSize, EAmaxIt, optMaxIt)
    %ans_group 本身不会有什么变化，因此后续只需要进行查找
    tt1 = tic();
    %calLayer = 3;
    %popSize = 50;
    BestLine = 0;
    BestRo = 0;
    
    %EAmaxIt = 100;
    %optMaxIt = 1e3;
    
   
    
    % 首先生成目标染色体形式
    [New_Group Chrom SCity] = Cal_Layer_Group(calLayer, ANS_GROUP, City);
    
    %初始解情况
    [Rdist Route] = Cal_Route_Dist_FC(City, ANS_GROUP, 0);
    
    %% 2-opt 生成种群
    initPop = repmat(0,popSize,length(Chrom));
    initFit = [];
    parfor i = 1:popSize
        [TSP_Struct] = Cal_2Opt_EA(Chrom, New_Group, SCity, optMaxIt);
        initPop(i,:) = TSP_Struct.route;
        initFit(i) = TSP_Struct.length;
    end
    BestLine(1) = min(initFit);
    BKS = BestLine(1);
    figure(1);
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
        parfor i = 1:popSize
            [TSP_Struct] = Cal_2Opt_EA(nextPop(i,:), New_Group, SCity, optMaxIt);
            nextPop(i,:) = TSP_Struct.route;
            newxtFit(i) = TSP_Struct.length;
        end
        %轮盘选择？
        
        
        tempfit = [initFit newxtFit];
        % [ix iy] = sort(tempfit);
        tempPop = [initPop; nextPop];
        initPop = Cal_Select_EA(tempfit, tempPop, popSize);
        
        initFit = [];
        parfor i = 1:popSize
            [TSP_Struct] = Cal_2Opt_EA(Chrom, New_Group, SCity, optMaxIt);
            initPop(i,:) = TSP_Struct.route;
            initFit(i) = TSP_Struct.length;
        end
        
        
        plot(initFit)
        %initPop = tempPop(iy(1:popSize),:);
        %initFit = tempfit(iy(1:popSize));
        %结束
        iter = iter + 1
        bkp = min(initFit);
        
        if BKS > bkp
            BKS = bkp;
            BestLine(iter+1) = bkp;
            BestRo = initPop(initFit == bkp,:);
        else
            BestLine(iter+1) = BestLine(iter);
        end
    end
    
    [REVStruct] = Cal_2Opt_EA(BestRo, New_Group, SCity, 0); %还原路径
    
    EA_Struct.dist = REVStruct.length;
    EA_Struct.route = REVStruct.route;
    EA_Struct.bestline = BestLine;
    EA_Struct.time = toc(tt1);
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


function selecPop = Cal_Select_EA(mfit, mpop, popsize)
    selecPop = mpop(1:popsize,:);
    LL = 1:length(mfit);
    for i = 1:popsize
        mprob = mfit/sum(mfit);
        for h = 2:length(mprob)
            mprob(h) = sum(mprob(1:h));
        end
        for h = 1:length(mprob)
            if rand > mprob(h)
                selecPop(i,:) = mpop(LL(h),:);
                LL(h) = [];
                mfit(h) = [];
                break
            end
        end
    end
end



















