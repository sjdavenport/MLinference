function [drf, data] = densityrfs( y, kernel, xvals )
% densityrfs( y, xvals ) derives random fields for densities evaluated on
% the region specified by xvals.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  y: an n by D matrix where each entry is an independent draw from a 2D
%       distribution
%  kernel: a D dimensional function handle giving the kernel
%  xvals:  a D by 1 cell array where the dth entry is a vector of points to
%       evaluate the density in the dth direction
%--------------------------------------------------------------------------
% OUTPUT
%  drf: an object of fields class containing random fields for each
%       observation
%--------------------------------------------------------------------------
% EXAMPLES
% y = [0+.5*rand(20,1) 5+2.5*rand(20,1);
%             .75+.25*rand(10,1) 8.75+1.25*rand(10,1)];
% xvals = {-0.25:.05:1.25, 0:.1:15};
% kernel = @(x) GkerMV( x, 0.75 );
% drf = densityrfs( y, kernel, xvals )
% density_estimate = mean(drf);
% surf(density_estimate.field)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
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
[x1,x2] = meshgrid(xvals{1}, xvals{2});
x1 = x1(:);
x2 = x2(:);
n = size(y, 1);

lenofxvals1 = length(xvals{1});
lenofxvals2 = length(xvals{2});

data = zeros([lenofxvals1, lenofxvals2, n]);
xvals_grid = [x1(:), x2(:)]';

for I = 1:n
    data(:,:,I) = reshape(kernel(xvals_grid - y(I,:)'), [lenofxvals2, lenofxvals1])';
end

drf = Field(data, true([lenofxvals1, lenofxvals2]), xvals);

end

% for I = 1:n
%     modul(I,10)
%     for J = 1:lenofxvals1
%         for K = 1:lenofxvals2
%             data(J,K,I) = kernel([xvals{1}(J); xvals{2}(K)] - y(I,:)');
%         end
%     end
% end

% for I = 1:n
%     pdf_of_data = ksdensity(y(I),xi);
%     data(:,:,I) = reshape(pdf_of_data, [lenofxvals2, lenofxvals1])';
% end
