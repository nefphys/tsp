%% 将一个路径返回成一个分组后的
function [Sheet2Ans] = Cal_Sheet_Ans_Group(Route)
    [Lrow Lcol] = size(Route);
    Sheet2Ans = repelem("", Lrow, 1);
    for i = 1:Lrow
        for h = 1:(Lcol-1)
            
            if Route(i,h) == 0
                Sheet2Ans(i) = Sheet2Ans(i) + "000000";
            else
                Sheet2Ans(i) = Sheet2Ans(i) + num2str(h,'%03d') + num2str(Route(i,h),'%03d');
            end
        end
    end
end
