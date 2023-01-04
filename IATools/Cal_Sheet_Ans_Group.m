%% 将一个路径返回成一个分组后的
function [Sheet2Ans] = Cal_Sheet_Ans_Group(Route)
    [Lrow Lcol] = size(Route);
    Sheet2Ans = repelem("", Lrow, 1);
    hInd = num2str((1:(Lcol-1))','%03d')+"";
    nroute = Route(:);
    nroute = num2str(nroute,'%03d')+""; %按列排序的
    for i = 1:Lrow
        for h = 1:(Lcol-1)
            
            if nroute(Lrow*(h-1) + i) == "000"
                Sheet2Ans(i) = Sheet2Ans(i) + "000000";
            else
                Sheet2Ans(i) = Sheet2Ans(i) + hInd(h) + nroute(Lrow*(h-1) + i);
            end
        end
    end
end
