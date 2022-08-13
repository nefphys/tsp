function  [TSP_Solve_Struct]  =  ACS_SE_Solver_BP(tspData, MaxIterations, startP, endP, target_length)


    %% Ant Colony System  for  the TSP
    %
    %   ACSTSP(distances_matrix, number_of_ants, MaxIterations, alpha, beta, rho, target_length)
    %
    %   distances_matrix:   symmeric real (NrOfNodes x NrOfNodes) - matrix containing distances
    %                       between all nodes: d[i,i]  =   0 , d[i,j] = d[j,i]
    %   MaxIterations:      maximum number of iterations  to  run
    %   target_length:       if  a tour  is  found  with  less than target_length, the  function  returns
    %                       stops  and  returns this tour.
    %
    %   parameter standard values:
    %       number_of_ants  =  NrOfNodes
    %       alpha  =   1
    %       beta  =   9
    %       rho  =   0.9
    %
    % returns [BestTourLength, BestTour]


    %% 初始化参数
    [Distance, City] = readfile(tspData,1);
    distances_matrix = Distance;
    number_of_ants = int32(size(City,1)*0.8);
    %MaxIterations = 1000;
    %target_length = 100;

    alpha  =   1; 
    beta_0 = 1;
    beta = beta_0;
    beta_max = 7;
    rho  =   0.1;
    xi = 0.01;
    xi_max = 0.5;

    d  =  distances_matrix;
    n  =  max(size(d));
    m  =   number_of_ants ;
    t_max  =   MaxIterations ;
    L_target  =  target_length ;

    L_best  =  inf;
    T_best  =   0 ;

    t1 = cputime;
    %% 初始化信息素和路径
    % INITIALIZATION  ===========================================================

    
    % pheromone trails
    %c  =   1   /  (n  *  L_nn);
    c  =   0.000001; %初始化信息素
    tau  =  ones(n,n)  *  c;


    % place m ants in n nodes
    ant_tours  =  zeros(m, n + 1 ); %多了一个终点
    %起点和终点是固定的
    ant_tours(:, 1 )  =  startP; %每条路径在不同起点分配蚂蚁
    ant_tours(:, end) = startP;
    ant_tours(:,(end-1)) = endP;

    %% 主循环
    t  =   1 ;
    kp = 1;
    allrev = 0;
    
    %% 预分配内存
    current_node = 0;
    c_tv = 0;
    r = 0;
    select = 0;
    city_to_visit = 0;
    L_T  =  zeros( 1 ,m);
    best_ant = 0;
    
    while  ((t  <=  t_max)  &&  (L_target  <=  L_best))


        % CREATE TOURS  =============================================================

        %% 生成新的路径以及局部信息素
        [ant_tours, tau] = CalLocPh(m, ant_tours, n, alpha, beta,tau, rho, c, d);


        % UPDATE  ===================================================================
        %% 更新最短路径，更新参数
           
        %ant_tours(:,n + 1 )  =  ant_tours(:, 1 );
        best_ant  =   1 ;
        for  k  =   1  : m
            P  =  ant_tours(k,:);
            L_T(k)  =   sum(d(sub2ind(size(d),P(1:(end-1)),P(2:end))));
            if  (L_T(k)  <  L_T(best_ant))
                best_ant  =  k;
            end
        end
        L_min  =  min(L_T);
        T_min  =  ant_tours(best_ant,:);

        %% 如果这次的路径和上次的路径一样，即都是best route，则更新beta和xi
        if t >  5 && L_best <= L_min %5次之后再判断
            if (1-0.95^kp) < xi_max
                xi = 1-0.95^kp;
            else
                xi = xi_max;
            end

            if (beta_0 + log(kp)) <= beta_max
                beta = beta_0 + log(kp);
            else
                beta = beta_max;
            end

            kp = kp + 1;
        end

        % update pheromone trails;
        %% 更新全局信息素,只更新了最优的
        for  i  =   1  : n
            tau(T_min(i),T_min(i + 1 ))  =  ( 1   -  xi)  *  tau(T_min(i),T_min(i + 1 ))  +  xi  /  L_min;
        end

        % COMPLETE  ================================================================
        t  =  t  +   1;
        %current_cities  =  ant_tours(:,n);
        ant_tours  =  zeros(m, n + 1 );
        ant_tours(:, 1 )  =  startP; %每条路径在不同起点分配蚂蚁
        ant_tours(:, end) = startP;
        ant_tours(:,(end-1)) = endP;
        if  (L_min  <  L_best)
            L_best  =  L_min;
            T_best  =  T_min;
        end
        allrev = [allrev, L_best];
    end  % ends  while
    t2 = cputime;
    
    TSP_Solve_Struct.time = t2-t1;
    TSP_Solve_Struct.length = L_best;
    TSP_Solve_Struct.route = T_best; %点下标从1开始
    TSP_Solve_Struct.City = City;
    TSP_Solve_Struct.BestLine = allrev;
end

function [ant_tours, tau] = CalLocPh(m, ant_tours, n, alpha, beta,tau, rho, c, d)
    for  k  =   1  : m %蚂蚁
        visited  =  ant_tours(k,:);
        visited = visited(visited ~= 0);
        to_visit  =  MY_setdiff(1:n,visited);
        c_tv  =  length(to_visit);
        p = zeros(1,c_tv);
        for  s  =   2  : (n-1) %维数
            current_node  =  ant_tours(k,s - 1 );
            for LL = 1:c_tv
                %计算局部信息素
                p(LL) =  (tau(current_node,to_visit(LL))) ^ alpha  *  ( 1 / d(current_node,to_visit(LL))) ^ beta;
            end
            %p  =  (tau(current_node,to_visit)) .^ alpha  .*  ( 1 ./ d(current_node,to_visit)) .^ beta;
            p  =  p  /  sum(p);
            for  i  =   2  : c_tv
                p(i)  =  p(i)  +  p(i - 1 );
            end
            r  =  rand; %这个就是q0 这里是每次都更新
            select   =  to_visit(c_tv);
            for  i  =   1  : c_tv
                if  (r  <=  p(i))
                    select   =  to_visit(i);
                    break;
                end
            end
            city_to_visit  =   select;
            ant_tours(k,s)  =  city_to_visit;
            %原始是1-rho * tau + tau0
            tau(current_node,city_to_visit)  =  ( 1   -  rho)  *  tau(current_node,city_to_visit)  +  rho * c;
        end
    end
end