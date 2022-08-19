%%%%%%%%%%%%%遗传算法解决TSP问题%%%%%%%%%%%%%%%%%%
clear all;
close all;
G = 1000;
C = [  1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;
    3238 1229;4196 1044;4312 790;4386 570;3007 1970;2562 1756;
    2788 1491;2381 1676;1332 695;3715 1678;3918 2179;4061 2370;
    3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;
    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;
    2370 2975];       % 31个城市的坐标位置
N = size(C,1);
D = zeros(N);        %任意两个城市距离的间隔矩阵
%%%%%%%%%%%%%%%%%%%%求任意两个城市距离间隔矩阵%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    for j=1:N
        D(i,j) = ((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
    end
end
NP = 200;              %种群规模
%    G = 100;              %最大遗传代数
f = zeros(NP,N);       %200行31列，用来存储种群
F=[];                  %种群更新中间存储
for i = 1:NP
    f(i,:) = randperm(N);%随机生成1-31的初始种群
end
R = f(1,:);            %存储最优种群
len = zeros(NP,1);     %存储路径长度
fitness = zeros(NP,1); %存储归一化适应值
gen = 0;
%%%%%%%%%%%%%%%%%%%%%%遗传算法循环%%%%%%%%%%%%%%%%%%%%%%%%
while gen <G
    %%%%%%%%%%%%%%%%%%%%%计算路径长度%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:NP
        len(i,1) = D(f(i,N),f(i,1));
        for j = 1:(N-1)
            len(i,1) = len(i,1)+ D(f(i,j),f(i,j+1));%一共有200行，200种路径，每一种路径组合的长度
        end
    end
    maxlen = max(len);%最长路径
    minlen = min(len);%最短路径
    %%%%%%%%%%%%%%%%更新最短路径%%%%%%%%%%%%%%%%%%%%%%%
    rr = find (len==minlen);%去len矩阵里面找到等于minlen的索引
    R = f(rr(1,1),:);       %R表示存储最优路径
    %%%%%%%%%%%%%%%%%%%计算归一化适应值%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(len)
        fitness(i,1) = (1-((len(i,1)-minlen)/(maxlen-minlen+0.001)));
    end
    %%%%%%%%%%%%%%%%%%%选择操作%%%%%%%%%%%%%%%%%%%%%%
    nn = 0;
    for i = 1:NP
        if fitness(i,1) >= rand  %rand表示0-1之间的随机数
            nn = nn+1;
            F(nn,:) = f(i,:);
        end
    end
    [aa,bb] = size(F);        %aa表示行，bb表示列
    while aa < NP
        nnper = randperm(nn); %产生1行nn列
        A = F(nnper(1),:);    %nnper的第一个数
        B = F(nnper(2),:);    %nnper的第二个数
        %%%%%%%%%%%%%%交叉操作%%%%%%%%%%%%%%%%%%%%
        W = ceil(N/10);          %朝着正无穷取整，交叉点个数为4
        p = unidrnd(N-W+1);      %随机选择交叉范围，N-W+1=28，从p到p+w，unidrnd表示从1到N所指定的最大数数之间的离散均匀随机整数
        for i = 1:W
            x= find(A==B(p+i-1));%去A里找和B(p+i-1)对应值相等的索引
            y= find(B==A(p+i-1));%去B里找和A(p+i-1)对应值相等的索引
            temp = A(p+i-1);
            A(p+i-1) = B(p+i-1);
            B(p+i-1) = temp;
            temp = A(x);
            A(x) = B(y);
            B(y) = temp;
        end
        %%%%%%%%%%%%%%%%%%%%%变异操作%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        p1 = floor(1+N*rand());     %取不大于x的最大整数
        p2 = floor(1+N*rand());
        while p1==p2
            p1 = floor(1+N*rand());
            p2 = floor(1+N*rand());
        end
        temp = A(p1);
        A(p1) = A(p2);
        A(p2) = temp;
        temp = B(p1);
        B(p1) = B(p2);
        B(p2) = temp;
        F = [F;A;B];
        [aa,bb] = size(F);
    end
    if aa > NP
        F = F(1:NP,:);
    end
    f = F;
    f(1,:) = R;
    clear F;
    gen = gen+1;
    Rlength(gen) = minlen;
end
disp(['(ga)优化最短距离：',num2str(minlen)]);
% disp('最短路径中经过城市的顺序:');
% disp(R);                     %输出最短路径中经过城市的顺序

%%%%%%%%%%%%遗传算法+禁忌搜索算法求解tsp问题%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%初始化参数，置空禁忌表%%%%%%%%%%%%%%%%%
% C=[ 1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;
%     3238 1229;4196 1044;4312 790;4386 570; 3007 1970;2562 1756;
%     2788 1491;2381 1676;1332 695;3715 1678;3918 2179;4061 2370;
%     3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;
%     3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;
%     2370 2975];                 %31个省会城市坐标
% N=size(C,1);                    %TSP问题的规模，即城市数目  size(X,1),返回矩阵X的行数；size(X,2)，返回矩阵X的列数；
D=zeros(N);                     %任意两个城市距离间隔矩阵   创建一个N行N列的零矩阵
Tabu=zeros(N);                  %禁忌表
TabuL=round((N*(N-1)/2)^0.5);   %禁忌长度  ((31*(31-1)/2)^0.5)等于21.56,round表示四舍五入取整
Ca=200;                         %候选集的个数（全部邻域解个数）
CaNum=zeros(Ca,N);              %候选解集合：200行31列的零矩阵
% S0=randperm(N);                 %表示城市序号，随机产生初始解，randperm(n)返回一个行向量，其中包含从1到n的整数的随机排列。
S0=R(1,:);
bestsofar=S0;                   %当前最佳解
BestL=Inf;                      %当前最佳解距离  inf表示无穷大
figure(1);
set(gcf,'position',[350 382 305 255]); %60 100表示像素位置，560 500表示宽、高
P=1;                            %当前迭代次数
% G=100;                          %最大迭代次数

%%%%%%%%%%%%%求任意两个城市间隔矩阵%%%%%%%%%
for i=1:N
    for j=1:N
        D(i,j)=((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;   %根号下A方+B方
    end
end

while P<G                    %当前迭代次数小于最大迭代次数
    ALong(P)=funcl(D,S0);     %当前解适配值
    i=1;
    A=zeros(Ca,2);            %交换的城市矩阵，200行2列
    %%%%%%%%%%%%%%%%求邻域解中交换的城市矩阵%%%%%%%%%%%
    %为了将一个200行2列的A阵用随机的方式填满，且没有任意两组数是相等的
    while i<=Ca
        M=ceil(N*rand(1,2));       %随机交换两个城市，x=rand(1,2)产生1行2列的位于（0，1）区间的随机数，ceil表示四舍五入到正无穷
        if M(1)~=M(2)        %如果两个城市序号不相等
            A(i,1)=max(M(1),M(2));
            A(i,2)=min(M(1),M(2));
            if i==1          %第一次交换
                isa=0;       %判断是否有重复交换的标志
            else
                for j=1:i-1
                    if A(i,1)==A(j,1) && A(i,2)==A(j,2)  %往上看，是否有重复交换的
                        isa=1;
                        break;
                    else
                        isa=0;
                    end
                end
            end
            if ~isa  %非  如果isa=0
                i=i+1;
            else
            end
        else         %否则，意思就是产生的两个随机数相等，那就不让i+1，继续产生随机数
        end
    end
    
    %%%%%%%%%%%产生邻域解%%%%%%%%%%%%
    %%%%%%%%%%%保留前BestCaNum个最好候选解%%%%%%%%%%%%%%%
    BestCaNum=Ca/2;
    BestCa=Inf*ones(BestCaNum,4);   %inf值的100行4列矩阵  I = Inf(n)是Inf值的n×n矩阵。
    F=zeros(1,Ca);  %1行200列的零矩阵
    for i=1:Ca
        CaNum(i,:)=S0;   %S0是CaNum的第i行。
        CaNum(i,[A(i,2),A(i,1)])=S0([A(i,1),A(i,2)]); %CaNum第i行第A（i，2）列的元素和第A(i,1)列的元素分别变为A(i,1)和A(i,2)
        %相当于CaNum第i行第A(i,1)列和A(i,2)列的元素互换位置
        F(i)=funcl(D,CaNum(i,:));  %F阵中第i个数为第i个邻域的适配值
        if i<=BestCaNum  %i=1~101循环 然后j从1~100循环
            BestCa(i,2)=F(i);  %BestCa第i行第二列等于F(i)中的第i个元素
            BestCa(i,1)=i;
            BestCa(i,3)=S0(A(i,1));
            BestCa(i,4)=S0(A(i,2));
            %BestCa中第一列为i的值 第二列为适配值 第三四列为交换的两个数
        else
            for j=1:BestCaNum
                if F(i)<BestCa(j,2)%从第101个数开始，拿该数与前面100个从上到下对比，发现一个比他大的，立刻替换，跳出循环
                    BestCa(j,2)=F(i);
                    BestCa(j,1)=i;
                    BestCa(j,3)=S0(A(i,1));
                    BestCa(j,4)=S0(A(i,2));
                    break;
                end
            end
        end
    end
    [JL,Index]=sort(BestCa(:,2));  %按BestCa第二列升序排列  JL是BestCa升序排列后的第二列元素  Index是BestCa升序排列后的第一列元素
    SBest=BestCa(Index,:);         %BestCa的第Index行=SBest
    BestCa=SBest;                  %前100个比较好的候选解
    %%%%%%%%%%%%%%%%特赦规则%%%%%%%%%%%
    if BestCa(1,2)<BestL     %候选解比最佳值都还小，那么不管在不在禁忌表中，都是一样的操作
        %在禁忌表中，全部减1，特赦出来，放在最后；
        %不在禁忌表中，全部减1，放在最后；
        BestL=BestCa(1,2);       %BestL当前最优解适配值
        S0=CaNum(BestCa(1,1),:); %最优解的替换
        bestsofar=S0;
        for m=1:N
            for n=1:N
                if Tabu(m,n)~=0
                    Tabu(m,n)=Tabu(m,n)-1;  %更新禁忌表  每迭代一次减少一次被禁忌数
                end
            end
        end
        Tabu(BestCa(1,3),BestCa(1,4))=TabuL;         %更新禁忌表，把特赦的这个放在最末端
    else                                         %候选解中最佳的解 仍然没有比目前最佳值更优，则：
        for i=1:BestCaNum                        %遍历
            if Tabu(BestCa(i,3),BestCa(i,4))==0  %BestCa就是从小到大排列的，选取第一个不在禁忌表中的解，即禁忌长度为0
                S0=CaNum(BestCa(i,1),:);         %则释放，并作为下一次迭代的初始解
                for m=1:N
                    for n=1:N
                        if Tabu(m,n)~=0
                            Tabu(m,n)=Tabu(m,n)-1;  %更新禁忌表
                        end
                    end
                end
                Tabu(BestCa(i,3),BestCa(i,4))=TabuL;%放到禁忌表最末端
                break;%立刻跳出for循环，因为已经选中不在禁忌表中的最佳解了
            end
        end
    end
    ArrBestL_GA(P)=BestL;  %记录历次迭代的最优值，当前候选解小时，记录的是候选解；否则，还是记录历史最优，也就是会出现直线部分
    P=P+1;
    for i=1:N-1
        plot([C(bestsofar(i),1),C(bestsofar(i+1),1)],[C(bestsofar(i),2),C(bestsofar(i+1),2)],'bo-');  %蓝色圆点显示
        hold on;
    end
    %用蓝色带圆圈的线将第一次迭代后的最优值连线
    plot([C(bestsofar(N),1),C(bestsofar(1),1)],[C(bestsofar(N),2),C(bestsofar(1),2)],'ro-');  %红色圆圈  前横坐标，后纵坐标
    title(['(结合GA)优化最短距离:',num2str(BestL)]);  %优化最短距离等于当前最优解
    hold off;
    pause(0.001);   %暂停(n)暂停执行n秒，然后继续。暂停必须启用此调用才能生效。
end
BestShortcut=bestsofar;    %最佳路径
theMinDistanceGA=BestL ;    %最佳路线长度
disp(['(tabu+ga)优化最短距离：',num2str(theMinDistanceGA)]);

%%%%%%%%%%%%禁忌搜索算法求解TSP问题%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%初始化参数，置空禁忌表%%%%%%%%%%%%%%%%%
% C=[ 1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;
%     3238 1229;4196 1044;4312 790;4386 570; 3007 1970;2562 1756;
%     2788 1491;2381 1676;1332 695;3715 1678;3918 2179;4061 2370;
%     3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;
%     3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;
%     2370 2975];                 %31个省会城市坐标
% N=size(C,1);                    %TSP问题的规模，即城市数目  size(X,1),返回矩阵X的行数；size(X,2)，返回矩阵X的列数；
D=zeros(N);                     %任意两个城市距离间隔矩阵   创建一个N行N列的零矩阵
Tabu=zeros(N);                  %禁忌表
TabuL=round((N*(N-1)/2)^0.5);   %禁忌长度  ((31*(31-1)/2)^0.5)等于21.56,round表示四舍五入取整
Ca=200;                         %候选集的个数（全部邻域解个数）
CaNum=zeros(Ca,N);              %候选解集合：200行31列的零矩阵
S0=randperm(N);                 %表示城市序号，随机产生初始解，randperm(n)返回一个行向量，其中包含从1到n的整数的随机排列。
% S0=R(1,:);
bestsofar=S0;                   %当前最佳解
BestL=Inf;                      %当前最佳解距离  inf表示无穷大
figure(2);
set(gcf,'position',[350 38 305 255]); %60 100表示像素位置，560 500表示宽、高
P=1;                            %当前迭代次数
% G=100;                          %最大迭代次数

%%%%%%%%%%%%%求任意两个城市间隔矩阵%%%%%%%%%
for i=1:N
    for j=1:N
        D(i,j)=((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;   %根号下A方+B方
    end
end

while P<G                    %当前迭代次数小于最大迭代次数
    ALong(P)=funcl(D,S0);     %当前解适配值
    i=1;
    A=zeros(Ca,2);            %交换的城市矩阵，200行2列
    %%%%%%%%%%%%%%%%求邻域解中交换的城市矩阵%%%%%%%%%%%
    %为了将一个200行2列的A阵用随机的方式填满，且没有任意两组数是相等的
    while i<=Ca
        M=ceil(N*rand(1,2));       %随机交换两个城市，x=rand(1,2)产生1行2列的位于（0，1）区间的随机数，ceil表示四舍五入到正无穷
        if M(1)~=M(2)        %如果两个城市序号不相等
            A(i,1)=max(M(1),M(2));
            A(i,2)=min(M(1),M(2));
            if i==1          %第一次交换
                isa=0;       %判断是否有重复交换的标志
            else
                for j=1:i-1
                    if A(i,1)==A(j,1) && A(i,2)==A(j,2)  %往上看，是否有重复交换的
                        isa=1;
                        break;
                    else
                        isa=0;
                    end
                end
            end
            if ~isa  %非  如果isa=0
                i=i+1;
            else
            end
        else         %否则，意思就是产生的两个随机数相等，那就不让i+1，继续产生随机数
        end
    end
    
    %%%%%%%%%%%产生邻域解%%%%%%%%%%%%
    %%%%%%%%%%%保留前BestCaNum个最好候选解%%%%%%%%%%%%%%%
    BestCaNum=Ca/2;
    BestCa=Inf*ones(BestCaNum,4);   %inf值的100行4列矩阵  I = Inf(n)是Inf值的n×n矩阵。
    F=zeros(1,Ca);  %1行200列的零矩阵
    for i=1:Ca
        CaNum(i,:)=S0;   %S0是CaNum的第i行。
        CaNum(i,[A(i,2),A(i,1)])=S0([A(i,1),A(i,2)]); %CaNum第i行第A（i，2）列的元素和第A(i,1)列的元素分别变为A(i,1)和A(i,2)
        %相当于CaNum第i行第A(i,1)列和A(i,2)列的元素互换位置
        F(i)=funcl(D,CaNum(i,:));  %F阵中第i个数为第i个邻域的适配值
        if i<=BestCaNum  %i=1~101循环 然后j从1~100循环
            BestCa(i,2)=F(i);  %BestCa第i行第二列等于F(i)中的第i个元素
            BestCa(i,1)=i;
            BestCa(i,3)=S0(A(i,1));
            BestCa(i,4)=S0(A(i,2));
            %BestCa中第一列为i的值 第二列为适配值 第三四列为交换的两个数
        else
            for j=1:BestCaNum
                if F(i)<BestCa(j,2)%从第101个数开始，拿该数与前面100个从上到下对比，发现一个比他大的，立刻替换，跳出循环
                    BestCa(j,2)=F(i);
                    BestCa(j,1)=i;
                    BestCa(j,3)=S0(A(i,1));
                    BestCa(j,4)=S0(A(i,2));
                    break;
                end
            end
        end
    end
    [JL,Index]=sort(BestCa(:,2));  %按BestCa第二列升序排列  JL是BestCa升序排列后的第二列元素  Index是BestCa升序排列后的第一列元素
    SBest=BestCa(Index,:);         %BestCa的第Index行=SBest
    BestCa=SBest;                  %前100个比较好的候选解
    %%%%%%%%%%%%%%%%特赦规则%%%%%%%%%%%
    if BestCa(1,2)<BestL     %候选解比最佳值都还小，那么不管在不在禁忌表中，都是一样的操作
        %在禁忌表中，全部减1，特赦出来，放在最后；
        %不在禁忌表中，全部减1，放在最后；
        BestL=BestCa(1,2);       %BestL当前最优解适配值
        S0=CaNum(BestCa(1,1),:); %最优解的替换
        bestsofar=S0;
        for m=1:N
            for n=1:N
                if Tabu(m,n)~=0
                    Tabu(m,n)=Tabu(m,n)-1;  %更新禁忌表  每迭代一次减少一次被禁忌数
                end
            end
        end
        Tabu(BestCa(1,3),BestCa(1,4))=TabuL;         %更新禁忌表，把特赦的这个放在最末端
    else                                         %候选解中最佳的解 仍然没有比目前最佳值更优，则：
        for i=1:BestCaNum                        %遍历
            if Tabu(BestCa(i,3),BestCa(i,4))==0  %BestCa就是从小到大排列的，选取第一个不在禁忌表中的解，即禁忌长度为0
                S0=CaNum(BestCa(i,1),:);         %则释放，并作为下一次迭代的初始解
                for m=1:N
                    for n=1:N
                        if Tabu(m,n)~=0
                            Tabu(m,n)=Tabu(m,n)-1;  %更新禁忌表
                        end
                    end
                end
                Tabu(BestCa(i,3),BestCa(i,4))=TabuL;%放到禁忌表最末端
                break;%立刻跳出for循环，因为已经选中不在禁忌表中的最佳解了
            end
        end
    end
    ArrBestL(P)=BestL;  %记录历次迭代的最优值，当前候选解小时，记录的是候选解；否则，还是记录历史最优，也就是会出现直线部分
    P=P+1;
    for i=1:N-1
        plot([C(bestsofar(i),1),C(bestsofar(i+1),1)],[C(bestsofar(i),2),C(bestsofar(i+1),2)],'bo-');  %蓝色圆点显示
        hold on;
    end
    %用蓝色带圆圈的线将第一次迭代后的最优值连线
    plot([C(bestsofar(N),1),C(bestsofar(1),1)],[C(bestsofar(N),2),C(bestsofar(1),2)],'ro-');  %红色圆圈  前横坐标，后纵坐标
    title(['优化最短距离:',num2str(BestL)]);  %优化最短距离等于当前最优解
    hold off;
    pause(0.001);   %暂停(n)暂停执行n秒，然后继续。暂停必须启用此调用才能生效。
end
BestShortcut=bestsofar;    %最佳路径
theMinDistanceSuiji=BestL ;    %最佳路线长度
disp(['(tabu)优化最短距离：',num2str(theMinDistanceSuiji)]);
figure(3);
set(gcf,'position',[670 100 560 500]);
plot(ArrBestL);
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');
hold on;
plot(ArrBestL_GA);
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');
legend('禁忌搜索算法','遗传算法+禁忌搜索算法')







