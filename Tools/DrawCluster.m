function DrawCluster(City,idx,route)
    L = length(unique(idx));
    Q = unique(idx);
    rgbcolor = rand(L,3);
    for i = 1:L
        scatter(City(idx == i,1),City(idx == i,2),'MarkerFaceColor',rgbcolor(i,:));
        hold on
    end
    plot(City(route,1), City(route,2))
    %DrawPath(City,route);
end