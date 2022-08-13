function [TSP_Solve_Struct] = FastClustTSP(tspData,MaxDistNum)
%% 先编写主体框架
% 后续传入聚类参数，智能算法参数，设置智能算法的选择
% tspData 数据路径
% MaxDistNum 最大可计算距离矩阵的大小 n*n, 数据量大于此值则不计算距离矩阵
% 计算TSP则不改变层数，不赋值TSP则改变层数
%算法内智能算法求解TSP最多可以计算999个点的情况

MaxTspSize = 100;%可计算的最大规模TSP
MaxKmeans = 100;%kmeans最大K值
StdKmeans = 500;%kmeans数据集分割大小
MaxDP = 10000;%基于密度聚类的最大点集
%读取数据
%判断数据量大小，如果数据量大于某个值，则不计算distance
[Distance, City] = readfile(tspData,0);
DataLen = size(City,1); %总数据大小
ID = 1:DataLen; %ID 与CITY对应的，方便后续查找数据
if DataLen < MaxDistNum
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
            
            %% 根据入点和出点数据判断当前结构体是不是第一次进入计算
            if tarStruct.inID == 0
                %是第一次进入计算，再判断是否进行聚类
                %如果不需要聚类，则直接返回TSP计算结果
                %如果需要聚类，则这部分不计算TSP
                
                %如果是单点集，则返回当前点
                if setSize == 1
                    tempStruct.inID = tarStruct.set;
                    tempStruct.outID = tarStruct.set;
                    tempStruct.set = tarStruct.set;
                    tempStruct.isover = 1;
                    tempStruct.tsp = tarStruct.set;
                    tempStruct.order = '0'; %原始点就是单点集，没有计算的必要
                %如果只有两个点，则按顺序返回
                elseif setSize == 2
                    tempStruct.inID = tarStruct.set(1);
                    tempStruct.outID = tarStruct.set(2);
                    tempStruct.set = tarStruct.set;
                    tempStruct.isover = 1;
                    tempStruct.tsp = tarStruct.set;
                    tempStruct.order = '0'; %原始点就是单点集，没有计算的必要
                %如果点的数量小于200，则计算TSP
                elseif setSize <= MaxTspSize
                    tempStruct.inID = 0;
                    tempStruct.outID = 0;
                    tempStruct.set = tarStruct.set;
                    tempStruct.isover = 1;
                    tempStruct.tsp = TSP_Solver(City(tarStruct.set,:)); %调用求解器
                    tempStruct.order = '0';
                %如果点的数量大于200，但是小于10000，则计算密度聚类
                else
                    tempCity = City(tarStruct.set,:); %先读取当前城市数据
                    if setSize <= MaxDP
                        tempCityDist = squareform(pdist(tempCity));
                        %基于密度聚类，只需要返回聚类中心，每个点的类别
                        %传入点坐标，点之间的距离矩阵，K，中心点数
                        %返回一个结构体，包含
                        %NC 簇数
                        %K 参数K
                        %cluster 一个数组，每个点对应的分类，最小为1
                        %center 中心点的id
                        Centers = ceil(setSize/MaxTspSize);
                        K = 10;
                        Clust_Ans = SnnDpc(tempCity,1:setSize,K,'AutoPick',...
                            Centers,'Distance',tempCityDist,'Ui',false);
                        [ACS_TEMP_SOLVE]  =  ACS_Solver(tempCity(Clust_Ans.center,:), 300, 0);
                    else
                        %如果点的数量大于10000，则进行kmeans聚类
                        Centers = min(MaxKmeans,ceil(setSize/StdKmeans));
                        [cidx, cc] = kmeans(tempCity,Centers);
                        Clust_Ans.cluster = cidx;
                        Clust_Ans.center = cc;
                        [ACS_TEMP_SOLVE]  =  ACS_Solver(Clust_Ans.center, 300, 0);
                    end
                    
                    %生成一个Centers个结构体数组
                    tempStruct = repmat(std_struct,1,Centers);
                    for h = 1:Centers
                        %子集应该是原本tempstruct中的项
                        tempStruct(h).set = tarStruct.set(Clust_Ans.cluster == h);
                    end
                    %寻找这一层的TSP路径
                    %方法1：直接用中心点坐标表示路径，然后用相邻最近点作为出点和入点
                    
                    %对团簇的order进行赋值
                    for h = 1:Centers
                        tempStruct(h).order = [num2str(layer,'%03d') ...
                            num2str(find(ACS_TEMP_SOLVE.route==h),'%03d')];
                    end
                    %使用两个簇最近的点作为入点和出点 wu2021
                    for h = 2:Centers
                        [minDist C1 C2] = setMinDist(City(tempStruct(h-1).set,:),City(tempStruct(h).set,:));
                        tempStruct(h-1).outID = tempStruct(h-1).set(C1);
                        tempStruct(h).inID = tempStruct(h).set(C2);
                    end
                    [minDist C1 C2] = setMinDist(City(tempStruct(Centers).set,:),...
                            City(tempStruct(1).set,:));
                    tempStruct(Centers).outID = tempStruct(Centers).set(C1);
                    tempStruct(1).inID = tempStruct(1).set(C2);
                    %方法2：各团簇之间的距离用两个簇之间最短距离表示 
                    %方法3：利用近似距离计算
                    %方法4：hausdorff度量
                end
                
            else
                %不是第一次进入计算了，聚类之后的结果了，也判断是否进行聚类
                if setSize == 1 %聚类之后出现单点集
                    %单点集直接返回值，不改变层数
                    tempStruct = tarStruct;
                    tempStruct.isover = 1;
                    tempStruct.tsp = tarStruct.set;
                elseif setSize == 2 %聚类之后只有两个点
                    tempStruct = tarStruct;
                    tempStruct.isover = 1;
                    tempStruct.tsp = [tarStruct.inID tarStruct.outID];
                elseif setSize <= MaxTspSize %聚类点集小于100
                    tempStruct = tarStruct;
                    tempStruct.isover = 1;
                    [ACS_TEMP_SOLVE]  =  ACS_SE_Solver(City(tempStruct.set,:),...
                        300, find(tempStruct.set==tempStruct.inID),...
                        find(tempStruct.set==tempStruct.outID), 0);
                    tempStruct.tsp = tempStruct.set(ACS_TEMP_SOLVE.route);
                else %聚类之后是大点集
                    %含有起点和终点的大数据集聚类
                    if setSize <= MaxDP
                        
                    else
                        
                    end
                end
                %如果点的数量小于100，则进行计算TSP
                
                %如果点的数量大于100，则进行聚类，只是需要增加判断是否有起点
            end
            ANS_GROUP_FAKE = [ANS_GROUP_FAKE tempStruct];
        else
            ANS_GROUP_FAKE = [ANS_GROUP_FAKE tarStruct];
        end
        %重新赋值ans_group
        ANS_GROUP = ANS_GROUP_FAKE;
    end
    
    %终止条件，只要后面一次循环isover全部是1，即借宿
     if isCal == 0
         break;
     end
     %层数增加
    layer = layer + 1;
end

end




















