function bbox_mask = bounding_box(mask)
% Input:
% mask - 2D binary mask (logical array) with region of interest
% mask = imgload('MNImask'); mask2D = mask(:,:,50);
% bbox_mask = bounding_box(mask2D);
% add_region({ones(size(mask2D)), bbox_mask, mask2D}, {'black', 'blue','yellow'})

% lrsum = sum(mask, 2);
% lrlocs = lrsum > 0;
% udsum = sum(mask, 2);
% udlocs = udsum > 0;
%
% lrfind = find(lrlocs);
% udfind = find(udlocs);
[number_of_clusters, ~, ~, index_locations] = numOfConComps(mask, 0.5, 8);

% Create an empty mask of the same size
bbox_mask = zeros(size(mask));
if number_of_clusters == 1
    % Find the row and column indices of the non-zero elements
    [rows, cols] = find(mask);

    % Get the bounding box limits
    row_min = min(rows);
    row_max = max(rows);
    col_min = min(cols);
    col_max = max(cols);

    % Set the region corresponding to the bounding box to 1
    bbox_mask(row_min:row_max, col_min:col_max) = 1;
else
    for I = 1:number_of_clusters
        cluster_im = zeros(size(mask));
        cluster_im(index_locations{I}) = 1;

        % Find the row and column indices of the non-zero elements
        [rows, cols] = find(cluster_im);

        % Get the bounding box limits
        row_min = min(rows);
        row_max = max(rows);
        col_min = min(cols);
        col_max = max(cols);

        % Set the region corresponding to the bounding box to 1
        bbox_mask(row_min:row_max, col_min:col_max) = 1;
        % bbox_mask(lrlocs(1):lrlocs(2), udfind(1):udfind) = 1;
    end
end

end
