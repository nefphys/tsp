function  [TSP_Solve_Struct]  =  Tool_ACS_SE_Solver(tspData, startP, endP, sIter, maxIter)


    t1 = datetime;

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
    
    %MaxIterations = 1000;
    %target_length = 100;
    if size(distances_matrix, 1) == 3
        chrom = [startP setdiff(1:3, [startP,endP]) endP];
        TSP_Solve_Struct.time = 0;
        TSP_Solve_Struct.length = distances_matrix(chrom(1), chrom(2)) + ...
            distances_matrix(chrom(2), chrom(3));
        TSP_Solve_Struct.route = chrom; %点下标从1开始
        TSP_Solve_Struct.City = City;
        TSP_Solve_Struct.BestLine = 0;
        TSP_Solve_Struct.iter = 0;
    else
        alpha  =   1;
        beta_0 = 1;
        beta = beta_0;
        beta_max = 7;
        rho  =   0.1;
        xi = 0.01;
        xi_max = 0.5;
        number_of_ants = 10+min(ceil(0.8*size(City,1)), 1e3);
        d  =  distances_matrix;
        n  =  max(size(d));
        m  =   number_of_ants ;
        %t_max  =  150 + ceil(size(City,1)/1);

        L_best  =  inf;
        T_best  =   0 ;

        %% 初始化信息素和路径
        % INITIALIZATION  ===========================================================


        % pheromone trails
        %c  =   1   /  (n  *  L_nn);
        TSP_Struct = Opt4ACS(randsample(1:n,n,false), 10*n, n, distances_matrix);
        c  =  1/TSP_Struct.length/n; %初始化信息素
        tau  =  ones(n,n)  *  c;

        ant_tours  =  zeros(m, n+1); %多了一个终点
        %ant_tours(:, 1 )  =  randi([ 1 , n ], m, 1); %每条路径在不同起点分配蚂蚁

        % 初始化ant_tour 矩阵
        ant_tours(:, 1) = startP;
        ant_tours(:, end) = startP;
        ant_tours(:, end-1) = endP;
        for i = 1:m
            temp = randsample(setdiff(1:n,[startP endP]), n-2);
            ant_tours(i, 2:(end-2))  = temp;
        end


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
        espIter = 0;
        while  ((t  <=  maxIter)  &&  (espIter  <=  sIter))


            % CREATE TOURS  =============================================================
            % place m ants in n nodes
            %ant_tours  =  zeros(m, n); %多了一个终点
            %ant_tours(:, 1 )  =  randi([ 1 , n ], m, 1); %每条路径在不同起点分配蚂蚁
            %ant_tours(:, 1 )  =  startP; %每条路径在不同起点分配蚂蚁
            %ant_tours(:, end) = endP;
            %% 生成新的路径以及局部信息素
             [ant_tours, tau] = CalLocPhSE(m, ant_tours, n, alpha, beta,tau, rho, c, d);



            % UPDATE  ===================================================================
            %% 更新最短路径，更新参数

            %ant_tours(:,n + 1 )  =  ant_tours(:, 1 );
            best_ant  =   1 ;
            for  k  =   1  : m
                P  =  ant_tours(k,:);
                L_T(k)  =   sum(d(sub2ind(size(d),P(1:(end-2)),P(2:(end-1)))));
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
                        if (1-0.95^kp) > xi_max
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

            % COMPLETE  ================================================================
            t  =  t  +   1;
            espIter = espIter + 1;
            if  (L_min  <  L_best)
                L_best  =  L_min;
                T_best  =  T_min;
                espIter = 0;
            end
            allrev = [allrev, L_best];
        end  % ends  while

        TSP_Solve_Struct.time = seconds(datetime - t1);
        TSP_Solve_Struct.length = L_best;
        TSP_Solve_Struct.route = T_best(1:(end-1)); %点下标从1开始
        TSP_Solve_Struct.City = City;
        TSP_Solve_Struct.BestLine = allrev(2:end);
        TSP_Solve_Struct.iter = t;
    end
end




function TSP_Struct = Opt4ACS(Chrom, maxIt, CityNum, DistM)
    Chrom = [Chrom Chrom(1)];
    if CityNum > 5
        BKS = zeros(1,maxIt+1);
        CT = CityNum - 1;
        %计算当前染色体的距离
        ndist = 0;
        for h = 1:CityNum
            ndist = ndist + DistM(Chrom(h),Chrom(h+1));
        end
        BKS(1) = ndist;
        seleM = randi(CT,maxIt,2);
        seleM = seleM + 1;
        for h = 1:maxIt
            %随机选择两个点作为端点 并交换顺序
            selec = seleM(h,:);
            if selec(1) == selec(2)
                selec = randperm(CT, 2);
                selec = selec + 1;
            end
            if selec(1) > selec(2)
                T = selec(1);
                selec(1) = selec(2);
                selec(2) = T;
            end

            Cind = [Chrom(selec(1)-1) Chrom(selec(1)) Chrom(selec(2)) Chrom(selec(2)+1)];
            od1 = DistM(Cind(1), Cind(2)) + DistM(Cind(3), Cind(4));
            nd1 = DistM(Cind(1), Cind(3)) + DistM(Cind(2), Cind(4));
            if nd1 < od1
                Chrom(selec(1):selec(2)) = fliplr(Chrom(selec(1):selec(2)));
                ndist = ndist + nd1 - od1; 
                BKS(h+1) = ndist;
            else
                BKS(h+1) = BKS(h);
            end
        end
        TSP_Struct.route = Chrom;
        TSP_Struct.length = ndist;
        TSP_Struct.Bestline = BKS;
    else
        TSP_Struct.route = Chrom;
        TSP_Struct.length = 0;
        TSP_Struct.Bestline = 0;
        ndist = 0;
        for i = 1:CityNum
            ndist = ndist + DistM(Chrom(i), Chrom(i+1));
        end
        TSP_Struct.length = ndist;
    end
end
