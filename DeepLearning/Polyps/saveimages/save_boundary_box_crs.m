box_gt = zeros(size(scores));

for I = 1:1798
    I
    box_gt(:,:,I) = bounding_box(gt_masks(:,:,I));
end

cal_box_gt = box_gt(:,:,cal_idx);
val_box_gt = box_gt(:,:,val_idx);

%%
% Generate inner sets
[threshold_inner_bb, max_vals] = CI_fwer(cal_scores_bt_outer, cal_box_gt, 0.1);

% Generate outer sets
[threshold_outer_bb, max_vals_dist_outer] = CI_fwer(-cal_scores_bt_outer, 1-cal_box_gt, 0.1);

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