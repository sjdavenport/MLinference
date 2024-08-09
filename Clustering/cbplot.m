function cbplot( data, crs, xvals, muhat, thresh, other_thresh, color )
% CBPLOT Plots contour boundaries and data points.
%
% DESCRIPTION:
%   This function plots contour boundaries and data points to visualize
%   clustering results.
%
% INPUTS:
%   - data: A matrix of data points (n x 2).
%   - crs: Contour boundaries.
%   - xvals: Cell array containing x-value ranges for contour plotting.
%   - muhat: Estimated means.
%   - thresh: Threshold for primary contour plotting.
%   - other_thresh: Vector of additional thresholds for contour plotting.
%   - color: Optional color for plotting (default is 'blue').
%--------------------------------------------------------------------------
% OUTPUT:
%   - No direct output. Generates a plot.
%
%--------------------------------------------------------------------------
% EXAMPLES:
% n_points = 500; thresh = 0.1;
% data = [randn(n_points,1), randn(n_points,1)];
% kernel = @(x) GkerMV(x, 0.5);
% xvals_hr = {-3:0.025:3, -3:0.025:3};
% drf = densityrfs( data, kernel, xvals_hr );
% [lower_sss, upper_sss ] = sss_cope_sets(drf.field, drf.mask, thresh, 100);
% sss_crs = lower_sss - upper_sss;
% muhat = mean(drf).field;
% cbplot( data, sss_crs, xvals_hr, muhat, thresh, setdiff(0.02:0.02:0.16, thresh) )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'color', 'var' )
   % Default value
   color = 'blue';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
ctrans_x = inv([xvals{1}(1),1;xvals{1}(end),1])*[1;size(crs,1)];
ctrans_y = inv([xvals{2}(1),1;xvals{2}(end),1])*[1;size(crs,2)];

plot(ctrans_x(1)*data(:,1) + ctrans_x(2), ctrans_y(1)*data(:,2) + ctrans_y(2),...
                    'o', 'color', 0.3*ones(1,3), 'linewidth', 1, 'MarkerSize', 3)
add_region( crs, color, 0.5 )
hold on
% points = interp_bndry( muhat', thresh, drf.xvals );
contour_points = contourc(xvals{1},xvals{2},muhat, [thresh, thresh])';
initial_points_locs = find(contour_points(:,1) == thresh);
contour_points = contour_points(setdiff(1:size(contour_points, 1), initial_points_locs),:);
connect_nearest_points( [ctrans_x(1)*contour_points(:,1) + ctrans_x(2), ctrans_y(1)*contour_points(:,2) + ctrans_y(2)] , 3, 2 )

for thr = other_thresh
    thr
    contour_points = contourc(xvals{1},xvals{2},muhat, [thr, thr])';
    initial_points_locs = find(contour_points(:,1) == thr);
    contour_points = contour_points(setdiff(1:size(contour_points, 1), initial_points_locs),:);
    connect_nearest_points( [ctrans_x(1)*contour_points(:,1) + ctrans_x(2), ctrans_y(1)*contour_points(:,2) + ctrans_y(2)] , 3, 1, 0.5*ones(1,3) )
end
xlim([ctrans_x(1)*xvals{1}(1) + ctrans_x(2), ctrans_x(1)*xvals{1}(end) + ctrans_x(2)])
ylim([ctrans_y(1)*xvals{2}(1) + ctrans_y(2), ctrans_y(1)*xvals{2}(end) + ctrans_y(2)])

xticks(ctrans_x(1)*(xvals{1}(1):xvals{1}(end)) + ctrans_x(2))
yticks(ctrans_y(1)*(xvals{2}(1):xvals{2}(end)) + ctrans_y(2))

xticklabels(xvals{1}(1):xvals{1}(end))
yticklabels(xvals{2}(1):xvals{2}(end))

end

