for i = 1:length(ANS_GROUP)
    scatter(City(ANS_GROUP(i).set,1), City(ANS_GROUP(i).set,2));
    hold on
    if ANS_GROUP(i).tsp ~= 0
        if length(ANS_GROUP(i).tsp) > 1
            for h = 1:(length(ANS_GROUP(i).tsp)-1)
                plot(City(ANS_GROUP(i).tsp(h:(h+1)),1), City(ANS_GROUP(i).tsp(h:(h+1)),2))
                hold on
                pause(0.05)
            end
        end
        scatter(City(ANS_GROUP(i).set(1),1), City(ANS_GROUP(i).set(1),2), 'filled', 'p');
        hold on
        scatter(City(ANS_GROUP(i).set(end),1), City(ANS_GROUP(i).set(end),2), 'filled', 'd');
        hold on
    end
    pause(0.2)
end


DrawCluster(City, TSP_Solve_Struct_FG.cate, TSP_Solve_Struct_FG.route)