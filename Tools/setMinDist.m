%计算集合之间的最短距离，并返回集合内的点id
function [minDist C1 C2] = setMinDist(set1, set2)
    M = pdist2(set1,set2);
    minDist = min(min(M));
    %有可能有几组点都是最小的，随机选择一组即可
    [C1 C2] = find(M == minDist);
    C1 = C1(1);
    C2 = C2(1);
end