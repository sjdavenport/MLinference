%% Calculate bt scores

%%
gt_outer_boxes = zeros(size(gt_masks));
gt_inner_boxes = zeros(size(gt_masks));

for I = 1:1798
    I
    mask = gt_masks(:,:,I);
    gt_inner_boxes(:,:,I) = largest_inner_box(mask);
    gt_outer_boxes(:,:,I) = bounding_box(mask);
end

%%
predicted_outer_boxes = zeros(size(gt_masks));
predicted_inner_boxes = zeros(size(gt_masks));

for I = 1:1798
    I
    predicted_mask = scores(:,:,I) > 0.5;
    if sum(predicted_mask(:)) > 0
        predicted_inner_boxes(:,:,I) = largest_inner_box(predicted_mask);
        predicted_outer_boxes(:,:,I) = bounding_box(predicted_mask);
    else
        predicted_outer_boxes(:,:,I) = ones(352,352);
        % predicted_outer_boxes(:,:,I) = ones(352,352);
    end
end

%% dist scores
scores_dist_bt_outer = zeros(size(scores));
scores_dist_bt_inner = zeros(size(scores));

recordshows = [];
for I = 1:size(scores, 3)
    I
    maskim_outer = predicted_outer_boxes(:,:,I);
    maskim = predicted_inner_boxes(:,:,I);
    if sum(maskim(:)) > 0
        recordshows = [recordshows, I];
        scores_dist_bt_outer(:,:,I) = dtmask( maskim_outer, 'chessboard' );
        scores_dist_bt_inner(:,:,I) = dtmask( maskim, 'chessboard' );
        % scores_dist(:,:,I) = dist2maskbndry( mask_im );
    end
end
recordnoshows = setdiff(1:1798, recordshows);

%%
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

cal_gt_masks = gt_masks(:,:,cal_idx);

%%
cal_scores_bt_outer = scores_dist_bt_outer(:,:,cal_idx);
cal_scores_bt_inner = scores_dist_bt_inner(:,:,cal_idx);

%%
box_gt = zeros(size(scores));

for I = 1:1798
    I
    box_gt(:,:,I) = bounding_box(gt_masks(:,:,I));
end

cal_box_gt = box_gt(:,:,cal_idx);
val_box_gt = box_gt(:,:,val_idx);

%%
% Generate inner sets
[threshold_inner_bb, max_vals] = CI_fwer(cal_scores_bt_inner, cal_box_gt, 0.1);

% Generate outer sets
[threshold_outer_bb, max_vals_dist_outer] = CI_fwer(-cal_scores_bt_outer, 1-cal_box_gt, 0.1);

%%
% Generate inner sets
[threshold_inner_bb, max_vals] = CI_fwer(cal_scores_bt_outer, cal_box_gt, 0.1);

%%
saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/boundary_box_90/';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for ex = [61,114,144,148,251,7,211,1062,398,269]
    I
    % ex = val_ex_indices(I);
    score_im_inner = scores_dist_bt_inner(:,:,ex+1);
    score_im_outer = scores_dist_bt_outer(:,:,ex+1);

    % true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    true_mask = predicted_outer_boxes(:,:,ex+1);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im_inner > threshold_inner_bb;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (-score_im_outer) > threshold_outer_bb);
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