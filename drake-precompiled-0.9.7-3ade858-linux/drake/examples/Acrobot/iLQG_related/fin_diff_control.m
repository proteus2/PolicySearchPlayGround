function [f,fx,fxx] = fin_diff_control(fun, u, R)
    f = fun(u);
%     R=1;
    fx = 2*R*u;
    fxx = 2*R;
end
