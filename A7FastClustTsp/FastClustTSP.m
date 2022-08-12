function [TSP_Solve_Struct] = FastClustTSP(tspData,MaxDistNum)
%% 先编写主体框架
% 后续传入聚类参数，智能算法参数，设置智能算法的选择
% tspData 数据路径
% MaxDistNum 最大可计算距离矩阵的大小 n*n, 数据量大于此值则不计算距离矩阵

%读取数据
%判断数据量大小，如果数据量大于某个值，则不计算distance
[Distance, City] = readfile(tspData,0);
DataLen = size(City,1); %总数据大小
if DataLen < 20000
    [Distance, City] = readfile(tspData,1);
else
    
end

%% 初始化标准结构体
std_struct = struct('inID',0,'outID',0,'set',0,'isover',0,'tsp',0,'order',0);



end