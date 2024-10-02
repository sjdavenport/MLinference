%%
tic
% Generate inner sets
[threshold_inner, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.2);

% Generate outer sets
[threshold_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.2);
toc

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/val_crs_combo_80/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for ex = [61,114,144,148,251,7,211,1062,398,269]
    % I
    % ex = val_ex_indices(I);
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
tic
% Generate inner sets
[threshold_inner, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.05);

% Generate outer sets
[threshold_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.05);
toc

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/val_crs_combo_95/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for ex = [61,114,144,148,251,7,211,1062,398,269]
    % I
    % ex = val_ex_indices(I);
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

%% Joint
%%
tic
% Generate inner sets
[threshold_inner, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.02);

% Generate outer sets
[threshold_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.08);
toc

%%

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/joint_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for ex = [61,114,144,148,251,7,211,1062,398,269]
    % I
    % ex = val_ex_indices(I);
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