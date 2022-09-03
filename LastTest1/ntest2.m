%% 测试新提出的进化算法可以解决一些tsp问题 如果真的可以的话。。。。
%  给定城市数据 生成ans_group 数据集

clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;
bestPar = [0.4 0.4 10];

EA_ANS = zeros(length(tarTsp), parthread);

for i = 1:length(tarTsp)
    sprintf('%s', datetime(), ' _', num2str(i))
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1); 
    ANS_GROUP = City2Group(City);
    calLayer = 100;
    popSize = ceil(min(30+length(ANS_GROUP)*bestPar(1), 200)); %只能为偶数
    if mod(popSize,2) == 0
    else
        popSize = popSize + 1;
    end
    EAmaxIt = min(30 + ceil(length(ANS_GROUP)*bestPar(2)),350);
    optMaxIt = min(1000 + ceil(length(ANS_GROUP)*bestPar(3)),1e4);
    parfor h = 1:parthread
        sprintf('%s', datetime(), ' _i = ', num2str(i), ' _h = ', num2str(h))
        EA_Struct = EA_2Opt(ANS_GROUP, City, calLayer, popSize, EAmaxIt, optMaxIt);
        EA_ANS(i,h) = EA_Struct.dist;
        parsave('ansmat\EA_',i,h,EA_Struct);
    end
end

save('EA_ANS.mat','EA_ANS','tarTsp');