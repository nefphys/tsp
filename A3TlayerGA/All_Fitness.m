function [ttlDistance,FitnV]=All_Fitness(City,Chrom)
%% 计算各个体的路径长度 适应度函数  
% 输入：
% Distance      两两城市之间的距离
% Chrom         种群矩阵
% 输出：
% ttlDistance	种群个体路径距离组成的向量
% FitnV         个体的适应度值组成的列向量

% 子片段的距离  = 片段回路距离 - 片段端点距离

% 新总距离 = 总子片段的距离 + 所有端点之间的距离
apd = sum(Chrom(1).length);
alld = zeros(length(Chrom),1);



for i = 1:length(Chrom)
    Hchrom = Chrom(i).HigherChrom; %基因片段

    SPEP = zeros(length(Hchrom), 2);
    temp = Chrom(i).LowerChrom;
    for h = 1:length(Hchrom)
        temp1 = temp{h};
        SPEP(h,1) = temp1(1);
        SPEP(h,2) = temp1(end);
    end
    
    alld(i) = apd;
    for h = 1:length(Hchrom)
        %kp = Hchrom(h);
        alld(i) = alld(i) - sqrt((City(SPEP(Hchrom(h),1),1) - City(SPEP(Hchrom(h),2),1))^2 + ...
            (City(SPEP(Hchrom(h),1),2) - City(SPEP(Hchrom(h),2),2))^2);
    end

    for h = 2:length(Hchrom)
        alld(i) = alld(i) + sqrt((City(SPEP(Hchrom(h-1),2),1) - City(SPEP(Hchrom(h),1),1))^2 + ...
            (City(SPEP(Hchrom(h-1),2),2) - City(SPEP(Hchrom(h),1),2))^2);
    end
    alld(i) = alld(i) + sqrt((City(SPEP(Hchrom(1),1),1) - City(SPEP(Hchrom(end),2),1))^2 + ...
            (City(SPEP(Hchrom(1),1),2) - City(SPEP(Hchrom(end),2),2))^2);
    
end

ttlDistance = alld;
FitnV = 1 ./ alld; 
end



% 首先计算每一条路径的距离
% NIND=length(Chrom); %个体数
% ttlDistance=zeros(NIND,1); %分配矩阵内存
% route = zeros(size(Distance,1),1);
% for i = 1:NIND
%     higherlayer = Chrom(i).HigherChrom;
%     J = 1;
%     for h = 1: length(higherlayer)
%         temp = Chrom(i).LowerChrom{higherlayer(h)};
%         L = length(temp);
%         route(J:(J+L-1)) = temp;
%         J = J + L;
%     end
%     % route即为id，然后计算距离
%     rowid = route;
%     colid = [route(2:end); route(1)];
%     mdist = 0;
%     
%     for h = 1:length(route)
%         mdist = mdist  + Distance(rowid(h),colid(h));
%     end
%     ttlDistance(i) = mdist;
% end
% % 然后计算路径的倒数
% FitnV=1./ttlDistance; %适应度函数设为距离倒数

%点运算是处理的元素之间的运算