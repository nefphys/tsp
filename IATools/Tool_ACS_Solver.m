function  [TSP_Solve_Struct]  =  Tool_ACS_Solver(tspData, target_length)


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
    %判断tspdata是不是大于1的方阵
    %如果是，则传入的是距离矩阵
    if size(tspData,1) == size(tspData,2) && size(tspData,1) > 1
        distances_matrix = tspData;
        City = tspData;
    else
        [Distance, City] = readfile(tspData,1);
        distances_matrix = Distance;
    end
    %number_of_ants = int32(size(City,1)*0.8);
    number_of_ants = min(ceil(0.5*size(City,1))+1, 100);
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
    t_max  =  10 + size(City,1) ;
    L_target  =  target_length ;

    L_best  =  inf;
    T_best  =   0 ;

    tic;
    %% 初始化信息素和路径
    % INITIALIZATION  ===========================================================

    
    % pheromone trails
    %c  =   1   /  (n  *  L_nn);
    c  =   0.000001; %初始化信息素
    tau  =  ones(n,n)  *  c;


    % place m ants in n nodes
    ant_tours  =  zeros(m, n + 1 ); %多了一个终点
    ant_tours(:, 1 )  =  randi([ 1 , n ], m, 1); %每条路径在不同起点分配蚂蚁


    %% 主循环
    t  =   1 ;
    kp = 1;
    kq = 1;
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

        ant_tours(:,n + 1 )  =  ant_tours(:, 1 );
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
        if(t >  5) %5次之后再判断
            if(L_best <= L_min)
                %判断路径是否是一样的
                %if isequal(T_best,T_min)
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
                %end
            end
        end

        % update pheromone trails;
        %% 更新全局信息素,只更新了最优的
        for  i  =   1  : n
            tau(T_min(i),T_min(i + 1 ))  =  ( 1   -  xi)  *  tau(T_min(i),T_min(i + 1 ))  +  xi  /  L_min;
        end
        %tau = (1 - xi) * tau + xi / L_min;
        % COMPLETE  ================================================================
        t  =  t  +   1;
        current_cities  =  ant_tours(:,n);
        ant_tours  =  zeros(m, n + 1 );
        ant_tours(:, 1 )  =  current_cities;
        if  (L_min  <  L_best)
            L_best  =  L_min;
            T_best  =  T_min;
        end
        allrev = [allrev, L_best];
    end  % ends  while
    t2 = cputime;
    
    TSP_Solve_Struct.time = toc;
    TSP_Solve_Struct.length = L_best;
    TSP_Solve_Struct.route = T_best(1:(end-1)); %点下标从1开始
    TSP_Solve_Struct.City = City;
    TSP_Solve_Struct.BestLine = allrev;
end

