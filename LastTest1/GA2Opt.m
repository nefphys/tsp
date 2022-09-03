%% GAopt 算法求解TSP问题 改写以前的代码

function GA2Opt_Struct = GA2Opt(tspData)
    %判断tspdata是不是大于1的方阵
    %如果是，则传入的是距离矩阵
    tt1 = tic();
    if size(tspData,1) == size(tspData,2) && size(tspData,1) > 1
        distances_matrix = tspData;
        City = tspData;
    else
        [Distance, City] = readfile(tspData,1);
        distances_matrix = Distance;
    end
    
    
    %% 特殊情况判定
    CityNum = size(City, 1);
    if CityNum == 1
        GA2Opt_Struct.length = 0;
        GA2Opt_Struct.route = 1;
        GA2Opt_Struct.bestline = 0;
        GA2Opt_Struct.time = toc(tt1);
    end
    
    if CityNum == 2
        GA2Opt_Struct.length = distances_matrix(1,2);
        GA2Opt_Struct.route = [1 2];
        GA2Opt_Struct.bestline = 0;
        GA2Opt_Struct.time = toc(tt1);
    end
    
    if CityNum == 3
        GA2Opt_Struct.length = distances_matrix(1,2) + distances_matrix(2,3) + distances_matrix(1,3);
        GA2Opt_Struct.route = [1 2 3];
        GA2Opt_Struct.bestline = 0;
        GA2Opt_Struct.time = toc(tt1);
    end
    
    if CityNum > 3
        %重要参数 对优化结果十分重要
        popSize = 20 + round((CityNum)^0.8 * 2 );
        if mod(popSize,2) == 0
        else
            popSize = popSize + 1;
        end
        EAmaxIt = 20 + round((CityNum)^0.5 * 2);
        optMaxIt = min(1e5, 1000 + CityNum*20);

        BKS = 0;
        route = [];

        %输出结果的参数
        
        BestLine = 0;
        BestRo = 0;


        %随机初始化种群
        iniPop = InitPop(popSize, CityNum);
        iniFit = zeros(popSize,1);
        %对解进行2-opt计算
        BKSD = [];
        for i = 1:popSize
            TSP_Struct = CalChrom2Opt(iniPop(i,:), optMaxIt, CityNum, distances_matrix);
            iniPop(i,:) = TSP_Struct.route;
            iniFit(i) = 1 / TSP_Struct.length;
            BKSD(i) = TSP_Struct.length;
        end
        [ix iy] = min(BKSD);
        BKS(1) = ix;
        route = iniPop(iy,1:(end-1));
        %进入循环
        for iter = 2:(EAmaxIt+1)
            %单点交叉
            nextPop = Cal_Cross_EA(iniPop);
            %变异
            nextPop = Cal_Mutate_EA(nextPop);
            %对种群进行2opt计算
            nextFit = zeros(popSize,1);
            for i = 1:popSize
                TSP_Struct = CalChrom2Opt(nextPop(i,:), optMaxIt, CityNum, distances_matrix);
                nextPop(i,:) = TSP_Struct.route;
                nextFit(i) = 1 / TSP_Struct.length;
            end
            %选择
            iniPop = [iniPop ; nextPop];
            iniFit = [iniFit ; nextFit];
            iniPop = CalSelect(iniFit, iniPop, popSize);
            %再次进行2opt计算
            iniFit = zeros(popSize,1);
            BKSD = [];
            %对解进行2-opt计算
            for i = 1:popSize
                TSP_Struct = CalChrom2Opt(iniPop(i,:), optMaxIt, CityNum, distances_matrix);
                iniPop(i,:) = TSP_Struct.route;
                iniFit(i) = 1 / TSP_Struct.length;
                BKSD(i) = TSP_Struct.length;
            end
            [ix iy] = min(BKSD);
            if ix < BKS(iter-1)
                BKS(iter) = ix;
                route = iniPop(iy,1:(end-1));
            else
                BKS(iter) = BKS(iter-1);
            end
        end

        GA2Opt_Struct.length = BKS(end);
        GA2Opt_Struct.route = route;
        GA2Opt_Struct.bestline = BKS;
        GA2Opt_Struct.time = toc(tt1);
    end
end


function Chrom = InitPop(popSize, CityNum)
    Chrom = zeros(popSize,CityNum + 1);
    for i = 1:popSize
        Chrom(i,2:end) = randperm(CityNum);
    end
    Chrom(:,1) = Chrom(:,end);
end


function nextPop = Cal_Cross_EA(mPop)
    nextPop = mPop;
    mPop(:,end) = [];
    tpop = mPop;
    [R C] = size(mPop);
    CL = 2:(C-1);
    for i = 1:(R/2)
        s1 = mPop(i*2-1,:);
        s2 = mPop(i*2,:);
        P = randsample(CL,1);
        t1 = s1(1:P);
        t1 = [t1 setdiff(s2,t1,'stable')];
        t2 = s2(1:P);
        t2 = [t2 setdiff(s1,t2,'stable')];
        tpop(i*2-1,:) = t1;
        tpop(i*2,:) = t2;
    end
    nextPop(:,1:(end-1)) = tpop;
end


function nextPop = Cal_Mutate_EA(mPop)
    [R C] = size(mPop);
    CL = 2:(C-1);
    for i = 1:R
        P = randsample(CL,2,'false');
        t = mPop(i,P(1));
        mPop(i,P(1)) = mPop(i,P(2));
        mPop(i,P(2)) = t;
    end
    nextPop = mPop;
end


function nextPop = CalSelect(Fitness, mPop, popSize)
    Px = Fitness / sum(Fitness);
    Px = cumsum(Px);
    sele = [];
    for i=1:popSize
        theta=rand;  
        for j=1:length(Px) 
            if theta<=Px(j)
                sele(end+1) = j;
                break
            end
        end
    end
    nextPop = mPop(sele,:);
end


function TSP_Struct = CalChrom2Opt(Chrom,maxIt, CityNum, DistM)
    BKS = zeros(1,maxIt+1);
    CT = CityNum - 1;
    %计算当前染色体的距离
    ndist = 0;
    for h = 1:CityNum
        ndist = ndist + DistM(Chrom(h),Chrom(h+1));
    end
    BKS(1) = ndist;
    seleM = randi(CT,maxIt,2);
    seleM = seleM + 1;
    for h = 1:maxIt
        %随机选择两个点作为端点 并交换顺序
        selec = seleM(h,:);
        if selec(1) == selec(2)
            selec = randperm(CT, 2);
            selec = selec + 1;
        end
        if selec(1) > selec(2)
            T = selec(1);
            selec(1) = selec(2);
            selec(2) = T;
        end

        Cind = [Chrom(selec(1)-1) Chrom(selec(1)) Chrom(selec(2)) Chrom(selec(2)+1)];
        od1 = DistM(Cind(1), Cind(2)) + DistM(Cind(3), Cind(4));
        nd1 = DistM(Cind(1), Cind(3)) + DistM(Cind(2), Cind(4));
        if nd1 < od1
            Chrom(selec(1):selec(2)) = fliplr(Chrom(selec(1):selec(2)));
            ndist = ndist + nd1 - od1; 
            BKS(h+1) = ndist;
        else
            BKS(h+1) = BKS(h);
        end
    end
    TSP_Struct.route = Chrom;
    TSP_Struct.length = ndist;
    TSP_Struct.Bestline = BKS;
end