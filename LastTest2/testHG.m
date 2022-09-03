%% 40 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 40;
MaxKmeans = 40;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"40")
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FK40_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_40.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');


%% 50 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 50;
MaxKmeans = 50;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"50")
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FK50_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_50.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');


%% 60 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 60;
MaxKmeans = 60;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"60")
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FK60_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_60.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');


%% 70 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 70;
MaxKmeans = 70;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"70")
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FK70_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_70.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');


