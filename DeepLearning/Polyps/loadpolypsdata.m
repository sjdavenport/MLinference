datadir = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/';

a = load([datadir, 'polpys_scores.mat' ] );

scores = permute(a.sgmd, [2,3,1]);

b = load([datadir, 'gt_masks.mat' ] );
gt_masks = permute(b.gt_masks, [2,3,1]);

n_images = size(scores, 3);
%%
subplot(1,2,1)
imagesc(scores(:,:,1))
axis off image
subplot(1,2,2)
imagesc(gt_masks(:,:,1))
axis off image

%% Split the softmax scores into calibration and validation sets (save the shuffling)
ncal = 500;
idx = zeros(1,n_images);
idx(1:ncal) = 1;
idx = logical(idx(randperm(length(idx))));

cal_scores = scores(:,:,idx);
val_scores = scores(:,:,~idx);

cal_gt_masks = gt_masks(:,:,idx);
val_gt_masks = gt_masks(:,:,~idx);