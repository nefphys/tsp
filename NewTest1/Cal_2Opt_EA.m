function [TSP_Struct An_G] = Cal_2Opt_EA(Chrom, New_Group, SCity, maxIt, allDist, New_Mat, CCBP, toDist)
    %% 对染色体进行2opt运算
    BKS = zeros(1,maxIt+1);
    BKS(1) = toDist;
    CL = length(Chrom);
    CT = CL - 1;
    Chrom = [Chrom Chrom(1)];
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
            od1 = allDist(New_Mat(Cind(1),4), New_Mat(Cind(2),3)) + allDist(New_Mat(Cind(3),4), New_Mat(Cind(4),3));
            nd1 = allDist(New_Mat(Cind(1),4), New_Mat(Cind(3),4)) + allDist(New_Mat(Cind(2),3), New_Mat(Cind(4),3));

            if nd1 < od1
                %%交换顺序
                t = New_Mat(Chrom(selec(1):selec(2)),4);
                New_Mat(Chrom(selec(1):selec(2)),4) = New_Mat(Chrom(selec(1):selec(2)),3);
                New_Mat(Chrom(selec(1):selec(2)),3) = t;
                Chrom(selec(1):selec(2)) = fliplr(Chrom(selec(1):selec(2)));
                toDist = toDist + nd1 - od1; 
                BKS(i+1) = toDist;
            else
                BKS(i+1) = BKS(i);
            end
        end
    end
    
    %还原id
    for i = 1:length(New_Group)
        New_Group(i).point = [CCBP(New_Mat(i,3)) CCBP(New_Mat(i,4))];
    end
    An_G = New_Group;
    TSP_Struct.route = Chrom(1:(end-1));
    TSP_Struct.length = toDist;
    TSP_Struct.BestL = BKS;
end