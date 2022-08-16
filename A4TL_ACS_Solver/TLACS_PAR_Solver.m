function  [TSP_Solve_Struct]  =  TLACS_Solver(tspData,ck)

    %% 双层ACS算法，先聚类，再计算子类的路径，参考 wu2020
    %tspdata为数据。ck为聚类中心数
    %% 读取数据
    [Distance, City] = readfile(tspData,1);
    
    t1 = tic;
    %% kmeans 聚类
    [idx, C] = kmeans(City, ck);
    
    %% 对聚类中心进行一次ACS，得到上层的顺序 
    First_Layer_TSP = Tool_ACS_Solver(C,0);
    First_Layer_TSP.route = [First_Layer_TSP.route First_Layer_TSP.route(1)];
    opt_route = [];
    start_end_chart = zeros(ck+1,2);
    %% 按顺序寻找每个簇的起点和终点
    for i = 1:ck
        F_set_id = find(idx==First_Layer_TSP.route(i));
        F_set = City(F_set_id,:);
        S_set_id = find(idx==First_Layer_TSP.route(i+1));
        S_set = City(S_set_id,:);
        % 计算两簇之间的最近的点
        % 起点和终点不能一样
        [k, dist] = dsearchn(F_set,S_set); %点S到点集F最近的S的点
        %判断是否是单点集,排除入点作为出点的情况
        if length(F_set_id) > 1 && start_end_chart(i+1,2) ~= 0
            dist(start_end_chart(i+1,2)) = 1e20;
        end
        [M, I] = min(dist);
        start_end_chart(i+1,1) = I;
        [k, dist] = dsearchn(S_set(I,:),F_set);
        %判断是否是单点集,排除入点作为出点的情况
        if length(S_set_id) > 1 && start_end_chart(i,1) ~= 0
            dist(start_end_chart(i,1)) = 1e20;
        end
        [M, I] = min(dist);
        start_end_chart(i,2) = I;
        if i == 1
            start_end_chart(end,2) = start_end_chart(1,2);
        end
    end
    start_end_chart(1,1) = start_end_chart(ck+1,1);
    start_end_chart(ck+1,:) = [];
    parfor i = 1:ck
        F_set_id = find(idx==First_Layer_TSP.route(i));
        F_set = City(F_set_id,:);
        %判断是否是单点集
        if length(F_set_id) == 1
            opt_route = [opt_route; F_set_id];
        else
            F_set_TSP = Tool_ACS_SE_Solver(F_set, start_end_chart(i,1), start_end_chart(i,2), 0);
            opt_route = [opt_route; F_set_id(F_set_TSP.route(1:end))];
        end
    end

    TSP_Solve_Struct.time = toc(t1);
    TSP_Solve_Struct.route = opt_route';
    opt_route = [opt_route' opt_route(1)]; %点下标从1开始
    
    %计算长度
    alen = 0;
    for i = 1:max(size(City))
        alen = alen + sqrt(sum((City(opt_route(i),:)-City(opt_route(i+1),:)).^2));
    end
    TSP_Solve_Struct.length = alen;
    TSP_Solve_Struct.City = City;
    TSP_Solve_Struct.BestLine = 0;
    TSP_Solve_Struct.cate = idx;
end