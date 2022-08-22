function [ant_tours, tau] = CalLocPhSE(m, ant_tours, n, alpha, beta,tau, rho, c, d)
    %% 生成新的路径以及局部信息素
    stdr = 1:n;
    for  s  =   2  : (n-1) %维数
        for  k  =   1  : m %蚂蚁
            current_node  =  ant_tours(k,s - 1 );
%             visited  =  ant_tours(k,:);
%             visited = visited(visited ~= 0);
%            
%             to_visit  =  MY_setdiff(n,visited,1);%顺序类型
%             
            visited  =  ant_tours(k,1:(s-1));
            to_visit = stdr;
            to_visit(visited) = [];
            
            
            c_tv  =  length(to_visit);
            p = zeros(1,c_tv);
            for i = 1:c_tv
                p(i) = (tau(current_node,to_visit(i))) ^ alpha  *  ( 1 / d(current_node,to_visit(i))) ^ beta;
            end
            %向量化计算会更慢
            %p  =  (tau(current_node,to_visit)) .^ alpha  .*  ( 1 ./ d(current_node,to_visit)) .^ beta;
            %city_to_visit  =   CalSelect(p,c_tv,to_visit) ;
            r  =  rand*sum(p); %这个就是q0 这里是每次都更新
            city_to_visit   =  to_visit(c_tv);
            for  i  =   1  : c_tv
                if  (r  <=  p(i))
                    city_to_visit   =  to_visit(i);
                    break;
                end
            end
            ant_tours(k,s)  =  city_to_visit;
            %原始是1-rho * tau + tau0
            tau(current_node,city_to_visit)  =  ( 1   -  rho)  *  tau(current_node,city_to_visit)  +  rho * c;
        end
    end
end

%不调用函数会更快
function [select] = CalSelect(p,c_tv,to_visit)
%当前方法提升速度4倍
%     p  =  p  /  sum(p);
%     for  i  =   2  : c_tv
%         p(i)  =  p(i)  +  p(i - 1 );
%     end
    r  =  rand*sum(p); %这个就是q0 这里是每次都更新
    select   =  to_visit(c_tv);
    for  i  =   1  : c_tv
        if  (r  <=  p(i))
            select   =  to_visit(i);
            break;
        end
    end
    %select = to_visit(find(r <= p,1));
end

