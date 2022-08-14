temp = [];
for mm = 1:length(ANS_GROUP)
    temp = [temp ANS_GROUP(mm).set];
end
length(unique(temp))


temp = City(ANS_GROUP(1).set,:);
scatter(temp(:,1),temp(:,2))
FIN = City(ANS_GROUP(1).inID,:);
FOUT = City(ANS_GROUP(1).outID,:);
F = [FIN;FOUT];
hold on
scatter(F(:,1),F(:,2),'filled')
hold on
for mm = 2:length(ANS_GROUP)
    temp = City(ANS_GROUP(mm).set,:);
    scatter(temp(:,1),temp(:,2))
    hold on
    FIN = City(ANS_GROUP(mm).inID,:);
    FOUT = City(ANS_GROUP(mm).outID,:);
    F = [FIN;FOUT];
    hold on
    scatter(F(:,1),F(:,2),'filled')
    hold on
end

temp = pdist2(City(tempStruct(1).set,:),City(tempStruct(2).set,:))
temp = pdist2(City([105 120],:),City(139,:))

DrawPath(ANS_GROUP(1).tsp,City(ANS_GROUP(1).set,:))


m = randsample(1:442,50);
TCity = City(m,:);
[TSP_Solve_Struct]  =  ACS_Solver(TCity, 300, 0)
DrawPath([TSP_Solve_Struct.route TSP_Solve_Struct.route(1)]-1,TSP_Solve_Struct.City)

[SETSP_Solve_Struct]  =  ACS_SE_Solver(TCity, 300,5,10, 0)
DrawPath([SETSP_Solve_Struct.route SETSP_Solve_Struct.route(1)]-1,SETSP_Solve_Struct.City)


[SETSP_Solve_Struct]  =  New_ACS_SE(TCity, 300,5,10, 0)
DrawPath([SETSP_Solve_Struct.route]-1,SETSP_Solve_Struct.City)