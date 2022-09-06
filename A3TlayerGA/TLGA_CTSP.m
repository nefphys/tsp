function TSP_Solve_Struct = TLGA_CTSP(tspData, K)

%% 时间复杂度
% Linear model Poly3:
%      f(x) = p1*x^3 + p2*x^2 + p3*x + p4
% Coefficients (with 95% confidence bounds):
%        p1 =   3.463e-06  (2.852e-06, 4.073e-06)
%        p2 =  -1.809e-05  (-0.0002128, 0.0001766)
%        p3 =     0.02981  (0.01199, 0.04763)
%        p4 =     -0.1965  (-0.6394, 0.2464)
       
       
    %% 似乎应该先切分数据？并对子类进行TSP计算
    [Distance, City] = readfile(tspData,1);
    t1 = datetime;
    %聚类，生成标准数据
    [idx C]= kmeans(City,K,'MaxIter',10000);
    Data = [idx City];
    use_data = cell(K,1);
    for i = 1:K
        temp = Data(Data(:,1) == i,:);
        clust_struct.kind = i;
        clust_struct.id = find(Data(:,1) == i);
        clust_struct.length = size(temp,1);
        clust_struct.position = temp(:,[2 3]);
        %迭代和种群参数自适应调整
        varargin = struct('xy',clust_struct.position);
        temp = Tool_CGA_Solver(varargin);
        clust_struct.route = temp.route;
        clust_struct.routeID = clust_struct.id(temp.route);
        clust_struct.uniqL = length(unique(clust_struct.routeID));
        clust_struct.Rlength = temp.length;
        use_data{i} = clust_struct;
    end
    t2 = seconds(datetime - t1);
    %% 初始化参数
    GGAP=0.3;       %代沟概率
    Pc=0.9;         %交叉概率
    Pm=0.05;        %变异概率
    
    MAXGEN= 200+2*round(K*1);
    NIND = 20 + round(K*0.5)*4; %
    CF = 0.9;
    MF_1 = 0.05;
    MF_21 = 0.05;
    MF_22 = 0.05;
    
    mindis = zeros(1,MAXGEN);
    bestind = 0;
    clear temp;
    %% 初始化种群，初始化成两层染色体的一个结构体？
    %第一层表示簇的顺序
    %第二层是一个结构体数组，里面是每个层内的染色体
    for i = 1:NIND
        temp.HigherChrom = randperm(K);
        LowerChrom = cell(K,1);
        for h = 1:K
            %在RouteID 里面随机选择一个点作为起点，然后随机选择前一个或者后一个点作为终点
            LowerChrom{h,1} = use_data{h}.routeID;
            Dlen(h) = use_data{h}.Rlength;
        end
        temp.LowerChrom = LowerChrom;
        temp.length = Dlen;
        Chrom(i) = temp;
    end
   
    gen = 1;
    higherChrom = zeros(NIND,K+1); %含终点
    BKDS = [];
    
    [ttlDistance,FitnV]=All_Fitness(City, Chrom);  %计算路径长度
    [mindisbygen,bestindex] = min(ttlDistance);
    BKDS(gen) = mindisbygen;
    mindis(gen) = mindisbygen; % 最Da适应值fit的集
    bestind = bestindex; % 最优个体集 需要还原成路径吗
    
    vrybC = Chrom(bestindex);
    while gen <= MAXGEN
        %% 计算适应度
        
        
        %% 上层GA计算, 似乎没有什么需要改的
        for i = 1:NIND
            higherChrom(i,1:(end-1)) = Chrom(i).HigherChrom'-1;
            higherChrom(i,end) = higherChrom(i,1);
        end
        SelCh=Select(higherChrom,FitnV,GGAP);
        %% 交叉操作
        
        SelCh=All_Crossover(SelCh,CF);
        %% 变异
        SelCh=Mutate(SelCh,MF_1);
        
        %% 逆转操作,这里由于某些原因不能使用逆转函数
        %SelCh=Reverse(SelCh,Distance);
        
        %% 亲代重插入子代,并对应到指定的lowerchrom
        higherChrom=Reins(higherChrom,SelCh,FitnV);
        
        %% 新一代产生了，计算下一层的变异
        for i = 1:NIND
            Chrom(i).HigherChrom = higherChrom(i,1:(end-1))'+1;
        end
        
        %% 对下层进行变异操作
         for i = 1:NIND
             if rand < MF_21 %这个个人要异变
                for h = 1:K
                    if rand < MF_22 %个体的基因段要异变
                        Chrom(i).LowerChrom{h} = Init_Chrom(use_data{h}.routeID');
                    end
                end
            end
         end
         
        [ttlDistance,FitnV]=All_Fitness(City, Chrom);  %计算路径长度
        [mindisbygen,bestindex] = min(ttlDistance);
        if BKDS(gen) > mindisbygen
            BKDS(gen+1) = mindisbygen;
            vrybC = Chrom(bestindex);
        else
            BKDS(gen+1) = BKDS(gen);
        end
        %BKDS(gen) = mindisbygen;
        mindis(gen) = mindisbygen; % 最Da适应值fit的集
        bestind = bestindex; % 最优个体集 需要还原成路径吗
        
        gen = gen + 1;
        

    end
    mindisever = mindis(end);  % 取得历史最优适应值的位置、最优目标函数值
    bestroute = bestind; % 取得最优个体
    %还原路径
    route = [];
    for i = 1:K
        index = vrybC.HigherChrom(i);
        route = [route; vrybC.LowerChrom{index}];
    end
    %plot(mindis)
    TSP_Solve_Struct.time = seconds(datetime - t1);
    TSP_Solve_Struct.FirstTime = t2;
    TSP_Solve_Struct.length = BKDS(end);
    TSP_Solve_Struct.route = [route;route(1)];
    TSP_Solve_Struct.city = City;
    TSP_Solve_Struct.cate = idx;
    TSP_Solve_Struct.bestline = BKDS;
    %DrawCluster(TSP_Solve_Struct.city, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)
end