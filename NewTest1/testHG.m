clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
bestPar = [0.3 0.4 10];

EAFCroute_Ori = zeros(length(tarTsp), parthread);
EAFCroute = zeros(length(tarTsp), parthread);
EAFCtime = zeros(length(tarTsp), parthread);

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 30;
MaxKmeans = 30;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"30")
        [TSP_Solve_Struct_FC]  =  EA_OP_FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans,bestPar);
        EAFCroute(i,h) = TSP_Solve_Struct_FC.length;
        EAFCtime(i,h) = TSP_Solve_Struct_FC.time2;
        EAFCroute_Ori(i,h) = TSP_Solve_Struct_FC.bestline(1);
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FC30_',i,h,TSP_Solve_Struct_FC);
        parsave('ansmat\FK30_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_30.mat','FCroute','FCtime','FKroute','FKtime');




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
EAFCroute_Ori = zeros(length(tarTsp), parthread);
EAFCroute = zeros(length(tarTsp), parthread);
EAFCtime = zeros(length(tarTsp), parthread);

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);

MaxTspSize = 50;
MaxKmeans = 50;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"50")
        [TSP_Solve_Struct_FC]  =  EA_OP_FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans,bestPar);
        EAFCroute(i,h) = TSP_Solve_Struct_FC.length;
        EAFCtime(i,h) = TSP_Solve_Struct_FC.time2;
        EAFCroute_Ori(i,h) = TSP_Solve_Struct_FC.bestline(1);
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FC50_',i,h,TSP_Solve_Struct_FC);
        parsave('ansmat\FK50_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_50.mat','FCroute','FCtime','FKroute','FKtime');





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
EAFCroute_Ori = zeros(length(tarTsp), parthread);
EAFCroute = zeros(length(tarTsp), parthread);
EAFCtime = zeros(length(tarTsp), parthread);

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);

MaxTspSize = 70;
MaxKmeans = 70;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"70")
        [TSP_Solve_Struct_FC]  =  EA_OP_FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans,bestPar);
        EAFCroute(i,h) = TSP_Solve_Struct_FC.length;
        EAFCtime(i,h) = TSP_Solve_Struct_FC.time2;
        EAFCroute_Ori(i,h) = TSP_Solve_Struct_FC.bestline(1);
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FC70_',i,h,TSP_Solve_Struct_FC);
        parsave('ansmat\FK70_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_70.mat','FCroute','FCtime','FKroute','FKtime');
