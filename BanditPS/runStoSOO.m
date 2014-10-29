function [finalx,finaly] = runStoSOO()
    f = @(x) AcrobotControllerWrapper(x);
    settings.dim = 4;
    settings.type = 'det';
    [finalx,finaly] = oo(f,10,settings)
end

