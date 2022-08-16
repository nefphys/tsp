function TSP_Solve_Struct = LKH_Solver(tspData, LKHDir, tspNorm, conPar)
% 由于没有默认参数，则tspdata输入可以是tsp文件名，或者n*3矩阵
% 要么输入xyLoc，即包含id，坐标x，坐标y的值
% 否则输入标准的tsplib文件 .tsp
% 需要回车结束程序，简直智障

%tspData：E:\Nefphys\1Projects\5.TSPcluster\FullCode\MySolver\TSPLIB\att48.tsp
%LKHDir: E:\Nefphys\1Projects\5.TSPcluster\FullCode\MySolver\LKH\
%使用完整路径，或者工作目录路径


% LKH处理的数据最好必须含有11个点
% LKH主页 http://www.math.uwaterloo.ca/tsp/LKH
%  .\LKH -o m.txt temp.tsp
% LKHDir 表示LKH求解器所在的完整路径，包含LKH.exe
% conPar 表示LKH接受的参数

% 标准返回的结构体包含
%   生成的路径长度
%   生成的路径id顺序，一个数组或向量
%   调用函数本身的时间消耗s

%% 判断输入的是文件路径还是输入的坐标值
% 如果是文件路径，则不做处理
% 如果是坐标矩阵，则生成一个tsp文件，并写入到临时文件夹中以供计算
fsize = size(tspData);
fsize(2) = fsize(2) - 1;
if fsize(1) > 1
    %生成一个tspfile
    s = "";
    s(1) = "NAME :temp";
    s(2) = "COMMENT :temp";
    s(3) = "TYPE : TSP";
    s(4) = "DIMENSION : " + fsize(1);
    s(5) = "EDGE_WEIGHT_TYPE : " + tspNorm; %"EUC_2D"; %这里需要指定一个距离范数
    s(6) = "NODE_COORD_SECTION";
    for i = 7:(fsize(1)+6)
        s(i) = tspData(i-6,1) + " " + tspData(i-6,2) + " " + tspData(i-6,3);
    end
    s(i+1) = "EOF";
    fid=fopen([LKHDir 'temp.tsp'],'w');
    for j=1:(i+1)
        fprintf(fid,'%s\n',s(j));
    end
else
    %否则将该文件copy到目标文件夹下，并改名字
    copyfile(tspData,[LKHDir 'temp.tsp']);
end

%% 就使用默认参数，(→_→)还没看懂原始的参数有哪些，该怎么用，记录时间
% 输出结果为\\LKH\\ans.txt
msd = dir();
cd(LKHDir)
tic;
[status,cmdout] = system(['LKH-2 ' 'par.txt' ' > cmdout.txt' ' &']);
t2 = toc;
%system('taskkill /f /t /im LKH-2.exe')
cd(msd(2).folder)
%% 返回结果
%读取路径和长度
fid = fopen([LKHDir 'out.txt'],'rt');
index = 1;
while ~feof(fid)
    s{index} = fgetl(fid);
    index = index + 1;
end
s = s';
temp = regexp(cell2mat(s(2)),'\d*\.?\d*','match');
TSP_Solve_Struct.length = str2num(temp{1,1});

route = [];
for i = 7 :(length(s)-2)
    route(i-6) = str2num(s{i});
end
TSP_Solve_Struct.route = route';
fid = fopen([LKHDir 'cmdout.txt'],'rt');
index = 1;
while ~feof(fid)
    s{index} = fgetl(fid);
    index = index + 1;
end
s = s';
% for i = 1:length(s)
%     if contains(s{i},'Time.total')
%         temp = regexp(cell2mat(s(i)),'\d+\.?\d+','match')
%         TSP_Solve_Struct.time = str2num(temp{1,1});
%         break
%     end
% end
TSP_Solve_Struct.time = t2;
fclose('all');
delete([LKHDir 'out.txt'])
delete([LKHDir 'temp.tsp'])
%delete([LKHDir 'cmdout.txt'])
end

% 这个思路可以借鉴，留作备份
        % NET.addAssembly('System.Windows.Forms');
        % sendkey = @(strkey) System.Windows.Forms.SendKeys.SendWait(strkey) ;
        % [ds fe] = system('LKH-2 >>out.txt &')
        % sendkey('{ENTER}'); 
        % sendkey('att48.tsp');
        % sendkey('{ENTER}'); 
        % sendkey('q'); 
        % sendkey('{ENTER}'); 
        % sendkey('exit'); 
        % sendkey('{ENTER}'); 