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

tarTsp = dir("data");
tarTsp = tarTsp(3:end);

ans_str.length = 0;
ans_str.time = 0;

MaxTspSize = 50; %写死
MaxKmeans = 50;
MaxDistNum = 20000;
parthread = 10;

for jj = 1:size(EAPAR,1)
    for i = 1:length(tarTsp)
        tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
        [Distance City] = readfile(tarPath,1);
        parfor h = 1:parthread
            sprintf('%10s',i+"",h+"",tarTsp(i).name)
            [TSP_Solve_Struct] = EA_OP_FastClustTSP(tspData, MaxDistNum, MaxTspSize, MaxKmeans, EAPAR);
            FCroute(i,h) = TSP_Solve_Struct.length;
            FCtime(i,h) = TSP_Solve_Struct.time2;
        end
    end
    ans_str(jj).length = FCroute;
    ans_str(jj).time = FCtime;
end

save('test4_1.mat', 'ans_str')

%记录结果 
save('test2_50.mat','FCroute','FCtime','FKroute','FKtime');



