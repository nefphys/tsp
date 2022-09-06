%% 比较算法 双层遗传算法 双层ACS算法 所提出算法

%% 添加路径
addpath(genpath('..\IATools'));
addpath(genpath('..\Tools'));
addpath(genpath('..\GAOP'));
addpath(genpath('..\A3TlayerGA'));

%% TLGA 测试
ss = [];
for h = 1:20
    n = h*10
    ACity = City(1:n,:);
    varargin = struct('xy',ACity);
    TSP_Solve_Struct = Tool_CGA_Solver(varargin)
    DrawPath(ACity,TSP_Solve_Struct.route)
    ss(h) = TSP_Solve_Struct.time;
end
sk = 10*(1:20);

d = 0;
for i = 2:length(TSP_Solve_Struct.route)
    d = d + pdist2(ACity(TSP_Solve_Struct.route(i-1),:),ACity(TSP_Solve_Struct.route(i),:))
end
d = d + pdist2(ACity(TSP_Solve_Struct.route(1),:),ACity(TSP_Solve_Struct.route(end),:))
ss = [];
%% 测试上层GA的速度
for i = 1:20
    n = i*10
    TSP_Solve_Struct_TLGA = TLGA_CTSP(City, n)
    ss(i) = TSP_Solve_Struct_TLGA.time - TSP_Solve_Struct_TLGA.FirstTime;
end

profile on 
    TSP_Solve_Struct_TLGA = TLGA_CTSP(City, 500)
profile viewer
profile off


%% 75 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 75;
MaxKmeans = 75;
MaxDistNum = 10000;

TLK = 20;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"75")
        [TSP_Solve_Struct_FG]  = GA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FG.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FG.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FG.bestline(1);
        TSP_Solve_Struct_TLGA = TLGA_CTSP(City, 10);
        parsave('ansmat\FK75_',i,h,TSP_Solve_Struct_FG);
    end
end

%记录结果 
save('test2_75.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');




%% 删除路径 
rmpath(genpath('..\IATools'));
rmpath(genpath('..\Tools'));
rmpath(genpath('..\GAOP'));