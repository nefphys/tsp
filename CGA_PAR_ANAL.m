%% CGA 参数研究

%% 不同规模的数据集 CGA需要的参数设计

%结果 CGA 参数 迭代次数 300， 种群 0.2， 规模70个点


City = rand(100,2)*10;
%研究自适应参数
citysize = size(City,1);

popPar = 0.05:0.05:0.3;
numPar = 100:100:5e2;


ansMat = zeros(length(popPar),length(numPar))
%目标，得到不同规模数据集的最佳求解参数
for i = 1:length(popPar)
    i
    for h = 1:length(numPar)
        h
        varargin = struct('xy',City, 'popSize', 10+int32(popPar(i)*citysize), 'numIter', int32(numPar(h)*citysize));
        TSP_Solve_Struct = Tool_CGA_Solver(varargin);
        ansMat(i,h) = TSP_Solve_Struct.length;
    end
end

mm = min(min(ansMat));
for i = 1:length(popPar)
    for h = 1:length(numPar)
        ansMat(i,h) = ansMat(i,h)/mm;
    end
end

DrawPath(TSP_Solve_Struct.route,TSP_Solve_Struct.City)

%% 10 最小参数 迭代次数：50 种群0.05

%% 20 最小参数 迭代次数：100 种群0.05

%% 30 最小参数 迭代次数：100 种群0.05

%% 40 最小参数 迭代次数：200 种群0.15

%% 50 最小参数 迭代次数：200 种群0.3
%           迭代次数：500 种群0.1

%% 60 最小参数 迭代次数：300 种群0.15

%% 100 最小参数 迭代次数：400 种群0.2

%推荐参数 迭代次数 500， 种群 0.25
%统计计算时间

BLen = [];
for i = 1:20
%     i
%     City = rand(i*10,2)*10;
%     citysize = size(City,1);
    varargin = struct('xy',City);
    TSP_Solve_Struct = Tool_CGA_Solver(varargin);
    BLen(i) = TSP_Solve_Struct.length;
end
