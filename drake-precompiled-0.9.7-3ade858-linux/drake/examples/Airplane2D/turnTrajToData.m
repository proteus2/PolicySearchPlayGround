function [x,y] = turnTrajToData(xtraj,utraj,t,alpha)
    x = xtraj.eval(t);
    if exist('alpha','var')
        x=[x; ones(1,size(t,2))*alpha];
    end
    y = utraj.eval(t);
end