function [New_Group Chrom SCity] = Cal_Layer_Group(calLayer, ANS_GROUP, City)
    New_Group.order = 0;
    New_Group.dist = 0;
    New_Group.tsp = 0; %用于复原路径
    New_Group.point = 0;; %端点，方便后续计算距离
    
    Chrom = 0;
    %解析 ans_group 经过排序的 与anssheet对应
    [Ans2Sheet ANS_ID] = Cal_Ans_Sheet_Group(ANS_GROUP); %带有转向子
    ANS_ID = ANS_ID';
    
    %指定染色体的层数
    Ans2Sheet = Ans2Sheet(:,1:min(calLayer,size(Ans2Sheet,2)-2));
    
    Ori_Str = "";
    [Lrow Lcol] = size(Ans2Sheet);
    hInd = num2str((1:Lcol)','%03d')+"";
    for i = 1:Lrow
        temp = "";
        for h = 1:Lcol
            if Ans2Sheet(i,h) == 0
                temp = temp + "000000";
            else
                temp = temp + hInd(h) + num2str(Ans2Sheet(i,h),'%03d');
            end
        end
        Ori_Str(i) = temp;
    end
    Ori_Str = Ori_Str';
    
    %每个id对应的ANS_STRUCT 的位置
    UN_Str = unique(Ori_Str,'stable');
    SCity = zeros(length(UN_Str)*2 ,3);
    for i = 1:length(UN_Str)
        nid = find(UN_Str(i) == Ori_Str);
        New_Group(i).order = i;
        Chrom(i) = i;
        New_Group(i).point(1) = ANS_GROUP(nid(1)).tsp(1);
        New_Group(i).point(2) = ANS_GROUP(nid(end)).tsp(end);
        
        SCity((i-1)*2+1,1) = ANS_GROUP(nid(1)).tsp(1);
        SCity((i-1)*2+1,2:3) = City(SCity((i-1)*2+1,1),:);
        
        SCity(2*i,1) = New_Group(i).point(2);
        SCity(2*i,2:3) = City(SCity(2*i,1),:);
        
        New_Group(i).tsp = [ANS_GROUP(nid).tsp];
        New_Group(i).dist = sum([ANS_GROUP(nid).gdist]);
        % 再加上端点的连线
        if length(nid) > 1
            for h = 2:length(nid)
                 New_Group(i).dist =  New_Group(i).dist + ...
                     pdist2(City(ANS_GROUP(nid(h-1)).tsp(end),:), ...
                     City(ANS_GROUP(nid(h)).tsp(1),:));
            end
        end
    end
end
