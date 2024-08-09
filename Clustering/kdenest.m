function density_eval = kdenest(points, data, kernel)
% densum: Estimates the density at a set of points using a kernel density estimator.
%
% Usage: density_eval = densum(points, data)
%--------------------------------------------------------------------------
% Arguments:
%   points  - A matrix of size (n_points x D) containing the points at which the density needs to be evaluated.
%   data    - A matrix of size (n_data x D) containing the data used to estimate the density.
%   kernel  - a D dimensional function handle giving the kernel
%--------------------------------------------------------------------------
% Output:
%   density_eval - A vector of size (1 x n_points) containing the density estimates at each point in 'points'.
%--------------------------------------------------------------------------
% Examples:
% % 1D example
% xvals = linspace(-3,3,100)';
% density_eval = kdenest(xvals, randn(500,1), @(x)Gker(x, 1))
% plot(xvals, density_eval)
%
% % 2D example
% data = [randn(100,1), randn(100,1)];
% xvals = {-3:0.1:3, -3:0.1:3};
% [x1,x2] = meshgrid(xvals{1}, xvals{2});
% x1 = x1(:);
% x2 = x2(:);
% xvals_grid = [x1(:), x2(:)];
% density_eval = kdenest(xvals_grid, data, @(x)GkerMV(x, 2));
% density_eval_rs = reshape(density_eval, [length(xvals{2}), length(xvals{1})])'
% imagesc(density_eval_rs)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
n_data = size(data, 1);
n_points = size(points, 1);
density_eval = zeros(1,n_points);
for I = 1:n_data
    density_eval = density_eval + kernel(points' - data(I,:)');
end
density_eval = density_eval/n_data;

end

