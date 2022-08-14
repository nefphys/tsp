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
