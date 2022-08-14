addpath(genpath('.\IATools'));
addpath(genpath('.\Tools'));

%删除路径
rmpath(genpath('.\IATools'));
rmpath(genpath('.\Tools'));

%profile on viewer off 性能分析工具


tspData = 'tspdata/pcb442.tsp'
[Distance,City] = readfile(tspData,1);

%% concorde 求解器
TSP_Solve_Struct = Concorde_Solver(tspData, 'A1concorde\', 'EUC_2D', 'par.txt')
DrawPath(TSP_Solve_Struct.route,City)
system('taskkill /f /t /im cmd.exe')

%% LKH 求解器
TSP_Solve_Struct = LKH_Solver(tspData, 'A2LKH\', 'EUC_2D')
system('taskkill /f /t /im cmd.exe')
DrawPath(TSP_Solve_Struct.route,City)

%% CGA 求解器
varargin = struct('xy',City, 'popSize', 30, 'numIter', 1e4);
TSP_Solve_Struct = Tool_CGA_Solver(varargin);
DrawPath(TSP_Solve_Struct.route,City)

%% ACS 求解器
TSP_Solve_Struct = Tool_ACS_Solver(City,10,0);
DrawPath(TSP_Solve_Struct.route,City)

%% ACS_SE 带有指定起点和终点的求解器
TSP_Solve_Struct = Tool_ACS_Solver(City,5,5,30,0);
DrawPath(TSP_Solve_Struct.route,City)

%% 双层遗传算法求解器，切换目录
cd('.\A3TlayerGA')
TSP_Solve_Struct = TLGA_CTSP(City,10)
cd('..\')
DrawPath(TSP_Solve_Struct.route,City)
DrawCluster(City, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)

%% 双层蚁群算法求解器
cd('.\A4TL_ACS_Solver')
TSP_Solve_Struct = TLACS_Solver(City,10)
cd('..\')
DrawPath(TSP_Solve_Struct.route,City)
DrawCluster(City, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)


%% 混合聚类递归蚁群算法求解器
cd('.\A7FastClustTsp')
[TSP_Solve_Struct] = FastClustTSP(City,10000);
cd('..\')
DrawCluster(City, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)
DrawPath([TSP_Solve_Struct.route]-1,TSP_Solve_Struct.City)


