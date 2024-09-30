function [bbox_mask] = largest_inner_box(mask)
% mask = imgload('MNImask');
% lm = largest_box(dilate_mask(mask(:,:,50),2));
% addregion({ones(size(dilate_mask(mask(:,:,50),2))), dilate_mask(mask(:,:,50),2), lm}, {'black', 'yellow', 'red'})

[number_of_clusters, ~, ~, index_locations] = numOfConComps(mask, 0.5, 8);

% Create an empty mask of the same size
bbox_mask = zeros(size(mask));

if number_of_clusters == 1
    [rows, cols] = size(mask);
    S = zeros(rows, cols);

    % Initialize first row and column of S
    S(1, :) = mask(1, :);
    S(:, 1) = mask(:, 1);

    maxSize = 0;
    topLeft = [0, 0];
    bottomRight = [0, 0];

    % Fill the S matrix
    for i = 2:rows
        for j = 2:cols
            if mask(i, j) == 1
                S(i, j) = min([S(i-1, j), S(i, j-1), S(i-1, j-1)]) + 1;

                if S(i, j) > maxSize
                    maxSize = S(i, j);
                    bottomRight = [i, j];
                    topLeft = bottomRight - [maxSize-1, maxSize-1];
                end
            end
        end
    end
    bbox_mask((topLeft(1)):(bottomRight(1)), topLeft(2):bottomRight(2)) = 1;
else
    for I = 1:number_of_clusters
        cluster_im = zeros(size(mask));
        cluster_im(index_locations{I}) = 1;

        [rows, cols] = size(cluster_im);
        S = zeros(rows, cols);

        % Initialize first row and column of S
        S(1, :) = cluster_im(1, :);
        S(:, 1) = cluster_im(:, 1);

        maxSize = 0;
        topLeft = [0, 0];
        bottomRight = [0, 0];

        % Fill the S matrix
        for i = 2:rows
            for j = 2:cols
                if cluster_im(i, j) == 1
                    S(i, j) = min([S(i-1, j), S(i, j-1), S(i-1, j-1)]) + 1;

                    if S(i, j) > maxSize
                        maxSize = S(i, j);
                        bottomRight = [i, j];
                        topLeft = bottomRight - [maxSize-1, maxSize-1];
                    end
                end
            end
        end
        bbox_mask((topLeft(1)):(bottomRight(1)), topLeft(2):bottomRight(2)) = 1;
    end
end
end