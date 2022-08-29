%% 生成的数据集
 % 1000 5000 10000  9组数据 
 
%% 螺旋形
Num = 5000;
r = linspace(100,2000,Num);%半径
a = 2000;%圆心横坐标
b = 2000;%圆心纵坐标
theta = 0:(pi/Num*4):4*pi; %角度[0,2*pi] 
theta = theta(1:(end-1));
noise = rand(1,length(theta))*100;
x = a+r.*cos(theta) + noise;
y = b+r.*sin(theta) + noise;
%scatter(x,y)
%hold on
r = linspace(100,2000,Num);%半径
a = 2000;%圆心横坐标
b = 2000;%圆心纵坐标
theta = pi:(pi/Num*4):5*pi; %角度[0,2*pi] 
theta = theta(1:(end-1));
noise = rand(1,length(theta))*100;
x1 = a+r.*cos(theta) + noise;
y1 = b+r.*sin(theta) + noise;
%scatter(x1,y1)

d1 = [x' y';x1' y1'];
d1 = round(d1,3);
scatter(d1(:,1),d1(:,2))




%% 圆环型
Num = 500;
r = 1000;%半径
a = 1000;%圆心横坐标
b = 1000;%圆心纵坐标
theta = 0:pi/Num:2*pi; %角度[0,2*pi] 
theta = theta(1:(end-1));
noise = rand(1,length(theta))*400;
x = a+r*cos(theta) + noise;
y = b+r*sin(theta) + noise;
%scatter(x,y)
%hold on
r = 500;%半径
a = 1000;%圆心横坐标
b = 1000;%圆心纵坐标
theta = 0:pi/Num:2*pi; %角度[0,2*pi] 
theta = theta(1:(end-1));
noise = rand(1,length(theta))*400;
x1 = a+r*cos(theta) + noise;
y1 = b+r*sin(theta) + noise;
%scatter(x1,y1)
d1 = [x' y';x1' y1'];
d1 = round(d1,3);
scatter(d1(:,1),d1(:,2))




%% 月牙型
Num = 5000;
cof = 5;
x1 = linspace(-3,3,Num)';
noise = rand(Num,1) * 0.3;
y1 = - x1 .^ 2 /cof + 3 + noise;
x1 = x1*100 + 300;
y1 = y1 * 300;

x2 =  linspace(0, 6, Num)';
y2 = (x2-3).^2 /cof + 0.5 + noise;
x2 = x2*100 + 300;
y2 = y2 * 300;


d1 = [x1 y1;x2 y2];
d1 = round(d1,3);
scatter(d1(:,1),d1(:,2))

