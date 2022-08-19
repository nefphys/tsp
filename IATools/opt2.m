%%%%%%%%%%%%%%%%%%%% 2-opt %%%%%%%%%%%%%%%%%%%%%%%
%2-opt含有的点大于2个
function route = opt2(route)
    %输入的R不包含终点
    N = length(route);
    route = [route; route(1)];
    t = randsample(2:N,2,'false');
    if t(1) < t(2)
        route(t(1):t(2)) = flip(route(t(1):t(2)));
    else
        route(t(2):t(1)) = flip(route(t(2):t(1)));
    end
    %逆转顺序？？来源blog 书上直接交换
    route(end) = [];
end