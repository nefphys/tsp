function SelCh=All_Crossover(SelCh,Pc)
%% 交叉操作
% 输入
%SelCh  被选择的个体
%Pc     交叉概率
%输出：
%SelCh	交叉后的个体
    
    NSel=size(SelCh,1);
    LX = 1:NSel;
    for i = 1: floor(NSel/2)
        if Pc >= rand
            %选择两条染色体
            nid1 = randsample(LX, 1, false);
            LX(LX == nid1) = [];
            nid2 = randsample(LX, 1, false);
            LX(LX == nid2) = [];
            [SelCh(nid1,:) SelCh(nid2,:)] = interCross(SelCh(nid1,:), SelCh(nid2,:));
        end
    end
end

function [ta tb] = interCross(a, b)
    % 包含起点和终点的数据，
    a = a(1:(end-1));
    b = b(1:(end-1));
    %多点交叉
    LY = length(a);
    %从0开始计数
    Ystart =  randsample(2:floor(LY/2),1);
    Yend = randsample(floor(LY/2):(LY-1),1);
    repa = a(Ystart:Yend);
    repb = b(Ystart:Yend);
    ta = [a(1:(Ystart-1)) repb a((Yend+1):LY)];
    tb = [b(1:(Ystart-1)) repa b((Yend+1):LY)];
    
    %ta 中重复的城市
    morea = MY_setdiff(repb+1,repa+1)-1;
    %tb 中重复的城市
    moreb = MY_setdiff(repa+1,repb+1)-1;
    
    j = 1;
    for i = 1:length(morea)
        idx = find(ta == morea(i));
        %返回两个坐标id，替换其中一个坐标
        if idx(1) >= Ystart && idx(1) <= Yend
            ta(idx(2)) = moreb(j);
        else
            ta(idx(1)) = moreb(j);
        end
        idx = find(tb == moreb(i));
        %返回两个坐标id，替换其中一个坐标
        if idx(1) >= Ystart && idx(1) <= Yend
            tb(idx(2)) = morea(j);
        else
            tb(idx(1)) = morea(j);
        end
        j = j + 1;
    end
    ta = [ta ta(1)];
    tb = [tb tb(1)];
end