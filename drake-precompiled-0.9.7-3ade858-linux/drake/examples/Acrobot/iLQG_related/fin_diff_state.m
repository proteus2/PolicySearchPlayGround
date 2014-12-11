function [f,fx,fxx] = fin_diff_state(fun, x, Q)
    f = fun(x);
%     Q = eye(4,4);
%     Q(1,1) = 10;
%     Q(2,2) = 10;
    xerr=[pi;0;0;0]-x;
    %fx = (Q+Q')*xerr; % I think this should be derivative w.r.t x, not xerr
    fx = (Q+Q')*x - 2*Q*[pi;0;0;0];
    %fx = 2*xerr'*Q;
    fxx = (Q+Q');
end
