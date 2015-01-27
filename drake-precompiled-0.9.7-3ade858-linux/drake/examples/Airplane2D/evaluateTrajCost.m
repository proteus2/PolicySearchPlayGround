% TODO: 
function [tot_cost,avg_cost_per_step] = evaluateTrajCost(xtraj,utraj,field,t)
   
   tot_cost = 0;
   for step = 1:size(t(1:end-1),2)
       x = xtraj.eval(t(step)); u = utraj.eval(t(step));
       tot_cost = tot_cost + cost(0,x,u,field);
   end 
   tot_cost
   tot_cost = tot_cost + finalCost(t(end),xtraj.eval(t(end)));
   avg_cost_per_step = tot_cost/size(t,2);
end



function [g,dg] = cost(dt,x,u,field)
R = 0.0001;

% minimize the max obstacle constraint
[c,dc] = field.obstacleConstraint(x);
[c,i]=max(c);
dc = dc(i,:);

g = (c); %+ u'*R*u);
%g = c + norm(xg-x);
%g = sum((R*u).*u,1);
dg = [0,dc,2*u'*R];

%dg = zeros(1, 1 + size(x,1) + size(u,1));
end

function [h,dh] = finalCost(t,x)
    xg=[5;9;0;0];
    
    if (norm(xg(1:2,:)-x(1:2,:)))<=0.3
        h = 0;
    else
        h = (norm(xg(1:2,:)-x(1:2,:)));
    end
    
    dh = [1,zeros(1,size(x,1))];
end
