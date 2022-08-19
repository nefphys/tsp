%%%%%%%%%%%%%%%适配值函数%%%%%%%%%
function F=funcl(D,s)    %定义funcl函数  声明函数名、输入和输出
DistanV=0;   
n=size(s,2);  %size(s,2)，返回矩阵s的列数；
for i=1:(n-1)
    DistanV=DistanV+D(s(i),s(i+1));
end
DistanV=DistanV+D(s(n),s(1));
F=DistanV;
end