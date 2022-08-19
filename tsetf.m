addpath(genpath('.\IATools'));
addpath(genpath('.\Tools'));

%删除路径
rmpath(genpath('.\IATools'));
rmpath(genpath('.\Tools'));

%profile on viewer off 性能分析工具


tspData = 'tspdata/tsplib/pcb3038.tsp'
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
varargin = struct('xy',City);
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
TLACS_TSP_Solve_Struct = TLACS_Solver(City,int32(size(City,1)/20))
%profile viewer
cd('..\')
DrawCluster(City, TLACS_TSP_Solve_Struct.cate, TLACS_TSP_Solve_Struct.route)


%% 双层并行蚁群算法求解器 ,时间还需要优化，结果已经相近
cd('.\A4TL_ACS_Solver')
%profile on
TLACS_PAR_TSP_Solve_Struct = TLACS_PAR_Solver(City,int32(size(City,1)/20))
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





EA_FC_TSP_Solve_Struct = EA_OP_FastClustTSP(City,10000);
save('City.mat','City')
save('ANS_GROUP.mat','ANS_GROUP');
load('City.mat')
load('ANS_GROUP.mat')
profile on 
tic
temp = Tool_Tabu_FC(City, ANS_GROUP);
toc
profile viewer

Tool_Tabu_FC(City, ANS_GROUP)


%验算解是否完整
for i = 1:100
    if length(unique(CandiSolu{i}(:,1))) == 61
    else
        i
    end
end

profile on
[Tabu] = Tool_Tabu_FC(City, ANS_GROUP)
profile viewer

t = 0;


tic
for i = 1:1e7
    if isequal(1:10,1:10)
        t = 1;
    end
end
toc
