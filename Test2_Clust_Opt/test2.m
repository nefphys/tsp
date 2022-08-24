clc
clear


tarTsp = dir("data");

tarTsp = tarTsp(3:end);

FCroute = zeros(length(tarTsp), 30);
FCtime = zeros(length(tarTsp), 30);

FKroute = zeros(length(tarTsp), 30);
FKtime = zeros(length(tarTsp), 30);

MaxTspSize = 50;
MaxKmeans = 50;
MaxDistNum = 20000;

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

%记录结果 
save('test2_50.mat','FCroute','FCtime','FKroute','FKtime');


%%%%%%%%%%%%%%%%%%%%%%%%%%%% 30
clc
clear


tarTsp = dir("data");

tarTsp = tarTsp(3:end);

FCroute = zeros(length(tarTsp), 30);
FCtime = zeros(length(tarTsp), 30);

FKroute = zeros(length(tarTsp), 30);
FKtime = zeros(length(tarTsp), 30);

MaxTspSize = 30;
MaxKmeans = 30;
MaxDistNum = 20000;

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

%记录结果 
save('test2_30.mat','FCroute','FCtime','FKroute','FKtime');



%%%%%%%%%%%%%%%%%%%%%%%%%%%% 30
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

%记录结果 
save('test2_100.mat','FCroute','FCtime','FKroute','FKtime');