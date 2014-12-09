function [f,fx,fxx] = fin_diff_control(fun, u, h)
    f = fun(u);
    fx = u;
    fxx = eye(1,1);
end
