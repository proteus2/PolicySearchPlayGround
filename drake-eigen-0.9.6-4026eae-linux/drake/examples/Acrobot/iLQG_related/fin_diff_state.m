function [f,fx,fxx] = fin_diff_state(fun, x, h)
    f = fun(x);
    Q = eye(4,4);
    Q(1,1) = 1;
    Q(2,2) = 1;
    Q=Q*1/2;
    xerr=[pi;0;0;0]-x;
    %fx = (Q+Q')*xerr; % I think this should be derivative w.r.t x, not xerr
    fx = (Q+Q')*x - 2*Q*[pi;0;0;0];
    fxx = (Q+Q');
end
