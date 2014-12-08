function [f,fx,fxx] = fin_diff_state(fun, x, h)
    f = fun(x);
    Q = eye(4,4);
    Q(1,1) = 10;
    Q(2,2) = 10;
    xerr=[pi;0;0;0]-x;
    fx = (Q+Q')*xerr;
    fxx = (Q+Q');
end
