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
cal_gt_masks = gt_masks(:,:,cal_idx);

%% Generate predicted masks
predicted_outer_boxes = zeros(size(scores));
predicted_inner_boxes = zeros(size(scores));
for I = 1:1798
    I
    score_im = scores(:,:,I);
    predicted_mask = score_im > 0.5;
    predicted_outer_boxes(:,:,I) = bounding_box(predicted_mask);
    if sum(predicted_mask(:)) > 0
        predicted_inner_boxes(:,:,I) = largest_inner_box(predicted_mask);
    end
end

%% Generate box transformed CRs
scores_dist_bt_outer = zeros(size(scores));
scores_dist_bt_inner = zeros(size(scores));

recordshows = [];
for I = 1:size(scores, 3)
    I
    maskim_outer = predicted_outer_boxes(:,:,I);
    maskim_inner = predicted_inner_boxes(:,:,I);
    if sum(maskim_outer(:)) > 0
        recordshows = [recordshows, I];
        scores_dist_bt_outer(:,:,I) = dtmask( maskim_outer, 'chessboard' );
        scores_dist_bt_inner(:,:,I) = dtmask( maskim_inner, 'chessboard' );
    end
end
recordnoshows = setdiff(1:1798, recordshows);

%% Combined scores
scores_dist_bt = zeros(size(scores));
for I = 1:1798
    I
    score_im_outer = scores_dist_bt_outer(:,:,I);
    score_im_inner = scores_dist_bt_inner(:,:,I);
    score_im_outer(score_im_outer > 0) = max(score_im_inner(score_im_outer > 0), 0);
    scores_dist_bt(:,:,I) = score_im_outer;
end

%%
cal_scores_dist_bt = scores_dist_bt(:,:,cal_idx);

%%
surf(scores_dist_bt(:,:,1501))

%%
[threshold_dist_inner, max_vals_dist_inner] = CI_fwer(cal_scores_dist_bt, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_dist_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist_bt, 1-cal_gt_masks, 0.1);

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_90_orig/';

for I = 1:20
    I
    ex = val_ex_indices(I);
    score_im = scores(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im > threshold_inner;
    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    predicted_outer = 1 - ( (1-score_im) > threshold_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'), 1)
    axis off image
    fullscreen
    % saveim([num2str(ex), '.png'], saveloc)
    % clf
    % close all
    pause
end

%% Learning Inner/Outer sets
rng(2, 'twister')
learning_idx = randsample(1798, 298);
learning_idx_ex = learning_idx - 1;
learn_ex_indices = intersect(ex_indices, learning_idx_ex);

learning_scores_dist_bt_outer = scores_dist_bt_outer(:,:,learning_idx);
learning_scores_dist_bt_inner = scores_dist_bt_inner(:,:,learning_idx);

learning_scores_dist_bt = scores_dist_bt(:,:,learning_idx);
learning_masks = gt_masks(:,:,learning_idx);

[threshold_dist_bt_inner, max_vals_dist_inner] = CI_fwer(learning_scores_dist_bt, learning_masks, 0.1);
[threshold_dist_bt_outer, max_vals_dist_outer] = CI_fwer(-learning_scores_dist_bt, 1-learning_masks, 0.1);
%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/dist_bt_crs_marginal90/';

for I = 1:59
    I
    ex = learn_ex_indices(I);
    score_im = scores_dist_bt(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im > threshold_dist_bt_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ( (1-score_im) > threshold_dist_outer);
    predicted_outer = 1 - ( (-score_im) > threshold_dist_bt_outer);
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

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/dist_bt_surf/';

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
    score_im = fliplr(scores_dist_bt(:,:,ex+1));

    surf(score_im, 'EdgeAlpha', 0.05)
    colormap(cmap)
    hold on
    surf(ones(size(score_im))*threshold_dist_bt_inner, 'FaceColor', [1,0.2,0.2], 'EdgeAlpha', 0.01)
    surf(ones(size(score_im))*(-threshold_dist_bt_outer), 'FaceColor', [0, 0.4470, 0.7410], 'EdgeAlpha', 0.01)
    % view([-17,11])
    % view([-104, 7])
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