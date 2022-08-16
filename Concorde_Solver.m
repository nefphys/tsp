function TSP_Solve_Struct = Concorde_Solver(tspData, concordeDir, tspNorm, conPar)
% TSP_Solve_Struct = Concorde_Solver('tspdata/pcb442.tsp', 'A1concorde\', 'EUC_2D', 'par.txt')
% 由于没有默认参数，则tspdata输入可以是tsp文件名，或者n*3矩阵
% 要么输入xyLoc，即包含id，坐标x，坐标y的值
% 否则输入标准的tsplib文件 .tsp

%tspData：E:\Nefphys\1Projects\5.TSPcluster\FullCode\MySolver\TSPLIB\att48.tsp
%concordeDir: E:\Nefphys\1Projects\5.TSPcluster\FullCode\MySolver\concorde\
%使用完整路径，或者工作目录路径


% concorde处理的数据最好必须含有11个点
% concorde主页 http://www.math.uwaterloo.ca/tsp/concorde
%  .\concorde -o m.txt temp.tsp
% concordeDir 表示concorde求解器所在的完整路径，包含concorde.exe
% conPar 表示concorde接受的参数

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
    fid=fopen([concordeDir 'temp.tsp'],'w');
    for j=1:(i+1)
        fprintf(fid,'%s\n',s(j));
    end
else
    %否则将该文件copy到目标文件夹下，并改名字
    copyfile(tspData,[concordeDir 'temp.tsp']);
end

%% 就使用默认参数，(→_→)还没看懂原始的参数有哪些，该怎么用，记录时间
% 输出结果为\\concorde\\ans.txt
tic;
concorde_cmd = ['E:' ' && ' 'cd ' concordeDir ' && ' 'concorde -o m.txt temp.tsp'];
[status,cmdout] = system(concorde_cmd);
end_time = toc;
TSP_Solve_Struct.time = end_time;

%% 返回结果
%读取路径和长度
fid = fopen([concordeDir 'm.txt'],'rt');
s = fscanf(fid,'%f %f');
fclose('all');
cmdout = strsplit(cmdout,'\n')';
TSP_Solve_Struct.route = s(2:end);

%% 正则表达式提取cmdout输出的距离
for i = 1:length(cmdout)
    if contains(cmdout(i),'Optimal Solution')
        temp = regexp(cell2mat(cmdout(i)),'\d*\.?\d*','match');
        TSP_Solve_Struct.length = str2double(temp{1,1});
        break
    end
end

%% 清除concorde生成的临时文件，仅保留concorde.exe
s = dir(concordeDir);
for i = 3:length(s)
    if ~contains(s(i).name,'.exe')
        delete([s(i).folder '\' s(i).name]);
    end
end

end