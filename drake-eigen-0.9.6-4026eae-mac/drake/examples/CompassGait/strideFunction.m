function [xf,traj] = strideFunction(p,x0)
    hx0 = [1;x0]; %hybrid x0
    traj = simulate(p, [0 2], hx0);
    tf = traj.te(1);
    xf = traj.traj{2}.eval(tf);
end