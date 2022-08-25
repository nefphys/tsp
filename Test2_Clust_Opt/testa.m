clc
clear


tarTsp = dir("data");

tarTsp = tarTsp(3:end);

FCroute = zeros(length(tarTsp), 30);
FCtime = zeros(length(tarTsp), 30);

FKroute = zeros(length(tarTsp), 30);
FKtime = zeros(length(tarTsp), 30);

MaxTspSize = 100;
MaxKmeans = 100;
MaxDistNum = 20000;

i = 1;
for i = 1:20
tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
[Distance City] = readfile(tarPath,1);
scatter(City(:,1),City(:,2))
pause(2)
end

LL = 0;
for h = 4:2:20
    h
    CC = 0;
    parfor j = 1:10
        TSP_FC = FastClustTSP(City, MaxDistNum,i*10,i*10);
        CC(j) = TSP_FC.length;
    end
    LL(h) = mean(CC);
end

TSP_FC = FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans);
TSP_FK = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
DrawPath(City,TSP_FC.route)
figure(2)
DrawPath(City,TSP_FK.route)

DrawCluster(City,TSP_FC.cate,TSP_FC.route)
figure(2)
DrawCluster(City,TSP_FK.cate,TSP_FK.route)

%验算距离计算是否正确
dist0 = 0;
dist1 = 0;
RFC = [TSP_FC.route TSP_FC.route(1)];
%RFK = [TSP_FK.route TSP_FK.route(1)];

for i = 2:length(RFC)
    dist0 = dist0 + pdist2(City(RFC(i-1),:),City(RFC(i),:));
    %dist1 = dist1 + pdist2(City(RFK(i-1),:),City(RFK(i),:));
end


parthread = 30;
for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name)
        [TSP_Solve_Struct]  =  FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans);
        FCroute(i,h) = TSP_Solve_Struct.length;
        FCtime(i,h) = TSP_Solve_Struct.time;
        [TSP_Solve_Struct]  = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
        FKroute(i,h) = TSP_Solve_Struct.length;
        FKtime(i,h) = TSP_Solve_Struct.time;
    end
end


