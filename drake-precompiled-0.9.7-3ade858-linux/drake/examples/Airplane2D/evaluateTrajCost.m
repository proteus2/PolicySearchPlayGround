%TODO: Test this function
function [tot_cost,avg_cost_per_step] = evaluateTrajCost(xtraj,utraj,field,t)

   tot_cost = 0;
   for step = 1:size(t(1:end-1))
       x = xtraj.eval(step); u = utraj.eval(step);
       tot_cost = tot_cost + cost(0,x,u,field);
   end 
    
   tot_cost = tot_cost + finalCost(t(end),xtraj.eval(t(end)));
   
end



function [g,dg] = cost(dt,x,u,field)
R = 0.0001;

% minimize the max obstacle constraint
[c,dc] = field.obstacleConstraint(x);
[c,i]=max(c);
dc = dc(i,:);

g = c + u'*R*u;
%g = sum((R*u).*u,1);
dg = [0,dc,2*u'*R];

%dg = zeros(1, 1 + size(x,1) + size(u,1));
end

function [h,dh] = finalCost(t,x)
h = t;
dh = [1,zeros(1,size(x,1))];
end
