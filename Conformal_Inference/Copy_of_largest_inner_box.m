function [out, maxSize, topLeft, bottomRight] = largest_inner_box(matrix)
    % mask = imgload('MNImask');
    % lm = largest_box(dilate_mask(mask(:,:,50),2));
    % addregion({ones(size(dilate_mask(mask(:,:,50),2))), dilate_mask(mask(:,:,50),2), lm}, {'black', 'yellow', 'red'})

    [rows, cols] = size(matrix);
    S = zeros(rows, cols);
    
    % Initialize first row and column of S
    S(1, :) = matrix(1, :);
    S(:, 1) = matrix(:, 1);
    
    maxSize = 0;
    topLeft = [0, 0];
    bottomRight = [0, 0];
    
    % Fill the S matrix
    for i = 2:rows
        for j = 2:cols
            if matrix(i, j) == 1
                S(i, j) = min([S(i-1, j), S(i, j-1), S(i-1, j-1)]) + 1;
                
                if S(i, j) > maxSize
                    maxSize = S(i, j);
                    bottomRight = [i, j];
                    topLeft = bottomRight - [maxSize-1, maxSize-1];
                end
            end
        end
    end
    out = zeros(size(matrix));
    out((topLeft(1)):(bottomRight(1)), topLeft(2):bottomRight(2)) = 1;
end