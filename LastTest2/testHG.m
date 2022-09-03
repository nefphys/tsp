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
        [TSP_Solve_Struct_FG]  = GA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FG.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FG.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FG.bestline(1);
        parsave('ansmat\FK50_',i,h,TSP_Solve_Struct_FG);
    end
end

%记录结果 
save('test2_50.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');











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

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"75")
        [TSP_Solve_Struct_FG]  = GA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FG.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FG.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FG.bestline(1);
        parsave('ansmat\FK75_',i,h,TSP_Solve_Struct_FG);
    end
end

%记录结果 
save('test2_75.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');













%% 100 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 100;
MaxKmeans = 100;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"100")
        [TSP_Solve_Struct_FG]  = GA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FG.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FG.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FG.bestline(1);
        parsave('ansmat\FK100_',i,h,TSP_Solve_Struct_FG);
    end
end

%记录结果 
save('test2_100.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');







%% 125 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 125;
MaxKmeans = 125;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"125")
        [TSP_Solve_Struct_FG]  = GA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FG.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FG.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FG.bestline(1);
        parsave('ansmat\FK125_',i,h,TSP_Solve_Struct_FG);
    end
end

%记录结果 
save('test2_125.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');








%% 125 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.2 0.2 10];

EAFKroute_Ori = zeros(length(tarTsp), parthread);
EAFKroute = zeros(length(tarTsp), parthread);
EAFKtime = zeros(length(tarTsp), parthread);


MaxTspSize = 150;
MaxKmeans = 150;
MaxDistNum = 10000;

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,0);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name,"150")
        [TSP_Solve_Struct_FG]  = GA_OP_FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans,bestPar);
        EAFKroute(i,h) = TSP_Solve_Struct_FG.length;
        EAFKtime(i,h) = TSP_Solve_Struct_FG.time2;
        EAFKroute_Ori(i,h) = TSP_Solve_Struct_FG.bestline(1);
        parsave('ansmat\FK150_',i,h,TSP_Solve_Struct_FG);
    end
end

%记录结果 
save('test2_150.mat','EAFKroute','EAFKtime','EAFKroute_Ori','tarTsp');