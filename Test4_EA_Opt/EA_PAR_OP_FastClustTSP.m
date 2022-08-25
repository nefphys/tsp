function [TSP_Solve_Struct] = EA_OP_FastClustTSP(tspData, MaxDistNum, MaxTspSize, MaxKmeans, EAPAR)
%% 先编写主体框架
% 后续传入聚类参数，智能算法参数，设置智能算法的选择
% tspData 数据路径
% MaxDistNum 最大可计算距离矩阵的大小 n*n, 数据量大于此值则不计算距离矩阵
% 计算TSP则不改变层数，不赋值TSP则改变层数
%算法内智能算法求解TSP最多可以计算999个点的情况
stp = tic;
%MaxTspSize = 50;%可计算的最大规模TSP
%MaxKmeans = 50;%kmeans最大K值
StdKmeans = 500;%kmeans数据集分割大小
MaxDP = 10000;%基于密度聚类的最大点集
ACSTimes = 5;
DPTSPTimes = 1;%倍数，防止只有极少个聚类中心
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
    parfor i = 1:length(ANS_GROUP)
        tarStruct = ANS_GROUP(i);
        tempStruct = std_struct;
        %isover==0则需要继续计算，否则返回原来的结构体
        %计算之后返回的也是一个结构体数组, 如果有变化则删除原本的结构体，并拼接新的
        if tarStruct.isover == 0
            isCal(i) = 1;
            %判断集合内点的数量，以确定是聚类还是计算TSP
            setSize = length(tarStruct.set);
            
            
            %% 简洁版本
            
            %% 原始数据就是单点集，直接返回
            if tarStruct.inID == 0 && setSize == 1
                tempStruct.inID = tarStruct.set;
                tempStruct.outID = tarStruct.set;
                tempStruct.set = tarStruct.set;
                tempStruct.isover = 1;
                tempStruct.tsp = tarStruct.set;
                tempStruct.order = '0'; %原始点就是单点集，没有计算的必要

            
            %% 原始数据只有两个点
            elseif tarStruct.inID == 0 && setSize == 2
                tempStruct.inID = tarStruct.set(1);
                tempStruct.outID = tarStruct.set(2);
                tempStruct.set = tarStruct.set;
                tempStruct.isover = 1;
                tempStruct.tsp = tarStruct.set;
                tempStruct.order = '0'; 

            
            %% 原始数据少于 MaxTspSize 指定的TSP最大规模
            elseif tarStruct.inID == 0 && setSize <= MaxTspSize && setSize > 2
                tempStruct.inID = 0;
                tempStruct.outID = 0;
                tempStruct.set = tarStruct.set;
                tempStruct.isover = 1;
                tempStruct.tsp = TSP_Solver(City(tarStruct.set,:)); %调用求解器
                tempStruct.order = '0';
                
                
            %% 聚类之后的数据，单点集
            elseif tarStruct.inID ~= 0 && setSize == 1
                tempStruct = tarStruct;
                tempStruct.isover = 1;
                tempStruct.tsp = tarStruct.set;
            
                
            %% 聚类之后的数据，两个点
            elseif tarStruct.inID ~= 0 && setSize == 2
                tempStruct = tarStruct;
                tempStruct.isover = 1;
                tempStruct.tsp = [tarStruct.inID tarStruct.outID];
            
            %% 有起点和终点，聚类过的数据，且数据规模小于指定的TSP最大规模    
            elseif tarStruct.inID ~= 0 && setSize <= MaxTspSize && setSize > 2
                %没有聚类则没有多出来的层数，只需要计算tsp和isover
                tempStruct = tarStruct;
                tempStruct.isover = 1;
                [ACS_TEMP_SOLVE]  =  Tool_ACS_SE_Solver(City(tempStruct.set,:),...
                         find(tempStruct.set==tempStruct.inID),...
                        find(tempStruct.set==tempStruct.outID), 0);
                tempStruct.tsp = tempStruct.set(ACS_TEMP_SOLVE.route);
             
            %% 不管是否第一次进入，数据量都大于指定TSP求解规模
            else
                %先判断是否数据规模足够大，防止错误判断
                if(setSize <= MaxTspSize)
                    mer = '不应该进入到这里'
                end
                
                %判断聚类方式
                %赋值in out set order
                tempCity = City(tarStruct.set,:); %先读取当前城市数据
                if setSize <= MaxDP
                    tempCityDist = squareform(pdist(tempCity));
                    %传入点坐标，点之间的距离矩阵，K，中心点数
                    %cluster 一个数组，每个点对应的分类，最小为1
                    %center 中心点的id
                    Centers = ceil(setSize/MaxTspSize)*DPTSPTimes; 
                    K = 10;
                    Clust_Ans = SnnDpc(tempCity,1:setSize,K,'AutoPick',...
                        Centers,'Distance',tempCityDist,'Ui',false);
                    Clust_Ans.center = tempCity(Clust_Ans.center,:);
                    Centers = size(Clust_Ans.center,1);
                else
                    %如果点的数量大于10000，则进行kmeans聚类
                    Centers = min(MaxKmeans,ceil(setSize/StdKmeans));
                    [cidx, cc] = kmeans(tempCity, Centers, 'MaxIter', 10000);
                    Clust_Ans.cluster = cidx;
                    Clust_Ans.center = cc;
                    
                end
                
                %生成一个Centers个结构体数组
                tempStruct = std_struct;
                tempStruct.order = tarStruct.order;
                tempStruct = repmat(tempStruct,1,Centers);
                for h = 1:Centers
                    %子集应该是原本tempstruct中的项
                    tempStruct(h).set = tarStruct.set(Clust_Ans.cluster == h);
                end
                
                %如果有起点和终点指定，则找到对应的团簇，并指定起点终点
                startID = tarStruct.inID;
                endID = tarStruct.outID;
                
                startClustID = 0;
                endClustID = 0;
                
                if startID == 0 && endID == 0
                    [ACS_TEMP_SOLVE]  =  Tool_ACS_Solver(Clust_Ans.center, 0);
                else
                    %查找在哪个团簇
                    for h = 1:Centers
                        
                        FSClust = ismember(startID,tempStruct(h).set);
                        if FSClust == 1
                            startClustID = h;
                            tempStruct(h).inID = startID;
                        end
                        
                        FEClust = ismember(endID,tempStruct(h).set);
                        if FEClust == 1
                            endClustID = h;
                            tempStruct(h).outID = endID;
                        end
                        
                        if startClustID ~=0 && endClustID ~= 0
                            break;
                        end
                    end
                    if startClustID == endClustID
                        %如果一个聚类里面既含有上一层的起点也含有终点
                        %则将终点踢出去单独成为一个簇
                        
                        %找到含有起点和终点的簇，将它设置为起点簇
                        tempStruct(startClustID).set = MY_setdiff(tempStruct(startClustID).set,endID,2);%集合类型
                        tempStruct(startClustID).outID = 0;
                        tempStruct(end+1) = tempStruct(1);
                           tempStruct(end).inID = endID;
                        tempStruct(end).outID = endID;
                        tempStruct(end).set = endID;
                        endClustID = length(tempStruct);
                        
                        Centers = Centers + 1;
                        Clust_Ans.cluster(tarStruct.set == endID) = Centers;
                        %判断剔除的点是否是原始簇的中心点
                        if pdist2(Clust_Ans.center(startClustID,:),City(endID,:)) == 0
                            %换一个点作为顶点
                            Clust_Ans.center(startClustID,:) = City(startID,:);
                        else
                            Clust_Ans.center = [Clust_Ans.center; City(endID,:)];
                        end
                        
%                         %就是普通的循环路径，只是他位于第一个
%                         [ACS_TEMP_SOLVE]  =  ACS_Solver(Clust_Ans.center, 300, 0);
%                         if ACS_TEMP_SOLVE.route(1) ~= startClustID
%                             %将开始的点置于第一个
%                             StrPos = find(ACS_TEMP_SOLVE.route == startClustID);
%                             ACS_TEMP_SOLVE.route = [ACS_TEMP_SOLVE.route(StrPos:end) ...
%                                 ACS_TEMP_SOLVE.route(1:(StrPos-1))];
%                         end
                    end
                    
                    %重新判断中心点，用平均距离构建
                    %无论是kmeans还是snn都一样
%                     if dfm == 1
%                     %method1 不再做操作
%                     
%                     %method2 平均中心点
%                     elseif dfm ==2
%                         for h = 1:length(unique(Clust_Ans.cluster))
%                             Clust_Ans.center(h,:) = mean(tempCity(Clust_Ans.cluster==h,:));
%                         end
%                     %method3 最近距离
%                     elseif dfm ==3
%                         ClustClass = length(unique(Clust_Ans.cluster));
%                         Clust_Ans.center = zeros(ClustClass,ClustClass);
%                         for h = 1:(ClustClass-1)
%                             for j = (h+1):ClustClass
%                                 Clust_Ans.center(h,j) = min(min(pdist2(...
%                                     tempCity(Clust_Ans.cluster==h,:),...
%                                     tempCity(Clust_Ans.cluster==j,:))));
%                             end
%                         end
%                         Clust_Ans.center = Clust_Ans.center + Clust_Ans.center';
%                     %method4 hausdorff 度量
%                     else
%                         ClustClass = length(unique(Clust_Ans.cluster));
%                         Clust_Ans.center = zeros(ClustClass,ClustClass);
%                         for h = 1:(ClustClass-1)
%                             for j = (h+1):ClustClass
%                                 Clust_Ans.center(h,j) = max(min(pdist2(...
%                                     tempCity(Clust_Ans.cluster==h,:),...
%                                     tempCity(Clust_Ans.cluster==j,:))));
%                             end
%                         end
%                         Clust_Ans.center = Clust_Ans.center + Clust_Ans.center';
%                     end
                    

                    ClustClass = length(unique(Clust_Ans.cluster));
                    Clust_Ans.center = zeros(ClustClass,ClustClass);
                    for h = 1:(ClustClass-1)
                        for j = (h+1):ClustClass
                            Clust_Ans.center(h,j) = min(min(pdist2(...
                                tempCity(Clust_Ans.cluster==h,:),...
                                tempCity(Clust_Ans.cluster==j,:))));
                        end
                    end
                    Clust_Ans.center = Clust_Ans.center + Clust_Ans.center';

                    [ACS_TEMP_SOLVE]  =  Tool_ACS_SE_Solver(Clust_Ans.center, startClustID, endClustID, 0);
                end
                
                %对团簇的order进行赋值
                for h = 1:Centers
                    if tempStruct(h).order == 0
                        tempStruct(h).order = [num2str(layer,'%03d') ...
                        num2str(find(ACS_TEMP_SOLVE.route==h),'%03d')];
                    else
                        tempStruct(h).order = [tempStruct(h).order num2str(layer,'%03d') ...
                        num2str(find(ACS_TEMP_SOLVE.route==h),'%03d')];
                    end
                end
                
                %按照顺序重排
                tempStruct = tempStruct(ACS_TEMP_SOLVE.route);
                
                %% 寻找起点和终点，有的团簇已经有了起点或者终点
                %同一个点不能同时是起点或者终点，除非是单点集
                CX1 = []; %起点团簇的坐标集
                CX2 = []; %终点团簇的坐标集
                tempStruct = [tempStruct tempStruct(1)];
                if tarStruct.inID ~= 0
                    CentersA = Centers -1;
                else
                    CentersA = Centers;
                end
                for h = 1:CentersA
% %                     %判断第1簇是否有出点。第2簇是否有入点
% %                     if tempStruct(h).outID == 0 && tempStruct(h+1).inID == 0
% %                         %没有指定入点和起点
% %                         CX1 = City(tempStruct(h).set,:);
% %                         CX2 = City(tempStruct(h+1).set,:);
% %                     elseif tempStruct(h).outID ~= 0 && tempStruct(h+1).inID == 0
% %                         CX1 = City(tempStruct(h).outID,:); %直接指定的id
% %                         CX2 = City(tempStruct(h+1).set,:);
% %                     elseif temp.outID == 0Struct(h) && tempStruct(h+1).inID ~= 0
% %                         CX1 = City(tempStruct(h).set,:);
% %                         CX2 = City(tempStruct(h+1).inID,:);
% %                     else
% %                         CX1 = City(tempStruct(h).outID,:);
% %                         CX2 = City(tempStruct(h+1).inID,:);
% %                     end
% %                 
                    %如果有出点了，则进入下一次循环
                    
                    EX1 = 0;
                    EX2 = 0;
                    if tempStruct(h).outID ~= 0
                        CX1 = City(tempStruct(h).outID,:);
                    else
                        CX1 = City(tempStruct(h).set,:);
                        %排除入点
                        if tempStruct(h).inID ~= 0
                            EX1 = find(tempStruct(h).set == tempStruct(h).inID);
                        end
                    end
                    
                    if tempStruct(h+1).inID ~= 0
                        CX2 = City(tempStruct(h+1).inID,:);
                    else
                        CX2 = City(tempStruct(h+1).set,:);
                        %排除出点
                        if tempStruct(h+1).outID ~= 0
                            EX2 = find(tempStruct(h+1).set == tempStruct(h+1).outID);
                        end
                    end
                    
                    
                    [minDist C1 C2] = setMinDist(CX1,CX2,EX1,EX2);
                    tempStruct(h).outID = tempStruct(h).set(C1);
                    tempStruct(h+1).inID = tempStruct(h+1).set(C2);
                    if h == 1
                        tempStruct(end).outID = tempStruct(1).outID;
                    end
                end
                
                tempStruct(1).inID = tempStruct(end).inID;
                 %% 判断是否有既是起点也是终点的情况
                for h = 1:Centers
                    if tempStruct(h).outID == tempStruct(h).inID
                        if length(tempStruct(h).set) > 1
                            %先判断是否有指定起点或者终点，如果是指定的则不能动
                            if tempStruct(h).outID == endID
                                %修改起点 -- tempStruct已经按照标准order排序
                                if h == 1
                                    CX1 = City(tempStruct(end).outID,:);
                                else
                                    CX1 = City(tempStruct(h-1).outID,:);
                                end
                                
                                CX2 = City(tempStruct(h).set,:);
                                %将终点的坐标进行大量偏移
                                CX2(tempStruct(h).set == tempStruct(h).inID,:) = [Inf Inf];
                                [minDist C1 C2] = setMinDist(CX1,CX2,0,0);
                                tempStruct(h).inID = tempStruct(h).set(C2);
                            else
                                %修改终点
                                if h == length(tempStruct)
                                     CX2 = City(tempStruct(1).inID,:);
                                else
                                     CX2 = City(tempStruct(h+1).inID,:);
                                end
                                CX1 = City(tempStruct(h).set,:);
                                CX1(tempStruct(h).set == tempStruct(h).outID,:) = [Inf Inf];
                               
                                [minDist C1 C2] = setMinDist(CX1,CX2,0,0);
                                tempStruct(h).outID = tempStruct(h).set(C1);
                            end
                        end
                    end
                end
                tempStruct(end) = [];
            end   
            ANS_GROUP_FAKE = [ANS_GROUP_FAKE tempStruct];
        else
            ANS_GROUP_FAKE = [ANS_GROUP_FAKE tarStruct];
        end
    end
    
     %重新赋值ans_group
     ANS_GROUP = ANS_GROUP_FAKE;
    %终止条件，只要后面一次循环isover全部是1，即借宿
     if sum(isCal) == 0
         break;
     end
     %层数增加
    layer = layer + 1;
end

TSP_Solve_Struct.time = toc(stp);

%删除ans_group多余的第一个0
for i = 1:length(ANS_GROUP)
    ANS_GROUP(i).order = replaceBetween(ANS_GROUP(i).order,1,2,'0');
end

%计算ansgroup内部距离
for i = 1:length(ANS_GROUP)
    tdist = 0;
    temp = ANS_GROUP(i).tsp;
    for h = 1:(length(temp)-1)
        tdist = tdist + sqrt((City(temp(h),1) - City(temp(h+1),1))^2 +(City(temp(h),2) - City(temp(h+1),2))^2);
    end
    ANS_GROUP(i).gdist = tdist;
end

%% 解析路径，并求解最短路
if length(ANS_GROUP) == 1
    %仅有一个簇，则不需要拼接
    TSP_Solve_Struct.route = ANS_GROUP.tsp;
    TSP_Solve_Struct.bestline = 0;
else
    %提取order并进行排序，记录最长的order
    Mlen = 1:length(ANS_GROUP);
    for i = Mlen
        Mlen(i) = strlength(ANS_GROUP(i).order);
    end
    MAXMlen = max(Mlen);
    for i = 1:length(ANS_GROUP)
        Mdiff = MAXMlen - Mlen(i);
        if Mdiff ~= 0
            ANS_GROUP(i).order = [ANS_GROUP(i).order repelem('0',Mdiff)] + "";
        else
            ANS_GROUP(i).order = ANS_GROUP(i).order + "";
        end
    end
    
    %将ans_group 变为表格形式
    %[Ans2Sheet] = Cal_Ans_Sheet_Group(ANS_GROUP);
    
    %由计算表计算当前的距离
    %[Rdist route] = Cal_Route_Dist_FC(City, ANS_GROUP, Ans2Sheet);
    popSize = ceil(min(10+length(ANS_GROUP)*EAPAR(1), 150)); %只能为偶数
    if mod(popSize,2) == 0
    else
        popSize = popSize + 1;
    end
    EAmaxIt = 10 + ceil(length(ANS_GROUP)*EAPAR(2));
    optMaxIt = 10 + ceil(length(ANS_GROUP)*EAPAR(3));
    
    [EA_Struct] = EA_PAR_2Opt(ANS_GROUP, City, 100, popSize, EAmaxIt, optMaxIt);
    TSP_Solve_Struct.bestline = EA_Struct.bestline;
    TSP_Solve_Struct.time2 = TSP_Solve_Struct.time + EA_Struct.time;
end

TSP_Solve_Struct.length = EA_Struct.dist;
TSP_Solve_Struct.route = EA_Struct.route; %City个数据
TSP_Solve_Struct.City = City;
TSP_Solve_Struct.clust  = length(ANS_GROUP);
%TSP_Solve_Struct.cate = 0;
TSP_Solve_Struct.layer = layer - 2;
%TSP_Solve_Struct.Od = 0;
end











