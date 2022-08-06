function [ttlDistance,FitnV]=All_Fitness(Distance,Chrom)
%% 计算各个体的路径长度 适应度函数  
% 输入：
% Distance      两两城市之间的距离
% Chrom         种群矩阵
% 输出：
% ttlDistance	种群个体路径距离组成的向量
% FitnV         个体的适应度值组成的列向量

% 首先计算每一条路径的距离
NIND=length(Chrom); %个体数
ttlDistance=zeros(NIND,1); %分配矩阵内存
for i = 1:NIND
    route = [];
    higherlayer = Chrom(i).HigherChrom;
    for h = 1: length(higherlayer)
        route = [route;  Chrom(i).LowerChrom{higherlayer(h)}];
    end
    % route即为id，然后计算距离
    rowid = route;
    colid = [route(2:end); route(1)];
    mdist = 0;
    for h = 1:length(route)
        mdist = mdist  + Distance(rowid(h),colid(h));
    end
    ttlDistance(i) = mdist;
end
% 然后计算路径的倒数
FitnV=1./ttlDistance; %适应度函数设为距离倒数
end
%点运算是处理的元素之间的运算