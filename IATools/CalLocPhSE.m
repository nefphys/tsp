function [ant_tours, tau] = CalLocPhSE(m, ant_tours, n, alpha, beta,tau, rho, c, d)
    %% 生成新的路径以及局部信息素
    % 计算P矩阵
    pm = tau;
    for kk = 1:n
        pm(kk,:) = tau(kk,:) .^ alpha .*  (1 ./ d(kk,:)) .^ beta ;
        pm(kk,kk) = 0;
    end
    
    for  s  =   2  : (n-1) %维数
        for  k  =   1  : m %蚂蚁
            current_node  =  ant_tours(k, s - 1 );
            to_visit = ant_tours(k,s:(end-2));
            c_tv  =  length(to_visit);
            p = pm(current_node,to_visit);
            %p(p == Inf) = 10000;
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
%             if d(current_node,city_to_visit) == 0
%                  pm(current_node,city_to_visit) = tau(current_node,city_to_visit) ^ alpha;
%             else
%                  pm(current_node,city_to_visit) = tau(current_node,city_to_visit) ^ alpha *  (1 / d(current_node,city_to_visit)) ^ beta ;
%             end
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
        p = cumsum(p) / sum(p);
        r = rand;
        iy = find(p >= r, 1);
        select   =  to_visit(iy);
    end
end





% function [ant_tours, tau] = CalLocPhSE(m, ant_tours, n, alpha, beta,tau, rho, c, d)
%     %% 生成新的路径以及局部信息素
%     stdr = 1:n;
%     for  s  =   2  : (n-1) %维数
%         for  k  =   1  : m %蚂蚁
%             current_node  =  ant_tours(k,s - 1 );   
%             visited  =  [ant_tours(k,1:(s-1)) ant_tours(k,(end-1))];
%             to_visit = stdr;
%             to_visit(visited) = [];
%             
%             c_tv  =  length(to_visit);
%             p = zeros(1,c_tv);
%             for i = 1:c_tv
%                 p(i) = (tau(current_node,to_visit(i))) ^ alpha  *  ( 1 / d(current_node,to_visit(i))) ^ beta;
%             end
%             %向量化计算会更慢
%             %p  =  (tau(current_node,to_visit)) .^ alpha  .*  ( 1 ./ d(current_node,to_visit)) .^ beta;
%             %city_to_visit  =   CalSelect(p,c_tv,to_visit) ;
%             city_to_visit  =   CalSelect(p,c_tv,to_visit) ;
%             ant_tours(k,s)  =  city_to_visit;
%             %原始是1-rho * tau + tau0
%             tau(current_node,city_to_visit)  =  ( 1   -  rho)  *  tau(current_node,city_to_visit)  +  rho * c;
%         end
%     end
% end
% 
% %不调用函数会更快
% 
% function [select] = CalSelect(p,c_tv,to_visit)
%     if rand < 0.1
%         %[imax iy isum p] = MaxSumProb(p, 1);
%         [ix iy] = max(p);
%         select   =  to_visit(iy);
%     else
%         [imax iy isum p] = MaxSumProb(p, 0);
%         r = rand;
%         select   =  to_visit(c_tv);
%         for  i  =   1  : c_tv
%             if r  <=  p(i)
%                 select   =  to_visit(i);
%                 break;
%             end
%         end
%     end
% end
% 
