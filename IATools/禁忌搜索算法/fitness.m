function Length = fitness(D, R)
%% ����·�߳���
% ���룺D  �������  R  ��ǰ·��
% �����Length    ��ǰ·�߳���
Length = 0;
n = length(R);      % ���и���
for i = 1:n-1
    Length = Length+D(R(i), R(i+1));
end
Length = Length + D(R(n), R(1));