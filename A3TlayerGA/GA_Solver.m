function [TSP_Solve_Struct] = GA_Solver(tspData)
[Distance City] = readfile(tspData,1);
    %% 初始化问题参数
CityNum=size(City,1)-1;    %需求点个数

%% 初始化算法参数
NIND=100;       %种群大小
MAXGEN=1500;     %最大遗传代数
GGAP=0.9;       %代沟概率
Pc=0.95;         %交叉概率
Pm=0.05;        %变异概率

%% 为预分配内存而初始化的0矩阵
mindis = zeros(1,MAXGEN);
bestind = zeros(1,CityNum+2);

%% 初始化种群
Chrom=InitPop(NIND,CityNum);

%% 迭代
gen=1;
t1 = cputime;
while gen <= MAXGEN
    %% 计算适应度
    [ttlDistance,FitnV]=Fitness(Distance,Chrom);  %计算路径长度
    [mindisbygen,bestindex] = min(ttlDistance);
    
    mindis(gen) = mindisbygen; % 最小适应值fit的集
	bestind = Chrom(bestindex,:); % 最优个体集
    
    %% 选择
    SelCh=Select(Chrom,FitnV,GGAP);
    %% 交叉操作
    SelCh=Crossover(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 逆转操作
    SelCh=Reverse(SelCh,Distance);
    %% 亲代重插入子代
    Chrom=Reins(Chrom,SelCh,FitnV);
    %% 显示此代信息
    %fprintf('Num of Iterations = %d,  Min Distance = %.2f km \n',gen,mindisbygen)
    %% 更新迭代次数
    gen=gen+1;
end
t2 = cputime;
%% 找出历史最短距离和对应路径
mindisever = mindis(MAXGEN);  % 取得历史最优适应值的位置、最优目标函数值
bestroute = bestind; % 取得最优个体
bestroute(end) = [];

TSP_Solve_Struct.time = t2-t1;
TSP_Solve_Struct.length = mindisever;
TSP_Solve_Struct.route = bestroute'+1; %点下标从1开始
end