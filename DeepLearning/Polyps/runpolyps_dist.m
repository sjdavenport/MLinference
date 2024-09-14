loadpolypsdata

%% dist scores
% scores_dist = zeros(size(scores));

for I = 1112:size(scores, 3)
    I
    score_im = scores(:,:,I);
    mask_im = score_im > 0.5;
    if sum(mask_im(:)) > 0
        scores_dist(:,:,I) = dist2maskbndry( mask_im );
    end
end

%% Set the images where there was no tumor found to zero!
for I = 1:1798
    score_im = scores_dist(:,:,I);
    if sum(score_im(:)) == 0
        scores_dist(:,:,I) = -sqrt(2*(356/2).^2);
    end
end

%%
surf(scores(:,:,1458))

%%
save('scores_dist', 'scores_dist')

%%
subplot(1,2,1)
surf(score_im)
subplot(1,2,2)
surf(scores_dist)
fullscreen

%%
surf(scores_dist.*score_im)

%%
load('scores_dist')

% Positive tfce scores
cal_scores_dist = scores_dist(:,:,idx(1:id2stop));
anal_scores_dist = scores_dist(:,:,idx(id2stop:end));
val_scores_dist = scores_dist(:,:,~idx);

%% Examine the scores
subplot(1,2,1)
surf(scores(:,:,1))
subplot(1,2,2)
surf(scores_dist(:,:,1))
fullscreen

%%
% Generate inner sets
[threshold_dist_inner, max_vals_dist_inner] = CI_fwer(cal_scores_dist, cal_gt_masks, 0.1);
[threshold, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_dist_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.1);

% Joint inference
% joint_tfce_max_vals = max(max_vals_tfce_inner,max_vals_tfce_outer);
% alpha = 0.1;
% threshold_joint = prctile(joint_tfce_max_vals, 100 * (1 - alpha))

%%
% saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_joint';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 1:275
    I
    ex = val_ex_indices(I);
    score_im = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold;
    % predicted_inner = score_im > threshold_dist_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - ( (1-score_im) > threshold_dist_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    subplot(1,2,1)
    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    % cr_plot(predicted_inner, relevant_outer_set, imresize(true_mask(:,:,1), im_size, 'nearest'));
    axis off image
    % saveim([num2str(ex), '.png'], [saveloc,'_', num2str(100*(1-alpha)), '_tfce/'])
    % size(predicted_inner)
    subplot(1,2,2)
    imagesc(im)
    axis off image
    % saveim([num2str(ex), '.png'], savelocims)
    fullscreen
    pause
    clf
end

%%
% Generate inner sets
[threshold_tfce_inner, max_vals_tfce_inner] = CI_fwer(cal_scores_tfce_positive, cal_gt_masks, 0.02);

% Generate outer sets
[threshold_tfce_outer, max_vals_tfce_outer] = CI_fwer(cal_scores_tfce_negative, 1-cal_gt_masks, 0.08);

%% Joint inference
joint_tfce_max_vals = max(max_vals_tfce_inner,max_vals_tfce_outer);
alpha = 0.1;
threshold_joint = prctile(joint_tfce_max_vals, 100 * (1 - alpha))

%%
saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_joint';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 11:40
    I
    ex = val_ex_indices(I);
    tfce_positive_score_im = scores_tfce_positive(:,:,ex+1);
    tfce_negative_score_im = scores_tfce_negative(:,:,ex+1);
    % vec_scores =

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');
    % im_size = size(im);
    % im_size = im_size(1:2);

    % predicted_inner = scores(:,:,ex+1) > threshold;
    predicted_inner = tfce_positive_score_im > threshold_tfce_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - (tfce_negative_score_im > threshold_tfce_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    % imagesc(im); hold on

    % viewdata(im2double(im), ones(im_size), {predicted_inner, predicted_outer, im2double(true_mask(:,:,1))}, {'red', 'blue', 'yellow'});

    [~, ~, ~, components] = numOfConComps(predicted_outer, 0.5);
    relevant_outer_set = zeros(im_size);
    for I = 1:length(components)
        component_mask = cluster_im( im_size, components(I), 1 );
        if any(component_mask(:).*predicted_inner(:))
            relevant_outer_set = relevant_outer_set + component_mask;
        end
    end

    % subplot(1,2,1)
    % cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    cr_plot(predicted_inner, relevant_outer_set, imresize(true_mask(:,:,1), im_size, 'nearest'));
    axis off image
    % saveim([num2str(ex), '.png'], [saveloc,'_', num2str(100*(1-alpha)), '_tfce/'])
    % size(predicted_inner)
    % subplot(1,2,2)
    % imagesc(im)
    % axis off image
    % saveim([num2str(ex), '.png'], savelocims)
    % fullscreen
    pause
    clf
end