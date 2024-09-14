function contour_points = interp_bndry( xvals, muhat, thr )
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
% xvals = {1:100, 1:50};
% contour_points = interp_bndry( xvals, smooth_data, thresh );
% plot(contour_points(:,1), contour_points(:,2), '*')
%
% % Actually there's an inbuilt matlab function which does this already in 2D: 
% contour_points = contourc(xvals{2}, xvals{1}, smooth_data, [thresh, thresh])';
% contour_points = contour_points(2:end,:);
% plot(contour_points(:,1), contour_points(:,2), '*')
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
contour_points = contourc(xvals{2},xvals{1},muhat, [thr, thr])';
initial_points_locs = find(contour_points(:,1) == thr);
contour_points = contour_points(setdiff(1:size(contour_points, 1), initial_points_locs),:);

end

