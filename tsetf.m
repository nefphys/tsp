addpath(genpath('.\IATools'));
addpath(genpath('.\Tools'));

%删除路径
rmpath(genpath('.\IATools'));
rmpath(genpath('.\Tools'));

%profile on viewer off 性能分析工具


tspData = 'tspdata/tsplib/dsj1000.tsp'
[Distance,City] = readfile(tspData,1);

%% concorde 求解器
TSP_Solve_Struct = Concorde_Solver(tspData, 'A1concorde\', 'EUC_2D', 'par.txt')
DrawPath(TSP_Solve_Struct.route,City)
system('taskkill /f /t /im cmd.exe')

%% LKH 求解器
TSP_Solve_Struct = LKH_Solver(tspData, 'A2LKH\', 'EUC_2D')
system('taskkill /f /t /im cmd.exe')
DrawPath(City,TSP_Solve_Struct.route)

%% CGA 求解器
varargin = struct('xy',City);
TSP_Solve_Struct = Tool_CGA_Solver(varargin);
DrawPath(City,TSP_Solve_Struct.route)

%% ACS 求解器
TSP_Solve_Struct = Tool_ACS_Solver(City,0);
DrawPath(City,TSP_Solve_Struct.route)

%% ACS_SE 带有指定起点和终点的求解器
TSP_Solve_Struct = Tool_ACS_SE_Solver(City,5,30,0);
DrawPath(City,TSP_Solve_Struct.route)

%% 双层遗传算法求解器，切换目录
cd('.\A3TlayerGA')
TSP_Solve_Struct = TLGA_CTSP(City,10)
cd('..\')
DrawCluster(City, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)


%% 双层蚁群算法求解器 ,时间还需要优化，结果已经相近
cd('.\A4TL_ACS_Solver')
profile on
TSP_Solve_Struct2 = TLACS_Solver(City,50)
profile viewer
cd('..\')
DrawCluster(City, TSP_Solve_Struct2.cate, TSP_Solve_Struct2.route)


%% 混合聚类递归蚁群算法求解器
profile on
cd('.\A7FastClustTsp')
[TSP_Solve_Struct1] = FastClustTSP(City,10000);
cd('..\')
profile viewer
DrawCluster(City, TSP_Solve_Struct1.cate, TSP_Solve_Struct1.route)

