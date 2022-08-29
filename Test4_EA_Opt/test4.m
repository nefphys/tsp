%% 先对示例数据进行不同EA参数进行计算，研究得到最适合的EA参数
% 数据存储结构，一组参数，一个10*data的路径 和 时间
clc
clear

EAPAR = [0.3 0.8 5
         0.3 0.8 10
         0.3 0.8 20
         0.5 0.8 5
         0.5 0.8 10
         0.5 0.8 20 
         0.7 0.8 5
         0.7 0.8 10
         0.7 0.8 20 
         0.5 1.2 5
         0.5 1.2 10
         0.5 1.2 20 
         0.7 1.5 5
         0.7 1.5 10
         0.7 1.5 20 
    ];

%% 使用第七组参数 0.7 0.8 5
tarTsp = dir("data");
tarTsp = tarTsp(3:end);

ans_str.length = 0;
ans_str.time = 0;

MaxTspSize = 30; %写死 30 最快
MaxKmeans = 30;
MaxDistNum = 20000;
parthread = 6;

for jj = 1:size(EAPAR,1)
    FCroute = zeros(length(tarTsp), parthread);
    FCtime = zeros(length(tarTsp), parthread);
    FCImp = zeros(length(tarTsp), parthread);
    for i = 1:length(tarTsp)
        tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
        [Distance City] = readfile(tarPath,1);
        parfor h = 1:parthread
            sprintf('%10s',i+"",h+"",tarTsp(i).name,jj+"")
            [TSP_Solve_Struct] = EA_OP_FastClustTSP(City, MaxDistNum, MaxTspSize, MaxKmeans, EAPAR(jj,:));
            FCroute(i,h) = TSP_Solve_Struct.length;
            FCtime(i,h) = TSP_Solve_Struct.time2;
            FCImp(i,h) = TSP_Solve_Struct.bestline(end) / TSP_Solve_Struct.bestline(1);
        end
    end
    ans_str(jj).length = FCroute;
    ans_str(jj).time = FCtime;
    ans_str(jj).Imp = FCImp;
end

save('test4_1.mat', 'ans_str')


rout = [TSP_Solve_Struct.route TSP_Solve_Struct.route(1)];
mdist = 0;
for i = 2:length(rout)
    mdist = mdist + pdist2(City(rout(i-1),:), City(rout(i),:));
end





tarPath = tarTsp(3).folder + "\" + tarTsp(3).name;
[Distance City] = readfile(tarPath,1);
jj = 1;
profile on
[TSP_Solve_Struct] = EA_OP_FastClustTSP(City, MaxDistNum, MaxTspSize, MaxKmeans, EAPAR(jj,:));
profile viewer
profile off


%% 选择一组最好的结果，然后作为参数跑30轮
bestPar = [0.7 0.8 5];
tarTsp = dir("data");
tarTsp = tarTsp(3:end);

ans_str.length = 0;
ans_str.time = 0;

MaxTspSize = 50; %写死
MaxKmeans = 50;
MaxDistNum = 20000;
parthread = 30;
FCroute = zeros(length(tarTsp), parthread);
FCtime = zeros(length(tarTsp), parthread);
for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1);
    parfor h = 1:parthread
        sprintf('%10s',i+"",h+"",tarTsp(i).name)
        [TSP_Solve_Struct] = EA_OP_FastClustTSP(City, MaxDistNum, MaxTspSize, MaxKmeans, EAPAR(jj,:));
        FCroute(i,h) = TSP_Solve_Struct.length;
        FCtime(i,h) = TSP_Solve_Struct.time2;
    end
end
save('test4_2.mat', 'FCroute','FCtime')