%% ��ջ�������
clear all;
clc;

%% ��ʼ������
load citys_data.mat;
n = size(citys, 1);                               % ������Ŀ
D = zeros(n);                                    % �������
Tabu = zeros(n);                               % ���ɱ�
TabuL = round(sqrt(n*(n-1)/2));         % ���ɳ���
Ca = 200;                                          % ��ѡ���ĸ���(ȫ����������)
Canum = zeros(Ca, n);                       % ��ѡ�⼯��
S0 = randperm(n);                            % ���������ʼ��
bestsofar = S0;                                 % ��ǰ��ѽ�
BestL = Inf;                                       % ��ǰ��ѽ���룬 inf��ʾ�����
iter = 1;                                           % ��ʼ��������
iter_max = 1000;                              % ����������

%% ����λ��
figure;
plot(citys(:, 1), citys(:, 2), 'ms', 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
legend('����λ��')
title('���зֲ�ͼ', 'fontsize', 12)
xlabel('����λ�ú�����', 'fontsize', 12)
ylabel('����λ��������', 'fontsize', 12)
grid on
for i = 1:n
    text(citys(i, 1), citys(i, 2), ['   ' num2str(i)]);
end

%% ����������
for i = 1:n
    for j = i+1:n
        D(i, j) = sqrt(sum((citys(i, :)-citys(j, :)).^2));
        D(j, i) = D(i, j);
    end
end

%% �����Ż�
while iter < iter_max
    ALong(iter) = fitness(D, S0);     % ��ǰ·����Ӧ��ֵ
    i = 1;
    A = zeros(Ca,2);            % �����ĳ��о���200��2��
    %% ��������н����ĳ��о���
    % ��һ��200��2�е�A��������ķ�ʽ��������û����������������ȵ�
    while i <= Ca
        r = ceil(n*rand(1,2));         % ���������������
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
    %% ���������
    % ����ǰBestCanum����ú�ѡ��
    BestCanum = Ca/2;
    BestCa = Inf * ones(BestCanum, 4);
    F = zeros(1, Ca);
    for i = 1:Ca
        Canum(i, :) = S0;       
        Canum(i, [A(i, 2), A(i, 1)]) = S0([A(i, 1), A(i, 2)]);  % ����A(i, 1)��A(i, 2)�е�Ԫ��
        F(i) = fitness(D, Canum(i, :)); 
        if i <= BestCanum    % ѡȡ��ѡ��
            BestCa(i, 1) = i;       % ��1�б������
            BestCa(i, 2) = F(i);   % ��2�б�����Ӧ��ֵ(·������)
            BestCa(i, 3) = S0(A(i, 1));     % ��3�б��潻���������
            BestCa(i, 4) = S0(A(i, 2));     % ��4�б��潻���������
        else
            for j = 1:BestCanum   % ���º�ѡ��
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
    % �Ժ�ѡ��������Ӧ��ֵ������������
    [value, index] = sort(BestCa(:, 2)); 
    SBest = BestCa(index, :);         
    BestCa = SBest;                     % ѡȡǰ100���ȽϺõĺ�ѡ��
    %% ����׼��
    if BestCa(1,2) < BestL     % ��ѡ������ֵ����С����ô�����ڲ��ڽ��ɱ��У�����һ���Ĳ���
        % �ڽ��ɱ��У�ȫ����1������������������
        % ���ڽ��ɱ��У�ȫ����1���������
        BestL = BestCa(1, 2);               % BestL��ǰ���Ž�����ֵ
        S0 = Canum(BestCa(1,1), :);     % ���Ž���滻
        bestsofar = S0;
        % ���½��ɱ�
        for i = 1:n
            if Tabu(i, :) ~= 0
                Tabu(i, :) = Tabu(i, :)-1;
            end
        end
        Tabu(BestCa(1, 3), BestCa(1, 4)) = TabuL;         % ���½��ɱ�����������������ĩ��
    else                 % ��ѡ������ѵĽ� ��Ȼû�б�Ŀǰ���ֵ���ţ���
        for i = 1:BestCanum                        % ������ѡ��
            if Tabu(BestCa(i, 3), BestCa(i, 4)) == 0  % BestCa���Ǵ�С�������еģ�ѡȡ��һ�����ڽ��ɱ��еĽ⣬�����ɳ���Ϊ0
                S0 = Canum(BestCa(i, 1), :);         % ���ͷţ�����Ϊ��һ�ε����ĳ�ʼ��
                for j = 1:n
                    if Tabu(j, :) ~= 0
                        Tabu(j, :) = Tabu(j, :)-1;
                    end
                end
                Tabu(BestCa(i, 3), BestCa(i, 4)) = TabuL;   % �ŵ����ɱ���ĩ��
                break;  %  ��������forѭ������Ϊ�Ѿ�ѡ�в��ڽ��ɱ��е���ѽ���
            end
        end
    end
    L_best(iter) = BestL;            % ��¼���ε���������ֵ
    iter = iter+1;                      % ����������1
%     for i = 1:n-1
%         plot([citys(bestsofar(i), 1), citys(bestsofar(i+1), 1)], [citys(bestsofar(i), 2), citys(bestsofar(i+1), 2)], 'bo-');  % ��ɫԲ����ʾ
%         hold on;
%     end
%     % �ú�ɫ��ԲȦ���߽���һ�ε����������ֵ����
%     plot([citys(bestsofar(n), 1), citys(bestsofar(1), 1)], [citys(bestsofar(n), 2), citys(bestsofar(1), 2)], 'ro-');  %��ɫԲȦ  ǰ�����꣬��������
%     title(['�Ż���̾���:', num2str(BestL)]);  %�Ż���̾�����ڵ�ǰ���Ž�
%     hold off;
%     pause(0.005);   %��ͣ(n)��ִͣ��n�룬Ȼ���������ͣ�������ô˵��ò�����Ч��
end
%% �����ʾ
disp(['��̾��룺', num2str(BestL)]);
disp(['���·����', num2str(bestsofar)]);
%% ��ͼ
figure;
plot([citys(bestsofar, 1); citys(bestsofar(1), 1)], [citys(bestsofar, 2); citys(bestsofar(1), 2)],...
    'ms-', 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
grid on;
for i = 1:n
    text(citys(i, 1), citys(i, 2), ['   ' num2str(i)]);
end
text(citys(bestsofar(1), 1), citys(bestsofar(1), 2), '       ���');
text(citys(bestsofar(end), 1), citys(bestsofar(end), 2), '       �յ�');
legend('��������')
title(['TS�㷨�Ż�·��(��̾���:' num2str(BestL) ')'], 'fontsize', 12);
xlabel('����λ�ú�����', 'fontsize', 12)
ylabel('����λ��������', 'fontsize', 12)
figure;
plot(L_best, 'r');
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('��Ӧ�Ƚ�������')







