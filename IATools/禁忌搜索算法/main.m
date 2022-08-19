%% 清空环境变量
clear all;
clc;

%% 初始化参数
load citys_data.mat;
n = size(citys, 1);                               % 城市数目
D = zeros(n);                                    % 距离矩阵
Tabu = zeros(n);                               % 禁忌表
TabuL = round(sqrt(n*(n-1)/2));         % 禁忌长度
Ca = 200;                                          % 候选集的个数(全部邻域解个数)
Canum = zeros(Ca, n);                       % 候选解集合
S0 = randperm(n);                            % 随机产生初始解
bestsofar = S0;                                 % 当前最佳解
BestL = Inf;                                       % 当前最佳解距离， inf表示无穷大
iter = 1;                                           % 初始迭代次数
iter_max = 1000;                              % 最大迭代次数

%% 城市位置
figure;
plot(citys(:, 1), citys(:, 2), 'ms', 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
legend('城市位置')
title('城市分布图', 'fontsize', 12)
xlabel('城市位置横坐标', 'fontsize', 12)
ylabel('城市位置纵坐标', 'fontsize', 12)
grid on
for i = 1:n
    text(citys(i, 1), citys(i, 2), ['   ' num2str(i)]);
end

%% 计算距离矩阵
for i = 1:n
    for j = i+1:n
        D(i, j) = sqrt(sum((citys(i, :)-citys(j, :)).^2));
        D(j, i) = D(i, j);
    end
end

%% 迭代优化
while iter < iter_max
    ALong(iter) = fitness(D, S0);     % 当前路线适应度值
    i = 1;
    A = zeros(Ca,2);            % 交换的城市矩阵，200行2列
    %% 求邻域解中交换的城市矩阵
    % 将一个200行2列的A阵用随机的方式填满，且没有任意两组数是相等的
    while i <= Ca
        r = ceil(n*rand(1,2));         % 随机交换两个城市
        if r(1) ~= r(2)
            A(i, 1) = max(r(1), r(2));
            A(i, 2) = min(r(1), r(2));
            if i == 1
                flag = 0;
            else
                for j = 1:i-1
                    if A(i, 1) == A(j, 1) && A(i, 2) == A(j, 2)
                        flag = 1;
                        break;
                    else
                        flag = 0;
                    end
                end
            end
            if ~flag
               i = i + 1;
            end
        end  
    end
    %% 产生邻域解
    % 保留前BestCanum个最好候选解
    BestCanum = Ca/2;
    BestCa = Inf * ones(BestCanum, 4);
    F = zeros(1, Ca);
    for i = 1:Ca
        Canum(i, :) = S0;       
        Canum(i, [A(i, 2), A(i, 1)]) = S0([A(i, 1), A(i, 2)]);  % 交换A(i, 1)和A(i, 2)列的元素
        F(i) = fitness(D, Canum(i, :)); 
        if i <= BestCanum    % 选取候选集
            BestCa(i, 1) = i;       % 第1列保存序号
            BestCa(i, 2) = F(i);   % 第2列保存适应度值(路径距离)
            BestCa(i, 3) = S0(A(i, 1));     % 第3列保存交换后的数据
            BestCa(i, 4) = S0(A(i, 2));     % 第4列保存交换后的数据
        else
            for j = 1:BestCanum   % 更新候选集
                if F(i) < BestCa(j, 2)
                    BestCa(j, 1) = i;
                    BestCa(j, 2) = F(i);
                    BestCa(j, 3) = S0(A(i, 1));
                    BestCa(j, 4) = S0(A(i, 2));
                    break;
                end
            end
        end
    end
    % 对候选集按照适应度值进行升序排列
    [value, index] = sort(BestCa(:, 2)); 
    SBest = BestCa(index, :);         
    BestCa = SBest;                     % 选取前100个比较好的候选解
    %% 特赦准则
    if BestCa(1,2) < BestL     % 候选解比最佳值都还小，那么不管在不在禁忌表中，都是一样的操作
        % 在禁忌表中，全部减1，特赦出来，放在最后；
        % 不在禁忌表中，全部减1，放在最后；
        BestL = BestCa(1, 2);               % BestL当前最优解适配值
        S0 = Canum(BestCa(1,1), :);     % 最优解的替换
        bestsofar = S0;
        % 更新禁忌表
        for i = 1:n
            if Tabu(i, :) ~= 0
                Tabu(i, :) = Tabu(i, :)-1;
            end
        end
        Tabu(BestCa(1, 3), BestCa(1, 4)) = TabuL;         % 更新禁忌表，把特赦的这个放在最末端
    else                 % 候选解中最佳的解 仍然没有比目前最佳值更优，则：
        for i = 1:BestCanum                        % 遍历候选集
            if Tabu(BestCa(i, 3), BestCa(i, 4)) == 0  % BestCa就是从小到大排列的，选取第一个不在禁忌表中的解，即禁忌长度为0
                S0 = Canum(BestCa(i, 1), :);         % 则释放，并作为下一次迭代的初始解
                for j = 1:n
                    if Tabu(j, :) ~= 0
                        Tabu(j, :) = Tabu(j, :)-1;
                    end
                end
                Tabu(BestCa(i, 3), BestCa(i, 4)) = TabuL;   % 放到禁忌表最末端
                break;  %  立刻跳出for循环，因为已经选中不在禁忌表中的最佳解了
            end
        end
    end
    L_best(iter) = BestL;            % 记录历次迭代的最优值
    iter = iter+1;                      % 迭代次数加1
%     for i = 1:n-1
%         plot([citys(bestsofar(i), 1), citys(bestsofar(i+1), 1)], [citys(bestsofar(i), 2), citys(bestsofar(i+1), 2)], 'bo-');  % 蓝色圆点显示
%         hold on;
%     end
%     % 用红色带圆圈的线将第一次迭代后的最优值连线
%     plot([citys(bestsofar(n), 1), citys(bestsofar(1), 1)], [citys(bestsofar(n), 2), citys(bestsofar(1), 2)], 'ro-');  %红色圆圈  前横坐标，后纵坐标
%     title(['优化最短距离:', num2str(BestL)]);  %优化最短距离等于当前最优解
%     hold off;
%     pause(0.005);   %暂停(n)暂停执行n秒，然后继续。暂停必须启用此调用才能生效。
end
%% 结果显示
disp(['最短距离：', num2str(BestL)]);
disp(['最短路径：', num2str(bestsofar)]);
%% 绘图
figure;
plot([citys(bestsofar, 1); citys(bestsofar(1), 1)], [citys(bestsofar, 2); citys(bestsofar(1), 2)],...
    'ms-', 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
grid on;
for i = 1:n
    text(citys(i, 1), citys(i, 2), ['   ' num2str(i)]);
end
text(citys(bestsofar(1), 1), citys(bestsofar(1), 2), '       起点');
text(citys(bestsofar(end), 1), citys(bestsofar(end), 2), '       终点');
legend('经过城市')
title(['TS算法优化路径(最短距离:' num2str(BestL) ')'], 'fontsize', 12);
xlabel('城市位置横坐标', 'fontsize', 12)
ylabel('城市位置纵坐标', 'fontsize', 12)
figure;
plot(L_best, 'r');
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')







