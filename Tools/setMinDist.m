%计算集合之间的最短距离，并返回集合内的点id
%集合1中C1元素到集合2中C2元素最近
%EX1 EX2 排除1， 2中的元素不作为运算点
function [minDist C1 C2] = setMinDist(set1, set2, EX1, EX2)
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
end