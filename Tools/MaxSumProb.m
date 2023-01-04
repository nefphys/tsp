function [imax iy isum iprob] = MaxSumProb(p, s)
    %% s == 1 则只是最大值函数
    if s == 1
%         imax = p(1);
%         iy = 1;
%         for i = 2:length(p)
%             if imax < p(i)
%                 imax = p(i);
%                 iy = i;
%             end
%         end
        [imax iy] = max(p);
        isum = 0;
        iprob = 0;
    else
        imax = p(1);
        iy = 1;
        isum =0;
        iprob = p;
        for i = 1:length(p)
            if imax < p(i)
                imax = p(i);
                iy = i;
            end
            isum = isum + p(i);
            iprob(i) = isum;
        end
        iprob = iprob / isum;
    end
end