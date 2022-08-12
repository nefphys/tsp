function [TSP_Solve_Struct] = FastClustTSP(tspData,MaxDistNum)
%% 先编写主体框架
% 后续传入聚类参数，智能算法参数，设置智能算法的选择
% tspData 数据路径
% MaxDistNum 最大可计算距离矩阵的大小 n*n, 数据量大于此值则不计算距离矩阵

%算法内智能算法求解TSP最多可以计算999个点的情况


%读取数据
%判断数据量大小，如果数据量大于某个值，则不计算distance
[Distance, City] = readfile(tspData,0);
DataLen = size(City,1); %总数据大小
ID = 1:DataLen; %ID 与CITY对应的，方便后续查找数据
if DataLen < 20000
    [Distance, City] = readfile(tspData,1);
else
    
end

%% 初始化标准结构体
std_struct = struct('inID',0,'outID',0,'set',0,'isover',0,'tsp',0,'order','0');
ANS_GROUP = std_struct;
ANS_GROUP.set = ID;

%% 主循环,可以表示层数，默认最多999层和999个数据
layer = 1; 
while(true)
    % 对结构体中的每个数据进行判断是否计算
    % 双倍内存的形式，生成一个伴生的空结构体
    ANS_GROUP_FAKE = [];
    %是否还需要计算
    isCal = 0;
    for i = 1:length(ANS_GROUP)
        tarStruct = ANS_GROUP(i);
        tempStruct = std_struct;
        %isover==0则需要继续计算，否则返回原来的结构体
        %计算之后返回的也是一个结构体数组, 如果有变化则删除原本的结构体，并拼接新的
        if tarStruct.isover == 0
            isCal = 1;
            %判断集合内点的数量，以确定是聚类还是计算TSP
            setSize = length(tarStruct.set);
            
            % 根据入点和出点数据判断当前结构体是不是第一次进入计算
            if tarStruct.in == 0
                %是第一次进入计算，再判断是否进行聚类
                
                %如果是单点集，则返回当前点
                if setSize == 1
                    tempStruct.in = tarStruct.set;
                    tempStruct.out = tarStruct.set;
                    tempStruct.set = tarStruct.set;
                    tempStruct.isover = 1;
                    tempStruct.tsp = tarStruct.set;
                    tempStruct.order = '0'; %原始点就是单点集，没有计算的必要
                %如果只有两个点，则按顺序返回
                elseif setSize == 2
                    tempStruct.in = tarStruct.set(1);
                    tempStruct.out = tarStruct.set(2);
                    tempStruct.set = tarStruct.set;
                    tempStruct.isover = 1;
                    tempStruct.tsp = tarStruct.set;
                    tempStruct.order = '0'; %原始点就是单点集，没有计算的必要
                %如果点的数量小于200，则计算TSP
                elseif setSize <= 200
                    tempStruct.in = 0;
                    tempStruct.out = 0;
                    tempStruct.set = tarStruct.set;
                    tempStruct.isover = 1;
                    tempStruct.tsp = TSP_Solver(City(tarStruct.set,:)); %调用求解器
                    tempStruct.order = '0';
                %如果点的数量大于200，但是小于10000，则计算密度聚类
                elseif setSize <= 10000
                    tempCity = 
                %如果点的数量大于10000，则进行kmeans聚类
                else
                    
                end
                
            else
                %不是第一次进入计算了，也判断是否进行聚类
            end
        else
            ANS_GROUP_FAKE = [ANS_GROUP_FAKE tarStruct];
        end
    end
    
    %终止条件，只要后面一次循环isover全部是1，即借宿
     if isCal == 0
         break;
     end
     %层数增加
    layer = layer + 1;
end

end