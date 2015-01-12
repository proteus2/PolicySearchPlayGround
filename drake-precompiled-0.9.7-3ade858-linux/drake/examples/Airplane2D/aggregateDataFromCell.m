function [x,y] = aggregateDataFromCell(data,alpha)
    n_batch = size(data,1);
    x=[];y=[];
    x=data{1,1};
    y=data{1,2};

    dt=data{2,1}.getBreaks; dt=dt(end)-dt(end-1);
    for idx = 2:n_batch
        % get time idx
        xtraj = data{idx,1};
        tf = xtraj.getBreaks; 
        dt=tf(end)-tf(end-1);
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
