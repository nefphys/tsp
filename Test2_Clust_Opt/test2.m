clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
FCroute = zeros(length(tarTsp), parthread);
FCtime = zeros(length(tarTsp), parthread);

FKroute = zeros(length(tarTsp), parthread);
FKtime = zeros(length(tarTsp), parthread);

MaxTspSize = 20;
MaxKmeans = 20;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"20")
        [TSP_Solve_Struct]  =  FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans);
        FCroute(i,h) = TSP_Solve_Struct.length;
        FCtime(i,h) = TSP_Solve_Struct.time;
        [TSP_Solve_Struct]  = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
        FKroute(i,h) = TSP_Solve_Struct.length;
        FKtime(i,h) = TSP_Solve_Struct.time;
    end
end

%记录结果 
save('test2_20.mat','FCroute','FCtime','FKroute','FKtime');




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
FCroute = zeros(length(tarTsp), parthread);
FCtime = zeros(length(tarTsp), parthread);

FKroute = zeros(length(tarTsp), parthread);
FKtime = zeros(length(tarTsp), parthread);

MaxTspSize = 35;
MaxKmeans = 35;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"35")
        [TSP_Solve_Struct]  =  FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans);
        FCroute(i,h) = TSP_Solve_Struct.length;
        FCtime(i,h) = TSP_Solve_Struct.time;
        [TSP_Solve_Struct]  = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
        FKroute(i,h) = TSP_Solve_Struct.length;
        FKtime(i,h) = TSP_Solve_Struct.time;
    end
end

%记录结果 
save('test2_35.mat','FCroute','FCtime','FKroute','FKtime');





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
FCroute = zeros(length(tarTsp), parthread);
FCtime = zeros(length(tarTsp), parthread);

FKroute = zeros(length(tarTsp), parthread);
FKtime = zeros(length(tarTsp), parthread);

MaxTspSize = 50;
MaxKmeans = 50;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"50")
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
