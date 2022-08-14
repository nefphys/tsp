function Z = MY_setdiff(X,Y)
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