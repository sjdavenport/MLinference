loadpolypsdata

%%
rng(2, 'twister')
learning_idx = randsample(1798, 298);
non_learning_idx = setdiff(1:1798, learning_idx);

rng(5, 'twister')

cal_sample = randsample(1500, 1000);
val_sample = setdiff(1:1500, cal_sample);
cal_idx = non_learning_idx(cal_sample);
val_idx = non_learning_idx(val_sample);

cal_scores = scores(:,:,cal_idx);
cal_scores_dist = scores_dist(:,:,cal_idx);

%%
predicted_inner_boxes_cal = predicted_inner_boxes(:,:,cal_sample);
predicted_outer_boxes_cal = predicted_outer_boxes(:,:,cal_sample);

%%
max_od_cal = max_od(cal_sample);
% outer_dilation = prctile(max_od_cal(max_od_cal ~= 500), 100 * (1 - 0.1))
outer_dilation = prctile(max_od_cal, 100 * (1 - 0.1))

%%
min_id_cal = min_id(cal_sample);
inner_dilation = prctile(-min_id_cal(min_id_cal ~= 500), 100 * (1 - 0.1))

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_90_distmix/';

for I = 1
    I
    ex = val_ex_indices(I);
    score_im = scores_dist(:,:,ex+1);
    predicted_mask = score_im > 0.5;
    predicted_outer_box = bounding_box(predicted_mask);
    predicted_inner_box = largest_inner_box(predicted_mask);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = dilate_mask(predicted_inner_box, -inner_dilation);
    predicted_inner = imresize(predicted_inner, im_size, 'nearest');

    predicted_outer = dilate_mask(predicted_outer_box, outer_dilation);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    pause
    % saveim([num2str(ex), '.png'], saveloc)
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