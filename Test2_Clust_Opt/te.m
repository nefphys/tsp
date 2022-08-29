s = [];
for i = 1:length(tarTsp)
    a = tarTsp(i).name;
    a = a(isstrprop(a,'digit'));
    s(i) = str2num(a);
end
s = s';
 

X = rand(300,2);
Centers = 5;
K = 10;
Clust_Ans = SnnDpc(X,1:size(X,1),K,'AutoPick',...
    Centers,'Ui',true);

tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
[Distance City] = readfile(tarPath,1);

[TSP_Solve_Struct]  =  FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans);
DrawPath(City,TSP_Solve_Struct.route)
figure(2)
DrawCluster(City, TSP_Solve_Struct.cate, TSP_Solve_Struct.route)

[TSP_Solve_Struct_K]  = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
DrawPath(City,TSP_Solve_Struct.route)
figure(2)
DrawCluster(City, TSP_Solve_Struct_K.cate, TSP_Solve_Struct_K.route)


%验算距离计算是否正确
dist0 = 0;
dist1 = 0;
RFC = [TSP_Solve_Struct_K.route TSP_Solve_Struct_K.route(1)];
%RFK = [TSP_FK.route TSP_FK.route(1)];

for i = 2:length(RFC)
    dist0 = dist0 + pdist2(City(RFC(i-1),:),City(RFC(i),:));
    %dist1 = dist1 + pdist2(City(RFK(i-1),:),City(RFK(i),:));
end


 Clust_Ans = SnnDpc(tempCity,1:setSize,K,'AutoPick',...
                        Centers,'Distance',tempCityDist,'Ui',true);
                    
                    
for jkk = 1:length(ANS_GROUP_FAKE)
    scatter(City(ANS_GROUP_FAKE(jkk).set,1), City(ANS_GROUP_FAKE(jkk).set,2))
    hold on
    %jkk = jkk+1
end
hold off

figure(2)
DrawPath(BPCenter,ACS_TEMP_SOLVE.route)


CF = [];
KF = [];
parfor jk = 1:6
    [TSP_Solve_Struct]  =  FastClustTSP(City, MaxDistNum,MaxTspSize,MaxKmeans);
    CF(jk) = TSP_Solve_Struct.length;
    [TSP_Solve_Struct_K]  = FastKmeansTSP(City, MaxDistNum, MaxTspSize, MaxKmeans);
    KF(jk) = TSP_Solve_Struct_K.length;
end
plot(CF)
hold on
plot(KF)