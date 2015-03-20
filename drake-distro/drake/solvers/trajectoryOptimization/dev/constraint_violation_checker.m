% A script for violation checking

[g,h]=plan.nonlinearConstraints(x_sol);

% names of violated constraints
violated_lb_names = plan.cin_name(g<plan.cin_lb);
violated_ub_names = plan.cin_name(g>plan.cin_ub);
violated_eq_names = plan.ceq_name(h~=0);

% values of violated constraints
violated_lb_val = abs(g(g<plan.cin_lb) - plan.cin_lb(g<plan.cin_lb));
violated_ub_val = abs(g(g>plan.cin_ub) - plan.cin_lb(g>plan.cin_ub));
violated_eq_val = abs(h(h~=0));

% names of violated cons, sorted
[~,idx] = sort(violated_lb_val,'descend');
sorted_violated_lb_names = violated_lb_names(idx);

[~,idx] = sort(violated_ub_val,'descend');
sorted_violated_ub_names = violated_ub_names(idx);

[~,idx] = sort(violated_eq_val,'descend');
sorted_violated_eq_names = violated_eq_names(idx);
