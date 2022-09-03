function TSPNN_Struct = Cal_Dist_New_Group(Chrom, New_Group, City)
    route = [];
    for i = 1:length(Chrom)
        route = [route New_Group(i).tsp];
    end
    
    mdist = 0;
    route = [route route(1)];
    for i = 2:length(route)
        mdist = mdist + pdist2(City(route(i-1),:),City(route(i),:));
    end
    TSPNN_Struct.route = route(1:(end-1));
    TSPNN_Struct.dist = mdist;
end
