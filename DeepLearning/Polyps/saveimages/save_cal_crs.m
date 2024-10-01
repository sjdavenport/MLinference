%% Learning Inner/Outer sets
rng(2, 'twister')
learning_idx = randsample(1798, 298);
other_idx = setdiff(1:1798, learning_idx);

rng(5, 'twister')
cal_samples = randsample(1500, 1000);
val_samples = setdiff(1:1500, cal_samples);
cal_idx = other_idx(cal_samples);
val_idx = other_idx(val_samples);

cal_idx_ex = cal_idx - 1;
val_idx_ex = val_idx - 1;

val_ex_indices = intersect(ex_indices, val_idx_ex);
cal_ex_indices = intersect(ex_indices, cal_idx_ex);

cal_scores = scores(:,:,cal_idx);
cal_scores_dist = scores_dist(:,:,cal_idx);
cal_scores_bt_inner = scores_dist_bt_inner(:,:,cal_idx);
cal_scores_bt_outer = scores_dist_bt_outer(:,:,cal_idx);

cal_gt_masks = gt_masks(:,:,cal_idx);
val_scores = scores(:,:,val_idx);
val_gt_masks = gt_masks(:,:,val_idx);

%%
% Generate inner sets
[threshold_inner, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.1);

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/val_crs_combo_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 1:135
    I
    ex = val_ex_indices(I);
    score_im = scores(:,:,ex+1);
    score_im_dist = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold_inner;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (-score_im_dist) > threshold_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/cal_crs_combo_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 1:281
    I
    ex = cal_ex_indices(I);
    score_im = scores(:,:,ex+1);
    score_im_dist = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold_inner;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (-score_im_dist) > threshold_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end

%%
% Generate inner sets
[threshold_inner, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_outer, max_vals_dist_outer] = CI_fwer(1-cal_scores, 1-cal_gt_masks, 0.1);

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/val_crs_orig_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 1:135
    I
    ex = val_ex_indices(I);
    score_im = scores(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold_inner;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (1-score_im) > threshold_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/cal_crs_orig_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = [2,36,45]
    I
    ex = cal_ex_indices(I);
    score_im = scores(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold_inner;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (1-score_im) > threshold_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end


%%
% Generate inner sets
[threshold_inner_bt, max_vals] = CI_fwer(cal_scores_bt_inner, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_outer_bt, max_vals_dist_outer] = CI_fwer(-cal_scores_bt_outer, 1-cal_gt_masks, 0.1);

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/val_crs_bt_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 1:135
    I
    ex = val_ex_indices(I);
    score_im_inner = scores_dist_bt_inner(:,:,ex+1);
    score_im_outer = scores_dist_bt_outer(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im_inner > threshold_inner_bt;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (-score_im_outer) > threshold_outer_bt);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/cal_crs_bt_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = [2,36,45]
    I
    ex = cal_ex_indices(I);
    score_im_inner = scores_dist_bt_inner(:,:,ex+1);
    score_im_outer = scores_dist_bt_outer(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im_inner > threshold_inner_bt;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (-score_im_outer) > threshold_outer_bt);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end