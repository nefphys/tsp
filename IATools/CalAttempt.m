function tempStruct = CalAttempt(tempCity, tarStruct)
    tempStruct = tarStruct;
    %% 没有起点和终点
    LL = size(tempCity,1);
    tsp = [];
    if tarStruct.inID == 0 && tarStruct.outID == 0
        %选择第一个点作为起点
        tsp(1) = tarStruct.set(1);
        SC = tempCity(1,:);
        tempCity(1,:) = [];
        tarStruct.set(1) = [];
        for i = 1:(LL-2)
            MM = pdist2(SC, tempCity);
            [ix iy] = min(MM);
            tempCity(iy,:) = [];
            tsp(i+1) = tarStruct.set(iy);
            tarStruct.set(iy) = [];
        end
        tsp(end+1) = tarStruct.set;
        tempStruct.tsp = tsp;
        tempStruct.isover = 1;
    end
    
    %% 有起点和终点
    if tarStruct.inID ~= 0 && tarStruct.outID ~= 0
        %删除终点
        fid = find(tarStruct.set == tarStruct.outID);
        tempCity(fid,:) = [];
        tarStruct.set(fid) = [];
        
        %选择起点
        fid = find(tarStruct.set == tarStruct.inID);
        tsp(1) = tarStruct.inID;
        SC = tempCity(fid,:);
        tempCity(fid,:) = [];
        tarStruct.set(fid) = [];

        for i = 1:(LL-3)
            MM = pdist2(SC, tempCity);
            [ix iy] = min(MM);
            tempCity(iy,:) = [];
            tsp(i+1) = tarStruct.set(iy);
            tarStruct.set(iy) = [];
        end
        tsp(end+1) = tarStruct.set;
        tsp(end+1) = tarStruct.outID;
        tempStruct.tsp = tsp;
        tempStruct.isover = 1;
    end
    
    %% 没有起点有终点
    if tarStruct.inID == 0 && tarStruct.outID ~= 0
         %删除终点
        fid = find(tarStruct.set == tarStruct.outID);
        tempCity(fid,:) = [];
        tarStruct.set(fid) = [];
        
        %选择第一个点作为起点
        tsp(1) = tarStruct.set(1);
        SC = tempCity(1,:);
        tempCity(1,:) = [];
        tarStruct.set(1) = [];

        for i = 1:(LL-3)
            MM = pdist2(SC, tempCity);
            [ix iy] = min(MM);
            tempCity(iy,:) = [];
            tsp(i+1) = tarStruct.set(iy);
            tarStruct.set(iy) = [];
        end
        tsp(end+1) = tarStruct.set;
        tsp(end+1) = tarStruct.outID;
        tempStruct.tsp = tsp;
        tempStruct.isover = 1;
    end
    
    %% 没有终点有起点
    if tarStruct.inID ~= 0 && tarStruct.outID == 0
        %选择起点
        fid = find(tarStruct.set == tarStruct.inID);
        tsp(1) = tarStruct.inID;
        SC = tempCity(fid,:);
        tempCity(fid,:) = [];
        tarStruct.set(fid) = [];

        for i = 1:(LL-2)
            MM = pdist2(SC, tempCity);
            [ix iy] = min(MM);
            tempCity(iy,:) = [];
            tsp(i+1) = tarStruct.set(iy);
            tarStruct.set(iy) = [];
        end
        tsp(end+1) = tarStruct.set;
        tempStruct.tsp = tsp;
        tempStruct.isover = 1;
    end
end