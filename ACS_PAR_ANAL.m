%% ACS 参数研究

%% 不同规模的数据集 ACS

%结果 ACS 参数 迭代次数 300， 种群 0.2， 规模70个点


City = rand(50,2)*10;
%研究自适应参数
citysize = size(City,1);

popPar = 0.05:0.05:0.4;
numPar = 5:5:40;


ansMat = zeros(length(popPar),length(numPar))
%目标，得到不同规模数据集的最佳求解参数
for i = 1:length(popPar)
    i
    for h = 1:length(numPar)
        h
        TSP_Solve_Struct = Tool_ACS_Solver(City,numPar(h)*citysize,int32(popPar(i)*citysize),0);
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

%% 10 最小参数 迭代次数：15 种群0.2
%               迭代次数：20 种群0.05

%% 20 最小参数 迭代次数：10 种群0.3

%% 30 最小参数 迭代次数：15 种群0.25

%% 40 最小参数 迭代次数：15 种群0.15

%% 50 最小参数 迭代次数：20 种群0.25
%           迭代次数：500 种群0.1

%% 60 最小参数 迭代次数：300 种群0.15

%% 100 最小参数 迭代次数：400 种群0.2

%推荐参数 迭代次数 300， 种群 0.2
%统计计算时间

Ctime = [];
for i = 1:8
    i
    City = rand(i*10,2)*10;
    citysize = size(City,1);
   
    TSP_Solve_Struct = Tool_ACS_Solver(City,0);
    Ctime(i) = TSP_Solve_Struct.time;
end
plot(Ctime)


i = 5
City = rand(i*10,2)*10;
citysize = size(City,1);
profile on


for h = 1:20
    TSP_Solve_Struct = Tool_ACS_Solver(City,0);
    Alen(h) = TSP_Solve_Struct.length;
end
profile viewer
profile off