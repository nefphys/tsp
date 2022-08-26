function [TSP_Struct An_G] = Cal_2Opt_EA(Chrom, New_Group, SCity, maxIt)
    %% 对染色体进行2opt运算
    BestL = 0;
    BKS = zeros(1,maxIt+1);
    CL = length(Chrom);
    CLArr = 2:CL;
    Chrom = [Chrom Chrom(1)];
    CT = CL-1;
    %Scity更改为一种可以直接索引的数据
    FScity = SCity(:,1);
    %当前总距离
    AGdist = sum([New_Group.dist]); %距离求和
    toDist = AGdist;
    for i = 2:(CL+1)
        C1 = SCity(FScity == New_Group(Chrom(i-1)).point(2),2:3);
        C2 = SCity(FScity == New_Group(Chrom(i)).point(1),2:3);
        toDist = toDist + ...
            sqrt( (C1(1,1) - C2(1,1))^2 + (C1(1,2) - C2(1,2))^2);
        %pdist2(C1(1,:),C2(1,:))
    end
    BKS(1) = toDist; 
    
    %
    FSMat = [];
    FSMat(FScity,1:2) = SCity(:,2:3);
    if maxIt == 0
    else
            seleM = randi(CT,maxIt,2);
            seleM = seleM + 1;
            City1I = 0;
            City2I = 0;
            City3I = 0;
            City4I = 0;
            City1 = [0,0];
            City2 = [0,0];
            City3 = [0,0];
            City4 = [0,0];
        for i = 1:maxIt
            %selec = randsample(CLArr,2,'false');
            selec = CalSelem(seleM(i,:), CLArr);
            
            Cind = [Chrom(selec(1)-1) Chrom(selec(1)) Chrom(selec(2)) Chrom(selec(2)+1)];
            
            City1I = New_Group(Cind(1)).point(2);
            City1 = FSMat(City1I,:);
            
            City2I = New_Group(Cind(2)).point(1);
            City2 = FSMat(City2I,:);
            
            City3I = New_Group(Cind(3)).point(2);
            City3 = FSMat(City3I,:);
            
            City4I = New_Group(Cind(4)).point(1);
            City4 = FSMat(City4I,:);
%             City1 = New_Group(Cind(1)).point(2);
%             City1 = SCity(FScity == City1,2:3);
%             City1 = City1(1,:);
% 
%             City2 = New_Group(Cind(2)).point(1);
%             City2 = SCity(FScity == City2,2:3);
%             City2 = City2(1,:);
%             
%             City3 = New_Group(Cind(3)).point(2);
%             City3 = SCity(FScity == City3,2:3);
%             City3 = City3(1,:);
% 
%             City4 = New_Group(Cind(4)).point(1);
%             City4 = SCity(FScity == City4,2:3);
%             City4 = City4(1,:);
            
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

function selec = CalSelem(seleM,CLArr)
    if seleM(1) == seleM(2)
        selec = randsample(CLArr,2,'false');
    elseif seleM(1) > seleM(2)
        selec = [seleM(2) seleM(1)];
    else
        selec = seleM;
    end
end