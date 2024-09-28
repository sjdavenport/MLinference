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

for I = 1:10
    I
    ex = val_ex_indices(I);
    score_im = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = scores(:,:,ex+1) > threshold;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ( (1-score_im) > threshold_dist_outer);
    predicted_outer = 1 - ( (-score_im) > threshold_dist_outer);
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

%% Learning dist_scores
rng(2, 'twister')
learning_idx = randsample(1798, 298);
learning_idx_ex = learning_idx - 1;
learn_ex_indices = intersect(ex_indices, learning_idx_ex);

learning_scores_dist = scores_dist(:,:,learning_idx);
learning_masks = gt_masks(:,:,learning_idx);

[threshold_inner_dt, max_vals_inner] = CI_fwer(learning_scores_dist, learning_masks, 0.1);
[threshold_outer_dt, max_vals_outer] = CI_fwer(-learning_scores_dist, 1-learning_masks, 0.1);


%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/dist_crs_marginal90/';

for I = 1:59
    I
    ex = learn_ex_indices(I);
    score_im = scores_dist(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im > threshold_inner_dt;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ( (1-score_im) > threshold_dist_outer);
    predicted_outer = 1 - ( (-score_im) > threshold_outer_dt);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
end

%% Save surf crs
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/dist_surf/';

cmap = custom_colormap([1,0.5,0.5], [1,1,0]);
cmap = custom_colormap([0.8,0.4,0.8], [1,1,0]);
xlim([0,352])
ylim([0,352])
view([-17,11])
screenshape([1,1,600,500])

% for I = 1:length(learn_ex_indices)
for I = 1:59
    I
    ex = learn_ex_indices(I);
    score_im = fliplr(scores_dist(:,:,ex+1));

    surf(score_im, 'EdgeAlpha', 0.05)
    colormap(cmap)
    hold on
    surf(ones(size(score_im))*threshold_inner_dt, 'FaceColor', [1,0.2,0.2], 'EdgeAlpha', 0.01)
    surf(ones(size(score_im))*(-threshold_outer), 'FaceColor', [0, 0.4470, 0.7410], 'EdgeAlpha', 0.01)
    % view([-17,11])
    view([-190, 7])
    xlim([1,352])
    ylim([1,352])
    % fullscreen
    screenshape([1,1,799,705], 'white')
    BigFont(35)
    ax = gca; % Get current axes
    ax.XColor = 'none'; % Turn off x-axis label
    ax.YColor = 'none'; % Turn off y-axis label\
    ax.LineWidth = 2; % Increase line width for better visibility

    % % saveim('testjpg')
    print([saveloc, num2str(ex), '.png'],'-dpng','-r0')
    % axis image
    % axis off image
    % saveim([num2str(ex), '.png'], saveloc)
    % pause
    clf
    close all
end