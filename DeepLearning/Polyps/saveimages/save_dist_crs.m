loadpolypsdata
load('scores_dist.mat')

%% Generate inner/outer sets
[threshold, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.1);

%%
cal_scores_dist = scores_dist(:,:,idx(1:id2stop));
anal_scores_dist = scores_dist(:,:,idx(id2stop:end));
val_scores_dist = scores_dist(:,:,~idx);
[threshold_dist_inner, max_vals_dist_inner] = CI_fwer(cal_scores_dist, cal_gt_masks, 0.1);
[threshold, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_dist_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.1);

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_90_distmix/';

for I = 1:20
    I
    ex = val_ex_indices(I);
    score_im = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    predicted_outer = 1 - ( (1-score_im) > threshold_dist_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    % pause
    saveim([num2str(ex), '.png'], saveloc)
    clf
end

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_90_dist/';

for I = 1:275
    I
    ex = val_ex_indices(I);
    score_im = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    predicted_outer = 1 - ( (1-score_im) > threshold_dist_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
end