function [data,position] = readfile(fileAddress,isdist)
%首先判断是否是文本文件，如果本身就是数组，则只用计算距离即可
%可以指定是否需要返回距离 部分算法不需要返回距离，因为时间空间消耗比较大
data = 0;
if size(fileAddress,1) > 1
    position = fileAddress;
    if isdist
        data = zeros(size(position,1),size(position,1));
        for i = 1:size(position,1)
            for j = i:size(position,1)
                data(i,j) = norm(position(i,:) - position(j,:));
            end
        end
        data = data + data';
    end
else
    fid = fopen(fileAddress);
    index = 1;
    s = [];
    while ~feof(fid)
        s{index} = fgetl(fid);
        index = index + 1;
    end
    s = s';
    %找到开始的数据所在的行
    for i = 1:length(s)
        if ~isempty(str2num(s{i}))
            strind = i;
            break
        end
    end
    s = s(strind:end);
    %判断最后的是不是数字
    if isempty(str2num(s{end}))
       s(end) = []; 
    end
    position = zeros(length(s),2);
    for i = 1:length(s)
        temp = strsplit(s{i},' ');
        position(i,1) = str2double(temp{2});
        position(i,2) = str2double(temp{3});
    end
    if isdist 
        data = zeros(length(s),length(s));
        for i = 1:length(s)
            for j = i:length(s)
                data(i,j) = norm(position(i,:) - position(j,:),2);
            end
        end
        data = data + data';
    end
    fclose('all');
end
end