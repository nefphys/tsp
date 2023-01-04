%% 研究 ACS 的参数设置 --- 在双层优化算法中会比较麻烦，如何平衡子类和上层之间的关系

%% 计算不同规模ACS算法在当前参数设置下的精度以及计算时间 单独运算30次

%% 时间复杂度为O(n^3)
%% 待验证的 数据集 规模为 

tarTsp = dir("data");

tarTsp = tarTsp(3:end);

route = zeros(length(tarTsp), 30);
time = zeros(length(tarTsp), 30);

for i = 1:length(tarTsp)
    i
    tarPath = tarTsp(i).folder + "\" + tarTsp(i).name;
    [Distance City] = readfile(tarPath,1);
    City = rand(i*10,2);
    for h = 1:1
        %sprintf('%10s',i+"",h+"",tarTsp(i).name)
        [TSP_Solve_Struct]  =  Tool_ACS_Solver(City, 0);
        route(i,h) = TSP_Solve_Struct.length;
        time(i,h) = TSP_Solve_Struct.time;
    end
end

% 时间曲线 散点图
for i = 1:length(tarTsp)
    scatter(repelem(i*10,30), route(i,:));
    hold on
end
hold off


for i = 1:length(tarTsp)
    scatter(repelem(i*10,30), time(i,:));
    hold on
end
hold off

profile on
[TSP_Solve_Struct]  =  Tool_ACS_Solver(City, 0);
profile viewer
profile off


% 仅研究小规模数据集下的精度和时间
xt = 1000;
p = 0.007596 * xt^2 - 0.2554 *xt + 2.929