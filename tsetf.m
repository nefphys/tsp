addpath(genpath('.\IATools'));
addpath(genpath('.\Tools'));

%删除路径 
rmpath(genpath('.\IATools'));
rmpath(genpath('.\Tools'));

%profile on viewer off 性能分析工具


tspData = 'tspdata/tsplib/rl11849.tsp'
[Distance,City] = readfile(tspData,1);

%% concorde 求解器
Con_TSP_Solve_Struct = Concorde_Solver(tspData, 'A1concorde\', 'EUC_2D', 'par.txt')
DrawPath(City, Con_TSP_Solve_Struct.route)
system('taskkill /f /t /im cmd.exe')

%% LKH 求解器
LKH_TSP_Solve_Struct = LKH_Solver(tspData, 'A2LKH\', 'EUC_2D')
system('taskkill /f /t /im cmd.exe')
DrawPath(City, LKH_TSP_Solve_Struct.route)

%% CGA 求解器
varargin = struct('xy',City, 'popSize', 100, 'numIter', 1e3);
CGA_TSP_Solve_Struct = Tool_CGA_Solver(varargin);
DrawPath(City,CGA_TSP_Solve_Struct.route)

%% ACS 求解器
ACS_TSP_Solve_Struct = Tool_ACS_Solver(City,0);
DrawPath(City,ACS_TSP_Solve_Struct.route)

%% ACS_SE 带有指定起点和终点的求解器
ACS_SE_TSP_Solve_Struct = Tool_ACS_SE_Solver(City,5,30,0);
DrawPath(City,ACS_SE_TSP_Solve_Struct.route)

%% 双层遗传算法求解器，切换目录
cd('.\A3TlayerGA')
TLGA_TSP_Solve_Struct = TLGA_CTSP(City,10)
cd('..\')
DrawCluster(City, TLGA_TSP_Solve_Struct.cate, TLGA_TSP_Solve_Struct.route)


%% 双层并行遗传算法求解器，切换目录
cd('.\A3TlayerGA')
TLGA_PAR_TSP_Solve_Struct = TLGA_PAR_CTSP(City,10)
cd('..\')
DrawCluster(City, TLGA_PAR_TSP_Solve_Struct.cate, TLGA_PAR_TSP_Solve_Struct.route)


%% 双层蚁群算法求解器 ,时间还需要优化，结果已经相近
cd('.\A4TL_ACS_Solver')
%profile on
TLACS_TSP_Solve_Struct = TLACS_Solver(City,60);
%profile viewer
cd('..\')
DrawCluster(City, TLACS_TSP_Solve_Struct.cate, TLACS_TSP_Solve_Struct.route)


%% 双层并行蚁群算法求解器 ,时间还需要优化，结果已经相近
cd('.\A4TL_ACS_Solver')
%profile on
TLACS_PAR_TSP_Solve_Struct = TLACS_PAR_Solver(City,60)
%profile viewer
cd('..\')
DrawCluster(City, TLACS_PAR_TSP_Solve_Struct.cate, TLACS_PAR_TSP_Solve_Struct.route)


%% 混合聚类递归蚁群算法求解器
%profile on
cd('.\A7FastClustTsp')
profile on
AQ = 0;
for i = 1:10
    FC_TSP_Solve_Struct = FastClustTSP(City,10000);
    AQ(i) = FC_TSP_Solve_Struct.length;
end

profile viewer
profile off
cd('..\')
%profile viewer
DrawCluster(City, FC_TSP_Solve_Struct.cate, FC_TSP_Solve_Struct.route)
DrawPath(City,FC_TSP_Solve_Struct.route)


%% 并行混合聚类递归蚁群算法求解器
%profile on
cd('.\A7FastClustTsp')
FC_PAR_TSP_Solve_Struct = FastClustPARTSP(City,10000);
cd('..\')
%profile viewer
DrawCluster(City, FC_PAR_TSP_Solve_Struct.cate, FC_PAR_TSP_Solve_Struct.route)
DrawPath(City,FC_PAR_TSP_Solve_Struct.route)

%% 并行混合聚类蚁群算法+Tabu进化优化

EA_PAR_FC_TSP_Solve_Struct = EA_PAR_OP_FastClustTSP(City,10000);
plot(Tabu_PAR_FC_TSP_Solve_Struct.TabuLine)

[TSP_Struct] = Sopt2(Tabu_PAR_FC_TSP_Solve_Struct.route, City)

save('ANS_GROUP.mat','ANS_GROUP')
save('City.mat','City')


%%
profile on
[EA_OP_FastClustTSP_S] = EA_OP_FastClustTSP(City, 10000);
profile viewer
profile off

profile on
EA_Struct = EA_2Opt(ANS_GROUP, City, 4, 50, 10, 1000);
profile viewer
profile off

[route1 dist1] = Cal_New_Dist(New_Group, Chrom(1:(end-1)), City);

dist0 = 0;
route0 = EA_OP_FastClustTSP_S.route(1:(end-1));
route0 = [route0 route0(1)];
for i = 2:length(route0)
    dist0 = dist0 + pdist2(City(route0(i-1),:), City(route0(i),:));
end


for jk = 1:30
    [TSP_Solve_Struct]  = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
end