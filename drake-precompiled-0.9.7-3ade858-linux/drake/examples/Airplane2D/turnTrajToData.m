function [x,y] = turnTrajToData(xtraj,utraj,t,alpha,x0)
    x = xtraj.eval(t);
    if exist('alpha','var')
        x=[x; ones(1,size(t,2))*alpha];
    end
    
    if exist('x0','var')
        x=[x; repmat(x0,1,size(t,2))];
    end
    y = utraj.eval(t);
end