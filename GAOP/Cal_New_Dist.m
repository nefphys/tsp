function [route dist] = Cal_New_Dist(New_Group, Chrom, City)
    route = [];
    for i = 1:length(Chrom)
        if New_Group(Chrom(i)).tsp(1) == New_Group(Chrom(i)).point(1)
            route = [route New_Group(Chrom(i)).tsp];
        else
            route = [route flip(New_Group(Chrom(i)).tsp)];
        end
    end
    
    %计算距离
    dist = 0;
    route = [route route(1)];
    for i = 2:length(route)
        dist = dist + pdist2(City(route(i-1),:), City(route(i),:));
    end
end