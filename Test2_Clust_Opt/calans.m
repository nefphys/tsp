% 时间 距离
% 最优解

% 最差解

% 均值

% 标准差
clc
clear

ans_FC.name = 30;
ans_FC.length = 0;
ans_FC.time = 0;
ans_FC(2) = ans_FC(1);
ans_FC(2).name = 50;
ans_FC(3) = ans_FC(1);
ans_FC(3).name = 100;

ans_FK = ans_FC;


%% 30
load test2_30.mat
stds = zeros(size(FCroute,1),4);
% FC 时间 30
stds(:,1) = min(FCtime,[],2);
stds(:,2) = max(FCtime,[],2);
stds(:,3) = mean(FCtime,2);
stds(:,4) = std(FCtime,0,2);
ans_FC(1).time = stds;

stds = zeros(size(FCroute,1),4);
% FC 长度 30
stds(:,1) = min(FCroute,[],2);
stds(:,2) = max(FCroute,[],2);
stds(:,3) = mean(FCroute,2);
stds(:,4) = std(FCroute,0,2);
ans_FC(1).length = stds;


stds = zeros(size(FKroute,1),4);
% FK 时间 30
stds(:,1) = min(FKtime,[],2);
stds(:,2) = max(FKtime,[],2);
stds(:,3) = mean(FKtime,2);
stds(:,4) = std(FKtime,0,2);
ans_FK(1).time = stds;

stds = zeros(size(FKroute,1),4);
% FK 长度 30
stds(:,1) = min(FKroute,[],2);
stds(:,2) = max(FKroute,[],2);
stds(:,3) = mean(FKroute,2);
stds(:,4) = std(FKroute,0,2);
ans_FK(1).length = stds;

clear FCroute FKtime FCtime FKroute

%% 50
load test2_50.mat
stds = zeros(size(FCroute,1),4);
% FC 时间 30
stds(:,1) = min(FCtime,[],2);
stds(:,2) = max(FCtime,[],2);
stds(:,3) = mean(FCtime,2);
stds(:,4) = std(FCtime,0,2);
ans_FC(2).time = stds;

stds = zeros(size(FCroute,1),4);
% FC 长度 30
stds(:,1) = min(FCroute,[],2);
stds(:,2) = max(FCroute,[],2);
stds(:,3) = mean(FCroute,2);
stds(:,4) = std(FCroute,0,2);
ans_FC(2).length = stds;


stds = zeros(size(FKroute,1),4);
% FK 时间 30
stds(:,1) = min(FKtime,[],2);
stds(:,2) = max(FKtime,[],2);
stds(:,3) = mean(FKtime,2);
stds(:,4) = std(FKtime,0,2);
ans_FK(2).time = stds;

stds = zeros(size(FKroute,1),4);
% FK 长度 30
stds(:,1) = min(FKroute,[],2);
stds(:,2) = max(FKroute,[],2);
stds(:,3) = mean(FKroute,2);
stds(:,4) = std(FKroute,0,2);
ans_FK(2).length = stds;

clear FCroute FKtime FCtime FKroute

%% 100
load test2_100.mat
stds = zeros(size(FCroute,1),4);
% FC 时间 30
stds(:,1) = min(FCtime,[],2);
stds(:,2) = max(FCtime,[],2);
stds(:,3) = mean(FCtime,2);
stds(:,4) = std(FCtime,0,2);
ans_FC(3).time = stds;

stds = zeros(size(FCroute,1),4);
% FC 长度 30
stds(:,1) = min(FCroute,[],2);
stds(:,2) = max(FCroute,[],2);
stds(:,3) = mean(FCroute,2);
stds(:,4) = std(FCroute,0,2);
ans_FC(3).length = stds;


stds = zeros(size(FKroute,1),4);
% FK 时间 30
stds(:,1) = min(FKtime,[],2);
stds(:,2) = max(FKtime,[],2);
stds(:,3) = mean(FKtime,2);
stds(:,4) = std(FKtime,0,2);
ans_FK(3).time = stds;

stds = zeros(size(FKroute,1),4);
% FK 长度 30
stds(:,1) = min(FKroute,[],2);
stds(:,2) = max(FKroute,[],2);
stds(:,3) = mean(FKroute,2);
stds(:,4) = std(FKroute,0,2);
ans_FK(3).length = stds;

clear FCroute FKtime FCtime FKroute




%%%%%%%%%%%pic
ans_per = ans_FC;
for i = 1:3
    for h = 1:4
        ans_per(i).length(:,h) = (ans_FC(i).length(:,h) - ans_FK(i).length(:,h)) ...
            ./ ans_FK(i).length(:,h);
        ans_per(i).time(:,h) = (ans_FC(i).time(:,h) - ans_FK(i).time(:,h)) ...
            ./ ans_FK(i).time(:,h);
    end
end

for i = 1:3
    for h = 1:4
        plot(ans_per(i).length(:,h))
        hold on
    end
end

for i = 1:3
    for h = 1:4
        plot(ans_per(i).time(:,h))
        hold on
    end
end


