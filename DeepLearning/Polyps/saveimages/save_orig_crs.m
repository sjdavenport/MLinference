loadpolypsdata

%% Generate inner/outer sets
[threshold_inner, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.1);
[threshold_outer, max_vals_dist_outer] = CI_fwer(1-cal_scores, 1-cal_gt_masks, 0.1);

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

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/scores_orig/';

cmap = custom_colormap([1,0.5,0.5], [1,1,0]);
xlim([0,352])
ylim([0,352])
view([-17,11])
screenshape([1,1,600,500])

for I = 11:275
    I
    ex = val_ex_indices(I);
    score_im = scores(:,:,ex+1);

    surf(score_im, 'EdgeAlpha', 0.05)
    colormap(cmap)
    hold on
    surf(ones(size(score_im))*threshold_inner, 'FaceColor', [1,0.2,0.2], 'EdgeAlpha', 0.01)
    surf(ones(size(score_im))*(1-threshold_outer), 'FaceColor', [0, 0.4470, 0.7410], 'EdgeAlpha', 0.01)
    view([-17,11])

    fullscreen
    screenshape([1,1,600,500], 'white')
    BigFont(22)
    ax = gca; % Get current axes
    ax.XColor = 'none'; % Turn off x-axis label
    ax.YColor = 'none'; % Turn off y-axis label\
    ax.LineWidth = 2; % Increase line width for better visibility

    % saveim('testjpg')
    print([saveloc, num2str(ex), '.png'],'-dpng','-r0')
    % axis off image
    % axis off image
    % saveim([num2str(ex), '.png'], saveloc)
    pause
    clf
    close all
end

%%
surf(score_im, 'EdgeAlpha', 0.1)
% cmap = parula;
% Define custom color points (yellow to purple)
cmap = custom_colormap([1,0.5,0.5], [1,1,0]);
% n = size(cmap, 1);  % Number of points in colormap
% Create a custom colormap: interpolate between yellow [1, 1, 0] and purple [0.5, 0, 0.5]
% yellow_to_purple = [linspace(1, 0.5, n)', linspace(1, 0, n)', linspace(0, 0.5, n)'];
colormap(cmap)
% colormap(cool)
hold on 
surf(ones(size(score_im))*threshold_inner, 'FaceColor', [1,0.2,0.2], 'EdgeAlpha', 0.01)
surf(ones(size(score_im))*(1-threshold_outer), 'FaceColor', [0, 0.4470, 0.7410], 'EdgeAlpha', 0.01)
xlim([0,352])
ylim([0,352])
view([-17,11])
screenshape([1,1,600,500])
% set(gcf, 'Position', [1,1,750,750]);
% fullscreen

%%
% Define custom RGB values
customMap = [
    1, 0, 0;   % Red
    0, 1, 0;   % Green
    0, 0, 1    % Blue
];

% Apply the custom colormap
colormap(customMap);

% Display a sample plot
surf(peaks);
colorbar; % Show color scale


%% Learning Inner/Outer sets
rng(2, 'twister')
learning_idx = randsample(1798, 298);
learning_idx_ex = learning_idx - 1;
learn_ex_indices = intersect(ex_indices, learning_idx_ex);

learning_scores = scores(:,:,learning_idx);
learning_masks = gt_masks(:,:,learning_idx);

[threshold_inner, max_vals_inner] = CI_fwer(learning_scores, learning_masks, 0.1);
[threshold_outer, max_vals_outer] = CI_fwer(1-learning_scores, 1-learning_masks, 0.1);

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/score_crs_marginal90/';

for I = 1:length(learn_ex_indices)
    I
    ex = learn_ex_indices(I);
    score_im = scores(:,:,ex+1);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    predicted_inner = score_im > threshold_inner;
    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    predicted_outer = 1 - ( (1-score_im) > threshold_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    % cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'), 1)
    cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/score_surf/';

cmap = custom_colormap([1,0.5,0.5], [1,1,0]);
cmap = custom_colormap([0.8,0.4,0.8], [1,1,0]);
xlim([0,352])
ylim([0,352])
view([-17,11])
screenshape([1,1,600,500])

for I = 1:59
% for I = 7
    I
    ex = learn_ex_indices(I);
    score_im = fliplr(scores(:,:,ex+1));

    surf(score_im, 'EdgeAlpha', 0.05)
    colormap(cmap)
    hold on
    surf(ones(size(score_im))*threshold_inner, 'FaceColor', [1,0.2,0.2], 'EdgeAlpha', 0.01)
    surf(ones(size(score_im))*(1-threshold_outer), 'FaceColor', [0, 0.4470, 0.7410], 'EdgeAlpha', 0.01)
    % view([-17,11])
    % view([-104, 7])
    % view([-170, 7])
    view([-190, 7])

    % fullscreen
    screenshape([1,1,799,705], 'white')
    BigFont(35)
    ax = gca; % Get current axes
    ax.XColor = 'none'; % Turn off x-axis label
    ax.YColor = 'none'; % Turn off y-axis label\
    ax.LineWidth = 2; % Increase line width for better visibility
    xlim([1,352])
    ylim([1,352])
    % saveim('testjpg')
    print([saveloc, num2str(ex), '.png'],'-dpng','-r0')
    % axis image
    % axis off image
    % saveim([num2str(ex), '.png'], saveloc)
    % pause
    clf
    close all
end