function to_visit = MY_setdiff(n,visited,type)
    if type == 1
        %标准顺序，1到n
        to_visit = MY_setdiff1(n,visited);
    else
        %非标准顺序，集合类型
        to_visit = MY_setdiff2(n,visited);
    end
end

function to_visit = MY_setdiff1(n,visited)
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

function Z = MY_setdiff2(X,Y)
        if min(Y) == 0
            X = X + 1;
            Y = Y + 1;
            if ~isempty(X)&&~isempty(Y)
              check = false(1, max(max(X), max(Y)));
              check(X) = true;
              check(Y) = false;
              Z = X(check(X))-1;  
            else
              Z = X-1;
            end
        else
            if ~isempty(X)&&~isempty(Y)
              check = false(1, max(max(X), max(Y)));
              check(X) = true;
              check(Y) = false;
              Z = X(check(X));  
            else
              Z = X;
            end
        end
end