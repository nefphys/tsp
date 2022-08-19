%% 给出ansgroup，返回标准
function [Ans2Sheet] = Cal_Ans_Sheet_Group(ANS_GROUP)
    %% 按照ans_group给定的顺序排序，并生成顺序表
    
    AG_order = "";
    for i = 1:length(ANS_GROUP)
        AG_order(i) = ANS_GROUP(i).order;
    end
    
    %对order进行排序
    [ord1 ord2] = sort(AG_order);
    
    %生成ans2sheet，默认转子是0
    Ans2Sheet = zeros(length(AG_order), strlength(ord1(1))/6+1);
    
    for i = 1:size(Ans2Sheet,1)
        temp = convertStringsToChars(ord1(i));
        for h = 1:(size(Ans2Sheet,2)-1)
            temp1 = temp(1:6);
            temp(1:6) = [];
            if temp1(1:3) == '0'
            else
                Ans2Sheet(i,h) = str2num(temp1(4:6)+"");
            end
        end
    end

end