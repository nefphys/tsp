%% 测试新提出的进化算法可以解决一些tsp问题 如果真的可以的话。。。。
%  给定城市数据 生成ans_group 数据集

clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 20;
bestPar = [0.3 0.3 10];

EA_ANS = zeros(length(tarTsp), parthread)

for i = 1:length(tarTsp)
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1); 
    ANS_GROUP = City2Group(City);
    calLayer = 10;
    popSize = ceil(min(50+length(ANS_GROUP)*bestPar(1), 150)); %只能为偶数
    if mod(popSize,2) == 0
    else
        popSize = popSize + 1;
    end
    EAmaxIt = min(100 + ceil(length(ANS_GROUP)*bestPar(2)),350);
    optMaxIt = min(1000 + ceil(length(ANS_GROUP)*bestPar(3)),5e4);

    parfor h = 1:parthread
        EA_Struct = EA_2Opt(ANS_GROUP, City, calLayer, popSize, EAmaxIt, optMaxIt);
        EA_ANS(i,h) = EA_Struct.dist;
    end
end
save('EA_ANS.mat','EA_ANS');
