function DrawCluster(City,idx,route)
     L = length(unique(idx));
     Q = unique(idx);
     rgbcolor = rand(L,3);
    if route == 0
        for i = 1:L
            scatter(City(find(idx == Q(i)),1),City(find(idx == Q(i)),2),'MarkerEdgeColor',rgbcolor(Q(i),:),'MarkerFaceColor',rgbcolor(Q(i),:))
            hold on
        end
    else
        for i = 1:length(idx)
             plot(City(route([i i+1]),1), City(route([i i+1]),2) ,'o-','Color',rgbcolor(idx(route(i)),:),'MarkerFaceColor',rgbcolor(idx(route(i)),:))
             hold on
        end
    end
end