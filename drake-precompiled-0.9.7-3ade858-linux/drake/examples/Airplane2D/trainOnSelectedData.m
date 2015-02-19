function [ctrller] = trainOnSelectedData(trainIdx,data_set,controller)
    %% given a data set and the train indicies, return a controller trained on the train indicies of the dataset
    load('RF_seed');
    x_list = []; y_list = [];
    for dataidx=1:numel(trainIdx)
        tidx = trainIdx(dataidx);
        data_x = data_set{tidx,1};
        data_y = data_set{tidx,2};
        
        switch controller
            case 'TreeBagger'
                x_list = [x_list; data_x'];
                y_list = [y_list; data_y'];
                if dataidx == numel(trainIdx)
                    ctrller = TreeBagger(50,x_list,y_list,'Method','regression','MinLeaf',1);
                end
            case 'MMDController'
                if dataidx == 1
                    load('RF_seed');
                    ctrller = MMDController(RF_seed);
                end
                rng(RF_seed);
                ctrller = setNewController(ctrller,data_x,data_y);
            otherwise
                warning('unknown controller type')
        end
    end
end