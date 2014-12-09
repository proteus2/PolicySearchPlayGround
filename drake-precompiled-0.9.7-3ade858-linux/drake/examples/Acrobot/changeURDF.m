function changeURDF(m1_desired,m2_desired)
    % Read txt into cell A
    fid = fopen('Acrobot.urdf','r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);
    
    % Change cell A
    temp = A{21};
    temp = [temp(1:18),'"',num2str(m1_desired),'" />'];
    A{21} = temp;

    temp = A{38};
    temp = [temp(1:18),'"',num2str(m2_desired),'" />'];
    A{38} = temp;


    % Write cell A into txt
    fid = fopen('Acrobot2.urdf', 'w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end
end