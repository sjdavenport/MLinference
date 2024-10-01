path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/all_images/';

for I = 1:500
    I
    ex = ex_indices(I);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    imagesc(im)
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end


%% Learning dataset
learning_idx_ex = learning_idx - 1;
learn_ex_indices = intersect(ex_indices, learning_idx_ex);

path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/images/';

for I = 1:length(learn_ex_indices)
    I
    ex = learn_ex_indices(I);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    imagesc(im)
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end

%% Learning dataset scores
learning_idx_ex = learning_idx - 1;
learn_ex_indices = intersect(ex_indices, learning_idx_ex);

path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/scores/';
% cmap = custom_colormap([1,0.5,0.5], [1,1,0]);
cmap = custom_colormap([0.8,0.4,0.8], [1,1,0]);

% for I = 1:length(learn_ex_indices)
for I = 1:59
    I
    ex = learn_ex_indices(I);
    score_im = scores(:,:,ex+1);
    score_im_re = imresize(score_im, im_size, 'nearest');

    imagesc(score_im_re)
    colormap(cmap)
    axis off image
    screenshape([1,1,799,705], 'white')
    saveim([num2str(ex), '.png'], saveloc)
    % clf
    % close all
end

%% Learning dataset masks
learning_idx_ex = learning_idx - 1;
learn_ex_indices = intersect(ex_indices, learning_idx_ex);

path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/truemasks/';
% cmap = custom_colormap([1,0.5,0.5], [1,1,0]);
% cmap = custom_colormap([0.8,0.4,0.8], [1,1,0]);

% for I = 1:length(learn_ex_indices)
for I = 55:59
    I
    ex = learn_ex_indices(I);
    score_im = predicted_outer_boxes(:,:,ex+1);
    score_im_re = imresize(score_im, im_size, 'nearest');

    imagesc(score_im > 0.5)
    % % colormap(cmap)
    axis off image
    screenshape([1,1,799,705], 'white')
    saveim([num2str(ex), '.png'], saveloc)
    % clf
    % close all
end