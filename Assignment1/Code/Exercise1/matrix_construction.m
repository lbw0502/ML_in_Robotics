function matrix = matrix_construction(v_w_vw,p)
    num = size(v_w_vw,2);
    matrix = ones(1,num);
    for i = 1:p
        matrix = [matrix;v_w_vw.^i];
    end
end
