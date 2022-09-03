%% 测试新提出的进化算法可以解决一些tsp问题 如果真的可以的话。。。。
%  给定城市数据 生成ans_group 数据集

clc
clear
tarTsp = dir("data");
tarTsp = tarTsp(3:end);
parthread = 30;

EA_ANS = zeros(length(tarTsp), parthread);

for i = 1:length(tarTsp)
    sprintf('%s', datetime(), ' _', num2str(i))
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1); 
    parfor h = 1:parthread
        sprintf('%s', datetime(), ' _i = ', num2str(i), ' _h = ', num2str(h))
        GA2Opt_Struct = GA2Opt(City);
        EA_ANS(i,h) = GA2Opt_Struct.length;
        parsave('ansmat\EA_',i,h,EA_Struct);
    end
end

save('EA_ANS.mat','EA_ANS','tarTsp');