function [f,fx,fxx] = fin_diff_control(fun, u, h)
    f = fun(u);
    R=10;
    fx = 2*R*u;
    fxx = 2*R*eye(1,1);
end
