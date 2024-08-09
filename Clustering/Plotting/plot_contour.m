function [ out ] = plot_contour( muhat, thresh, n_nearest_points, linewidth, colour, xvals  )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [100,50]; data = randn(dim);
% Sig = 3*peakgen(1, 10, 8, dim);
% data = data + Sig;
% FWHM = 3;
% smooth_data = fast_conv(data, FWHM, 2);
% thresh = 1.5;
% plot_contour( smooth_data, thresh )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'xvals', 'var' )
   % Default value
   xvals = {1:size(muhat,2),1:size(muhat,1)};
end

if ~exist( 'n_nearest_points', 'var' )
   % Default value
   n_nearest_points = 3;
end

if ~exist( 'colour', 'var' )
   % Default value
   colour = 'black';
end

if ~exist( 'linewidth', 'var' )
   % Default value
   linewidth = 2;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
ctrans_x = inv([xvals{1}(1),1;xvals{1}(end),1])*[1;size(muhat,1)];
ctrans_y = inv([xvals{2}(1),1;xvals{2}(end),1])*[1;size(muhat,2)];
contour_points = contourc(xvals{1},xvals{2},muhat, [thresh, thresh])';
initial_points_locs = find(contour_points(:,1) == thresh);
contour_points = contour_points(setdiff(1:size(contour_points, 1), initial_points_locs),:);
connect_nearest_points( [ctrans_x(1)*contour_points(:,1) + ctrans_x(2),  ...
    ctrans_y(1)*contour_points(:,2) + ctrans_y(2)], n_nearest_points, linewidth, colour)
xlim([xvals{2}(1), xvals{2}(end)])
ylim([xvals{1}(1), xvals{1}(end)])

end

