function Chrom = Init_Chrom(Route)
    %传入一个Route，则这里需要进行的计算是
    
    %随机选择一个点作为起点
    
    start = randsample(1:length(Route),1);
    
    %随机选择一个方向作为终点
    if rand > 0.5 %向前取值
        if start == 1
            mend = Route;
        else
            mend = [Route(start:end) Route(1:(start-1))];
        end
    else %向后取终点
        if start == length(Route)
            mend = Route(fliplr(1:end));
        else
            mend = [Route(fliplr(1:start)) Route(fliplr((start+1):end))];
        end
    end
    Chrom = mend';
end