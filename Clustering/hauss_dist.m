function [ hdist, distfromAtoB, distfromBtoA ] = hauss_dist(  ...
                                       A_bndry, B_bndry, f_A, f_B, thresh )
% Computes the Hausdorff distance between the boundaries of two sets A and B.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory input arguments:
% A_bndry: an N_A-by-2 array of the boundary points of set A.
% B_bndry: an N_A by-2 array of the boundary points of set B.
% f_A: a function that returns a scalar value for each point in R^2
% f_B: a function that returns a scalar value for each point in R^2.
% thresh: a scalar threshold value.
%--------------------------------------------------------------------------
% Output:
% hdist: the Hausdorff distance between A_bndry and B_bndry.
% distfromAtoB: the maximum distance from points in A_bndry that are 'close enough' to B_bndry.
% distfromBtoA: the maximum distance from points in B_bndry that are 'close enough' to A_bndry.
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% % Find the haussdorrf distance between two circles ones centred at (0,0)
% % and the other centred at (2,0) each with radius 1.
% f_A = @(x,y) 1-(x.^2 + y.^2);
% xvals = {-1.5:0.1:3, -1.5:0.1:1.5};
% thr = 0;
% [x1, x2] = meshgrid(xvals{1}, xvals{2});
% muhat_A = f_A(x1,x2)';
% % A_bndry = interp_bndry( muhat_A, thr, xvals )
% A_bndry = interp_bndry( xvals, muhat_A, thr )
% f_B = @(x,y) 1 - ((x-2).^2 + y.^2);
% muhat_B = f_B(x1,x2)';
% % B_bndry = interp_bndry( muhat_B, thr, xvals )
% B_bndry = interp_bndry( xvals, muhat_B, thr )
% plot(A_bndry(:,1), A_bndry(:,2), '*'); hold on; plot(B_bndry(:,1), B_bndry(:,2), '*');
% hauss_dist(A_bndry, B_bndry, f_A, f_B, thr )
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
if isempty(A_bndry) || isempty(B_bndry)
    hdist = 10^10;
    return
end

AoutsideB = A_bndry(f_B(A_bndry(:,1),A_bndry(:,2)) <= thresh, :);
BoutsideA = B_bndry(f_A(B_bndry(:,1),B_bndry(:,2)) <= thresh, :);

% Ie since they both exist, this implies that one lies within the other!
if isempty(AoutsideB) 
    distfromBtoA = 0;
else
    ABdistances = pdist2(AoutsideB, B_bndry);
    distfromBtoA = max(min(ABdistances'));
end


if isempty(BoutsideA)
    distfromAtoB = 0;
else
    BAdistances = pdist2(BoutsideA, A_bndry);
    distfromAtoB = max(min(BAdistances'));
end

hdist = max(distfromAtoB, distfromBtoA);
% 
% subplot(1,2,1)
% plot2(A_bndry); hold on; plot2(B_bndry)
% subplot(1,2,2)
% plot2(AoutsideB); hold on; plot2(B_bndry)

end

% Deprecated alternative:
% distfromAtoB = max(min(AoutsideB - B_bndry'));
% distfromBtoA = max(min(BoutsideA - A_bndry'));

