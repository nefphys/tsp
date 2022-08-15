function DrawCluster(City,idx,route)
    L = length(unique(idx));
    Q = unique(idx);
    rgbcolor = rand(L,3);
    for i = 1:L
        scatter(City(idx == i,1),City(idx == i,2),'MarkerFaceColor',rgbcolor(i,:));
        hold on
    end
    DrawPath(City,route);
end