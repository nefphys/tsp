function Length = fitness(D, R)
%% 计算路线长度
% 输入：D  距离矩阵  R  当前路线
% 输出：Length    当前路线长度
Length = 0;
n = length(R);      % 城市个数
for i = 1:n-1
    Length = Length+D(R(i), R(i+1));
end
Length = Length + D(R(n), R(1));