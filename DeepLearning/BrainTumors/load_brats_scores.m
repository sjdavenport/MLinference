function [ scores, tumor_mask, orig_im, brain_mask, all_masks] = load_brats_scores( id )
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
%
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
% Load scores from disk
saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/scores/';

idstrtemp = num2str(id);
idstr = '000';
if id < 10
    idstr(end) = idstrtemp;
elseif id < 100
    idstr(end-1:end) = idstrtemp;
else
    idstr = idstrtemp;
end
a = load([saveloc, 'scores_', num2str(id), '.mat']);
X = extractdata(a.X);
scores = X(:,:,:,2);

% Load brain mask
datadir =  '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/images/';
b = load([datadir, 'BRaTS', idstr]);
orig_im = b.cropVol;

labeldir =  '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/labels/';
b = load([labeldir, 'BRaTS', idstr]);
tumor_mask = b.cropLabel;

% Shrink the output to the original input size
orig_im_size = size(orig_im);
extra_padding = [orig_im_size(1:3) - size(scores), 0];
orig_im = pad_im(orig_im, -extra_padding/2);

% Calculate the brain mask from where the original T1w image is non-zero.
all_masks = ~(orig_im == 0);
brain_mask = (sum(all_masks,4) == 4);

% Shrink the tumor mask
tumor_mask = pad_im(tumor_mask, -extra_padding/2);

% Mask the scores
scores = scores.*brain_mask;

end

