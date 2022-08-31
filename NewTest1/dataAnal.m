%% 载入数据 进行分析

%% 3个K值分组

%% K = 30
%FC 均值
FC = [];
FC(:,1) = mean(EAFCroute_Ori, 2);
%最优
FC(:,2) = max(EAFCroute_Ori, [], 2);
%最差
FC(:,3) = min(EAFCroute_Ori, [], 2);
%标准差
FC(:,4) = std(EAFCroute_Ori, [], 2);

%EAFC 均值
EAFC = [];
EAFC(:,1) = mean(EAFCroute, 2);
%最优
EAFC(:,2) = max(EAFCroute, [], 2);
%最差
EAFC(:,3) = min(EAFCroute, [], 2);
%标准差
EAFC(:,4) = std(EAFCroute, [], 2);

%FK 均值
FK = [];
FK(:,1) = mean(EAFKroute_Ori, 2);
%最优
FK(:,2) = max(EAFKroute_Ori, [], 2);
%最差
FK(:,3) = min(EAFKroute_Ori, [], 2);
%标准差
FK(:,4) = std(EAFKroute_Ori, [], 2);

%eaFK 均值
EAFK = [];
EAFK(:,1) = mean(EAFKroute, 2);
%最优
EAFK(:,2) = max(EAFKroute, [], 2);
%最差
EAFK(:,3) = min(EAFKroute, [], 2);
%标准差
EAFK(:,4) = std(EAFKroute, [], 2);


amp = [FC, EAFC, FK, EAFK];
%% K = 50


%% K = 70