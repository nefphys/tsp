%计算集合之间的最短距离，并返回集合内的点id
%集合1中C1元素到集合2中C2元素最近
%EX1 EX2 排除1， 2中的元素不作为运算点
function [minDist C1 C2] = setMinDist(set1, set2, EX1, EX2)
    %矩阵大于5GB则不能直接计算了
    Lsize = length(set1) * length(set2);
    LP = 6.710868923308190e+08;
    if Lsize < LP
        M = pdist2(set1,set2);
        if EX1 ~= 0
            M(EX1,:) = 1e20;
        end
        if EX2 ~= 0
            M(:,EX2) = 1e20;
        end
        minDist = min(min(M));
        %有可能有几组点都是最小的，随机选择一组即可
        [C1 C2] = find(M == minDist);
        C1 = C1(1);
        C2 = C2(1);
    else
        %分块进行计算
        spNum = ceil(Lsize / LP);
        %存储最小点对
        AminDIst = [];
        AC1 = [];
        AC2 = [];
        FL = ceil(linspace(0,length(set2),spNum+1));
        for jk = 1:(length(FL)-1)
            tset2 = set2((FL(jk)+1):FL(jk+1),:);
            M = pdist2(set1,tset2);
            if EX1 ~= 0
                M(EX1,:) = 1e20;
            end
            if EX2 ~= 0
                if EX2 >= (FL(jk)+1) && EX2 <= FL(jk+1)
                     M(:,EX2-FL(jk)) = 1e20;
                end
            end
            AminDIst(jk) = min(min(M));
            %有可能有几组点都是最小的，随机选择一组即可
            [AC1(jk) AC2(jk)] = find(M == AminDIst(jk),1);
        end
        %找到最小的一组
        minDist = min(AminDIst);
        index = find(AminDIst == minDist, 1);
        C1 = AC1(index);
        C2 = AC2(index) + FL(jk);
    end
end