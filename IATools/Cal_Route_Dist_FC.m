%% 通用函数，给定数据计算路径长度
function [Rdist Route] = Cal_Route_Dist_FC(City, ANS_GROUP, RouteSheet)
    if RouteSheet == 0
        [RouteSheet idx] = Cal_Ans_Sheet_Group(ANS_GROUP);
    end
    %% City 为坐标
    % ANS_GROUP 为第一次求解结果
    % ANS_GROUP 增加属性每个组的距离 gdist
    % Route 表示顺序表， 设计为第一层id，第二层id，以及转向算子
    % 转向算子0 表示用ANS_GROUP默认的顺序，1 表示倒序
    % replaceBetween("0011101",1,1,'0')
    std_order = Cal_Sheet_Ans_Group(RouteSheet);
    %新的std_order 与ans_group对应 找到顺序
    ans_order = zeros(1, length(ANS_GROUP));
    tmp_order = std_order;
    for i = 1:length(ANS_GROUP)
        tmp_order(i) = ANS_GROUP(i).order;
    end
    
    [C ix] = sort(std_order);
    [C iy] = sort(tmp_order);
    
    for i = 1:length(iy)
        ans_order(i) = iy(ix == i);
    end
    
%     for i = 1:length(std_order)
%         for h = 1:length(ANS_GROUP)
%             if std_order(i) == ANS_GROUP(h).order
%                 ans_order(i) = h;
%                 break
%             end
%         end
%     end
%     
    %利用得到的顺序和转向算子合并生成路线
    new_route = [];
    Rdist = 0;
    for i = 1:length(ans_order)
        temp = ANS_GROUP(ans_order(i));
        if RouteSheet(i,end) == 0
            t_route = temp.tsp;
        else
            t_route = fliplr(temp.tsp);
        end
        if i == 1
            Rdist = Rdist + temp.gdist;
            new_route = [new_route t_route];
        else
            tdist = sqrt(...
                (City(new_route(end),1) - City(t_route(1),1))^2 ...
            +(City(new_route(end),2) - City(t_route(1),2))^2 ...
            );
            Rdist = Rdist + temp.gdist + tdist;
            new_route = [new_route t_route];
        end
    end
    
    Rdist = Rdist + sqrt((City(new_route(1),1) - City(new_route(end),1))^2 + ...
         (City(new_route(1),2) - City(new_route(end),2))^2);
    
    %根据new_route计算总路径长度
%     Rdist = 0;
%     City = City(new_route,:); %将city按照new_route 排序
%     for i = 2:length(new_route)
%         Rdist = Rdist + sqrt((City(i-1,1) - City(i,1))^2 +(City(i-1,2) - City(i,2))^2);
%         %pdist2(City(i-1,:),City(i,:),'euclidean');
%     end
%     Rdist = Rdist + pdist2(City(1,:),City(end,:),'euclidean');
    Route = new_route;
end
