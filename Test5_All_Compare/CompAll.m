%% 比较经典遗传算法 双层遗传算法 双层ACS 以及所 提出来的算法 在TSPLIB数据集上的表现
% 不进行并行化计算




%% 使用TSPlib里面所有的？ 欧几里得2D距离的例子
% CGA 算法太慢了，不用于计算
clc
clear

tarTsp = dir("data");
tarTsp = tarTsp(3:end);

%CGA 参数
varargin = struct('xy',City, 'popSize', 100, 'numIter', 1e3);
CGA_TSP_Solve_Struct = CGA_Solver(varargin);

LKH_TSP_Solve_Struct = LKH_Solver([tarTsp(48).folder '\' tarTsp(48).name], 'A2LKH\', 'EUC_2D')
system('taskkill /f /t /im cmd.exe')
DrawPath(City, LKH_TSP_Solve_Struct.route)

%双层GA 参数

%双层ACS 参数

%所提出的算法 参数

%实验参数
RecTimes = 30;

%结果存储
ans_str.name = 'CGA';
ans_str.route = 0;
ans_str.time = 0;
ans_str = repelem(ans_str, 4);
ans_str(2).name = 'TLGA';
ans_str(3).name = 'TLACS';
ans_str(4).name = 'ERACS';

%% 分别进行计算
%% CGA
Route = zeros(length(tarTsp), RecTimes);
Time = zeros(length(tarTsp), RecTimes);
for i = 1:length(tarTsp)
    parfor h = 1:RecTimes
        TSP_STRUCT = solve();
        Route(i,h) = TSP_STRUCT.length;
        Time(i,h) = TSP_STRUCT.time;
    end
end
ans_str(1).route = Route;
ans_str(1).time = Time;


%% TLGA
Route = zeros(length(tarTsp), RecTimes);
Time = zeros(length(tarTsp), RecTimes);
for i = 1:length(tarTsp)
    parfor h = 1:RecTimes
        TSP_STRUCT = solve();
        Route(i,h) = TSP_STRUCT.length;
        Time(i,h) = TSP_STRUCT.time;
    end
end
ans_str(2).route = Route;
ans_str(2).time = Time;


%% TLACS
Route = zeros(length(tarTsp), RecTimes);
Time = zeros(length(tarTsp), RecTimes);
for i = 1:length(tarTsp)
    parfor h = 1:RecTimes
        TSP_STRUCT = solve();
        Route(i,h) = TSP_STRUCT.length;
        Time(i,h) = TSP_STRUCT.time;
    end
end
ans_str(3).route = Route;
ans_str(3).time = Time;

%% ERACS
Route = zeros(length(tarTsp), RecTimes);
Time = zeros(length(tarTsp), RecTimes);
for i = 1:length(tarTsp)
    parfor h = 1:RecTimes
        TSP_STRUCT = solve();
        Route(i,h) = TSP_STRUCT.length;
        Time(i,h) = TSP_STRUCT.time;
    end
end
ans_str(4).route = Route;
ans_str(4).time = Time;

%记录结果 
save('test5_1.mat','ans_str');

