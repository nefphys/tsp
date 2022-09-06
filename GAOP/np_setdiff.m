function [to_visit] = np_setdiff(n,visited)
    VL = length(visited);
    to_visit = 1:(n - VL);
    CC = 1;
    for i = 1:n
        isfind = 0;
        for h = 1:VL
            if visited(h) == i
                isfind = 1;
                break
            end
        end
        if isfind == 0
            to_visit(CC) = i;
            CC = CC + 1;
        end
    end
end
