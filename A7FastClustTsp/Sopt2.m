function [TSP_Struct] = Sopt2(route, City)
    maxiter = 1e6;
    bestL = 1:maxiter;
    RL = length(route);
    RLP = 2:RL;
    route = [route route(1)];
    
    toDist = 0;
    for i = 2:length(route)
        toDist = toDist + sqrt((City(route(i-1),1)-City(route(i),1))^2+ ...
            (City(route(i-1),2)-City(route(i),2))^2);
    end
    
    for i = 1:maxiter
        %随机两个数
        selec = randsample(RLP,2,'false');
        if selec(1) > selec(2)
            T = selec(1);
            selec(1) = selec(2);
            selec(2) = T;
        end
        City1 = City(route(selec(1)-1),:);
        City2 = City(route(selec(1)),:);
        City3 = City(route(selec(2)),:);
        City4 = City(route(selec(2)+1),:);
        od1 = sqrt((City1(1) - City2(1))^2 + (City1(2) - City2(2))^2) + ...
            sqrt((City3(1) - City4(1))^2 + (City3(2) - City4(2))^2);
        nd1 = sqrt((City1(1) - City3(1))^2 + (City1(2) - City3(2))^2) + ...
            sqrt((City2(1) - City4(1))^2 + (City2(2) - City4(2))^2);
        if nd1 < od1
            route(selec(1):selec(2)) = flip(route(selec(1):selec(2)));
            toDist = toDist + nd1 - od1; 
        end
        bestL(i) = toDist;
    end
    TSP_Struct.route = route(1:(end-1));
    TSP_Struct.length = toDist;
end