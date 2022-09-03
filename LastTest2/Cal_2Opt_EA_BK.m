function [TSP_Struct An_G] = Cal_2Opt_EA_BK(Chrom, New_Group, SCity, maxIt)
    %% 对染色体进行2opt运算
    %% Scity 去重
    [ix iy] = unique(SCity(:,1));
    SCity = SCity(iy,:);
    
    %% 转成矩阵处理 加快速度
    BestL = 0;
    BKS = zeros(1,maxIt+1);
    CL = length(Chrom);
    CT = CL - 1;
    New_Mat = zeros(length(New_Group),4);
    for i = 1:length(New_Group)
        New_Mat(i,1) = New_Group(i).order;
        New_Mat(i,2) = New_Group(i).dist;
        New_Mat(i,3) = New_Group(i).point(1);
        New_Mat(i,4) = New_Group(i).point(2);
    end

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
    BKS(1) = toDist;
    
    %% 所有端点之间的距离
    allDist = pdist2(SCity(:,2:3), SCity(:,2:3));
   
    
    if maxIt == 0
    else
            seleM = randi(CT,maxIt,2);
            seleM = seleM + 1;
        for i = 1:maxIt
            %selec = randsample(CLArr,2,'false');
            selec = seleM(i,:);
            if selec(1) == selec(2)
                selec = randperm(CT, 2);
                selec = selec + 1;
            end
            if selec(1) > selec(2)
                T = selec(1);
                selec(1) = selec(2);
                selec(2) = T;
            end
            
            Cind = [Chrom(selec(1)-1) Chrom(selec(1)) Chrom(selec(2)) Chrom(selec(2)+1)];
            
            CindF1 = find(Scity(:,1) == New_Mat(Cind(1),4));
            CindF2 = find(Scity(:,1) == New_Mat(Cind(2),3));
            CindF3 = find(Scity(:,1) == New_Mat(Cind(3),4));
            CindF4 = find(Scity(:,1) == New_Mat(Cind(4),3));
            
            od1 = allDist(CindF1, CindF2) + allDist(CindF3, CindF4);
            nd1 = allDist(CindF1, CindF3) + allDist(CindF2, CindF4);
            
%             od1 = allDist(, ) + ...
%                 allDist(Scity(:,1) == New_Mat(Cind(3),4), Scity(:,1) == New_Mat(Cind(4),3));
%             od1 = allDist(Scity(:,1) == New_Mat(Cind(1),4), Scity(:,1) == New_Mat(Cind(3),4)) + ...
%                 allDist(Scity(:,1) == New_Mat(Cind(2),4), Scity(:,1) == New_Mat(Cind(4),3));
%             
            City1 = New_Group(Cind(1)).point(2);
            City1 = FSMat(City1,:);
            
            City2 = New_Group(Cind(2)).point(1);
            City2 = FSMat(City2,:);
            
            City3 = New_Group(Cind(3)).point(2);
            City3 = FSMat(City3,:);
            
            City4 = New_Group(Cind(4)).point(1);
            City4 = FSMat(City4,:);

            od1 = sqrt((City1(1) - City2(1))^2 + (City1(2) - City2(2))^2) + ...
                sqrt((City3(1) - City4(1))^2 + (City3(2) - City4(2))^2);
            nd1 = sqrt((City1(1) - City3(1))^2 + (City1(2) - City3(2))^2) + ...
                sqrt((City2(1) - City4(1))^2 + (City2(2) - City4(2))^2);
            if nd1 < od1
                for h = selec(1):selec(2)
                    t = New_Group(Chrom(h)).point(1);
                    New_Group(Chrom(h)).point(1) = New_Group(Chrom(h)).point(2);
                    New_Group(Chrom(h)).point(2) = t;
                end
                Chrom(selec(1):selec(2)) = fliplr(Chrom(selec(1):selec(2)));
                toDist = toDist + nd1 - od1; 
                BKS(i+1) = toDist;
            else
                BKS(i+1) = BKS(i);
            end
            BestL(i) = toDist;
        end
    end
    An_G = New_Group;
    TSP_Struct.route = Chrom(1:(end-1));
    TSP_Struct.length = toDist;
    TSP_Struct.BestL = BKS;
end