function [TSP_Struct] = Cal_2Opt_EA(Chrom, New_Group, SCity, maxIt)
    %% 对染色体进行2opt运算
    BestL = 0;
    CL = length(Chrom);
    CLArr = 2:CL;
    Chrom = [Chrom Chrom(1)];
    
    %当前总距离
    toDist = sum([New_Group.dist]); %距离求和
    for i = 2:(CL+1)
        C1 = SCity(SCity(:,1) == New_Group(Chrom(i-1)).point(2),2:3);
        C2 = SCity(SCity(:,1) == New_Group(Chrom(i)).point(1),2:3);
        toDist = toDist + pdist2(C1(1,:),C2(1,:));
    end
    
    if maxIt == 0
    else
        for i = 1:maxIt
            selec = randsample(CLArr,2,'false');
            if selec(1) > selec(2)
                T = selec(1);
                selec(1) = selec(2);
                selec(2) = T;
            end

            City1 = New_Group(Chrom(selec(1)-1)).point(2);
            City1 = SCity(SCity(:,1) == City1,2:3);

            City2 = New_Group(Chrom(selec(1))).point(1);
            City2 = SCity(SCity(:,1) == City2,2:3);

            City3 = New_Group(Chrom(selec(2))).point(2);
            City3 = SCity(SCity(:,1) == City3,2:3);

            City4 = New_Group(Chrom(selec(2)+1)).point(1);
            City4 = SCity(SCity(:,1) == City4,2:3);

            od1 = sqrt((City1(1) - City2(1))^2 + (City1(2) - City2(2))^2) + ...
                sqrt((City3(1) - City4(1))^2 + (City3(2) - City4(2))^2);
            nd1 = sqrt((City1(1) - City3(1))^2 + (City1(2) - City3(2))^2) + ...
                sqrt((City2(1) - City4(1))^2 + (City2(2) - City4(2))^2);
            if nd1 < od1
                Chrom(selec(1):selec(2)) = fliplr(Chrom(selec(1):selec(2)));
                for h = selec(1):selec(2)
                    t = New_Group(Chrom(h)).point(1);
                    New_Group(Chrom(h)).point(1) = New_Group(Chrom(h)).point(2);
                    New_Group(Chrom(h)).point(2) = t;
                end
                toDist = toDist + nd1 - od1; 
            end
            BestL(i) = toDist;
        end
    end
    
    TSP_Struct.route = Chrom(1:(end-1));
    TSP_Struct.length = toDist;
    TSP_Struct.BestL = BestL;
end
