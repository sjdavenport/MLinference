function [ outer_boudaries ] = get_bndries( mask )
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
% MNImask = imgload('MNImask')
% outer_boundaries = get_bndries(MNImask(:,:,50));
% subplot(2,2,1); imagesc(outer_boundaries.upper); axis off image;
% subplot(2,2,2); imagesc(outer_boundaries.lower); axis off image;
% subplot(2,2,3); imagesc(outer_boundaries.right); axis off image;
% subplot(2,2,4); imagesc(outer_boundaries.left); axis off image;
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
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
clear outer_boudaries

shifted_mask = zeros(size(mask));
shifted_mask(2:end, :) = mask(1:(end-1), :);
outer_boudaries.lower = mask - shifted_mask > 0;

shifted_mask = zeros(size(mask));
shifted_mask(1:end-1, :) = mask(2:end, :);
outer_boudaries.upper = mask - shifted_mask > 0;

shifted_mask = zeros(size(mask));
shifted_mask(:, 2:end) = mask(:, 1:(end-1));
outer_boudaries.left = mask - shifted_mask > 0;

shifted_mask = zeros(size(mask));
shifted_mask(:, 1:end-1) = mask(:, 2:end);
outer_boudaries.right = mask - shifted_mask > 0;

end

