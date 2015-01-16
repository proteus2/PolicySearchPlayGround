function [x,y] = aggregateDataFromCell(data,alpha)
    n_batch = size(data,1);
    x=[];y=[];

    dt = 0.01;
    for idx = 1:n_batch
        % get time idx
        xtraj = data{idx,1};
        tf = xtraj.getBreaks; 
        tf=tf(end); 
        t = 0:dt:tf;
        
        xtraj= xtraj.eval(t);
        utraj = data{idx,2};
        utraj = utraj.eval(t); 
        
        % make it into a data form
        x = [x xtraj];
        y = [y utraj];
    end
    x=[x; ones(1,size(x,2))*alpha];
    x=x';y=y';  
end
