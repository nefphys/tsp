function [SCity allDist New_Mat CCBP toDist] = Cal_2Opt_EA_Pre(Chrom, New_Group, SCity, maxIt)
    [ix iy] = unique(SCity(:,1));
    SCity = SCity(iy,:);
    CL = length(Chrom);
    CT = CL - 1;
    %% 转成矩阵处理 加快速度
    %BestL = 0;
    
    New_Mat = zeros(length(New_Group),4);
    CC = 1;
    CCBP = 0;
    for i = 1:length(New_Group)
        New_Mat(i,1) = New_Group(i).order;
        New_Mat(i,2) = New_Group(i).dist;
        if New_Group(i).point(1) == New_Group(i).point(2)
            New_Mat(i,3) = CC;
            New_Mat(i,4) = CC;
            CCBP(CC) = New_Group(i).point(1);
            CC = CC + 1;
        else
            New_Mat(i,3) = CC;
            New_Mat(i,4) = CC + 1;
            CCBP(CC) = New_Group(i).point(1);
            CCBP(CC+1) = New_Group(i).point(2);
            CC = CC + 2;
        end
    end

    %% 重置端点id 避免查找
    for i = 1:size(SCity,1)
        SCity(i,1) = find(SCity(i,1) == CCBP);
    end
    [ix iy] = sort(SCity(:,1));
    SCity = SCity(iy,:);
    
    Chrom = [Chrom Chrom(1)];
    %当前总距离
    AGdist = sum(New_Mat(:,2)); %距离求和
    toDist = AGdist;
    for i = 2:(CL+1)
        C1 = SCity(SCity(:,1) == New_Mat(Chrom(i-1),4),2:3);
        C2 = SCity(SCity(:,1) == New_Mat(Chrom(i),3),2:3);
        toDist = toDist + ...
            sqrt( (C1(1,1) - C2(1,1))^2 + (C1(1,2) - C2(1,2))^2);
    end
    %% 所有端点之间的距离
    allDist = pdist2(SCity(:,2:3), SCity(:,2:3));
end