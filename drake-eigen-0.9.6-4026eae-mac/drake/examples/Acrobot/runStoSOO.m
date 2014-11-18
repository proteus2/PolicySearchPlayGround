
    f = @(x) acrobotEvaluator(x);
    settings.dim = 4;
    settings.type = 'det';
    [finalx,finaly,t] = oo(f,1000,settings)


