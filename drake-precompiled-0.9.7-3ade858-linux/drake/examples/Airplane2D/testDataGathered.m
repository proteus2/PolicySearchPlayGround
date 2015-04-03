load('./controllers/mmd_observable_controller.mat');

x = x';y=y';
load('RF_seed');
rng(RF_seed);
[controller] = TreeBagger(50,x,y,'Method','regression');
save('observable_supervised_controller','controller','data','train_alpha_list');

