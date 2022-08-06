tspData = 'tspdata/pcb442.tsp'
[Distance,City] = readfile(tspData,1);

%concorde 求解器
TSP_Solve_Struct = Concorde_Solver(tspData, 'A1concorde\', 'EUC_2D', 'par.txt')
DrawPath(TSP_Solve_Struct.route,City)
system('taskkill /f /t /im cmd.exe')

%LKH 求解器
TSP_Solve_Struct = LKH_Solver(tspData, 'A2LKH\', 'EUC_2D')
system('taskkill /f /t /im cmd.exe')
DrawPath(TSP_Solve_Struct.route,City)

%双层遗传算法求解器
TSP_Solve_Struct = TLGA_CTSP(tspData,10)
DrawPath(TSP_Solve_Struct.route,City)
DrawCluster(City, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)

%双层蚁群算法求解器
profile on;
TSP_Solve_Struct = TLACS_Solver(tspData,10)
profile viewer;
profile off;
DrawPath(TSP_Solve_Struct.route,City)
%%
% 
%  PREFORMATTED
%  TEXT
% 

%经典遗传算法求解器



%经典蚁群算法求解器



%混合聚类递归蚁群算法求解器



%CGA 不同规模数据参数设置


