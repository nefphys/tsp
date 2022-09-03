clc
 clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFCroute_Ori = zeros(length(tarTsp), parthread);
EAFCroute = zeros(length(tarTsp), parthread);
EAFCtime = zeros(length(tarTsp), parthread);

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 40;
MaxKmeans = 40;
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
        parsave('ansmat\FC40_',i,h,TSP_Solve_Struct_FC);
        parsave('ansmat\FK40_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_40.mat','EAFCroute','EAFCtime','EAFCroute_Ori','EAFKroute','EAFKtime','EAFKroute_Ori');




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

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
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"50 ", datetime())
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
save('test2_50.mat','EAFCroute','EAFCtime','EAFCroute_Ori','EAFKroute','EAFKtime','EAFKroute_Ori');





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFCroute_Ori = zeros(length(tarTsp), parthread);
EAFCroute = zeros(length(tarTsp), parthread);
EAFCtime = zeros(length(tarTsp), parthread);

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 60;
MaxKmeans = 60;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"60 ",datetime())
        [TSP_Solve_Struct_FC]  =  EA_OP_FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans,bestPar);
        EAFCroute(i,h) = TSP_Solve_Struct_FC.length;
        EAFCtime(i,h) = TSP_Solve_Struct_FC.time2;
        EAFCroute_Ori(i,h) = TSP_Solve_Struct_FC.bestline(1);
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FC60_',i,h,TSP_Solve_Struct_FC);
        parsave('ansmat\FK60_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_60.mat','EAFCroute','EAFCtime','EAFCroute_Ori','EAFKroute','EAFKtime','EAFKroute_Ori');




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

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
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"70 ",datetime())
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
save('test2_70.mat','EAFCroute','EAFCtime','EAFCroute_Ori','EAFKroute','EAFKtime','EAFKroute_Ori');




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data2");
tarTsp = tarTsp(3:end);
parthread = 1;
bestPar = [0.2 0.2 10];

EAFCroute_Ori = zeros(length(tarTsp), parthread);
EAFCroute = zeros(length(tarTsp), parthread);
EAFCtime = zeros(length(tarTsp), parthread);

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 60;
MaxKmeans = 60;
MaxDistNum = 20000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    for h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"big ",datetime())
        [TSP_Solve_Struct_FC]  =  EA_OP_FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans,bestPar);
        EAFCroute(i,h) = TSP_Solve_Struct_FC.length;
        EAFCtime(i,h) = TSP_Solve_Struct_FC.time2;
        EAFCroute_Ori(i,h) = TSP_Solve_Struct_FC.bestline(1);
        [TSP_Solve_Struct_FK]  = EA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FK.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FK.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FK.bestline(1);
        parsave('ansmat\FCbig_',i,h,TSP_Solve_Struct_FC);
        parsave('ansmat\FKbig_',i,h,TSP_Solve_Struct_FK);
    end
end

%记录结果 
save('test2_big.mat','EAFCroute','EAFCtime','EAFCroute_Ori','EAFKroute','EAFKtime','EAFKroute_Ori');

