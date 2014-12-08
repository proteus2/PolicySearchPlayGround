function [f,fx,fxx] = fin_diff_control(fun, u, h)
    f = fun(u);
    R = 1;
    fx = u;
    fxx = eye(1,1);
end
