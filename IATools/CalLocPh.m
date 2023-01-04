function [ant_tours, tau] = CalLocPh(m, ant_tours, n, alpha, beta,tau, rho, c, d)
    %% 生成新的路径以及局部信息素
    % 计算P矩阵
    pm = tau;
    for kk = 1:n
        pm(kk,:) = tau(kk,:) .^ alpha .*  (1 ./ d(kk,:)) .^ beta ;
        pm(kk,kk) = 0;
    end
    
    for  s  =   2  : n %维数
        for  k  =   1  : m %蚂蚁
            current_node  =  ant_tours(k, s - 1 );
            to_visit = ant_tours(k,s:(end-1));
            c_tv  =  length(to_visit);
            p = pm(current_node,to_visit);
            [city_to_visit iy] = CalSelect(p,c_tv,to_visit);

            iy = iy + s - 1;
            if iy == s
            else
                temp= ant_tours(k,s);
                ant_tours(k,iy) = temp;
                ant_tours(k,s) = city_to_visit;
            end
            
            tau(current_node,city_to_visit)  =  ( 1   -  rho)  *  tau(current_node,city_to_visit)  +  rho * c;
            tau(city_to_visit, current_node) = tau(current_node,city_to_visit);
            pm(current_node,city_to_visit) = tau(current_node,city_to_visit) ^ alpha *  (1 / d(current_node,city_to_visit)) ^ beta ;
            pm(city_to_visit, current_node) = pm(current_node,city_to_visit);
        end
    end
end


function [select iy] = CalSelect(p,c_tv,to_visit)
    if rand < 0.9
        %[imax iy isum p] = MaxSumProb(p, 1);
        [ix iy] = max(p);
        select   =  to_visit(iy);
    else
%         [imax iy isum p] = MaxSumProb(p, 0);
%         [imax iy] = max(p);
        p = cumsum(p) / sum(p);
        r = rand;
        iy = find(p >= r, 1);
        select   =  to_visit(iy);
    end
end



