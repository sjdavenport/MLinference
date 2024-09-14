datadir = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/rcds_data/TestDataset/';
folders = filesindir(datadir);

scores = zeros(352,352,798);
gt_masks = zeros(352,352,798);

J = 0;
for I = 1:length(folders)
    folder = folders{I};
    logit_dir = [datadir, folder, '/logits/'];
    mask_dir = [datadir, folder, '/masks/'];
    logit_files = filesindir(logit_dir);
    for K = 1:length(logit_files)
        J = J + 1;
        a = load([logit_dir, logit_files{K}]);
        scores(:,:,J) = a.logits;

        dotloc = strfind(logit_files{K}, '_');
        name = logit_files{K}(1:(dotloc-1));
        mask = imread([mask_dir, name, '.png']);
        mask = imresize(mask, [352,352], 'nearest');
        gt_masks(:,:,J) = mask;
    end
end

%% View masks and scores
I = 10;
subplot(1,2,1)
imagesc(scores(:,:,I) > 0)
axis off image
% title('Inner set')
subplot(1,2,2)
imagesc(gt_masks(:,:,I))
% title('Ground truth')
axis off image
fullscreen

%% Split the softmax scores into calibration and validation sets (save the shuffling)
rng(1)
ncal = 300; n_images = 798;
idx = zeros(1,n_images);
idx(1:ncal) = 1;
idx = logical(idx(randperm(length(idx))));

cal_scores = scores(:,:,idx);
val_scores = scores(:,:,~idx);

cal_gt_masks = gt_masks(:,:,idx);
val_gt_masks = gt_masks(:,:,~idx);

%% Smooth
FWHM = 10;
smooth_scores = fast_conv(scores, FWHM, 2)./kernel_weighting;
kernel_weighting = fast_conv(ones(352,352), FWHM, 2);
cal_smooth_scores = smooth_scores(:,:,idx);
val_smooth_scores = smooth_scores(:,:,~idx);

%%
[threshold_inner, max_vals_inner] = CI_fwer(cal_scores, cal_gt_masks, 0.2);
[threshold_outer, max_vals_outer] = CI_fwer(-cal_scores, 1-cal_gt_masks, 0.2);

%%
for I = 1:100
    subplot(1,3,1)
    imagesc(val_scores(:,:,I) > threshold_inner)
    axis off image
    title('Inner set')
    subplot(1,3,2)
    imagesc(1 - (-val_scores(:,:,I) > threshold_outer))
    axis off image
    title('Outer set')
    subplot(1,3,3)
    imagesc(val_gt_masks(:,:,I))
    title('Ground truth')
    axis off image
    fullscreen
    pause
end

%%
[threshold_inner, max_vals_inner] = CI_fwer(cal_positive_smooth_scores, cal_gt_masks, 0.2);
[threshold_outer, max_vals_outer] = CI_fwer(cal_negative_smooth_scores, 1-cal_gt_masks, 0.2);

%%
for I = 1:100
    subplot(1,3,1)
    imagesc(cal_positive_smooth_scores(:,:,I) > threshold_inner)
    axis off image
    title('Inner set')
    subplot(1,3,2)
    imagesc(1 - (cal_negative_smooth_scores(:,:,I) > threshold_outer))
    axis off image
    title('Outer set')
    subplot(1,3,3)
    imagesc(cal_gt_masks(:,:,I))
    title('Ground truth')
    axis off image
    fullscreen
    pause
end

%% TFCE
positive_tfce_scores = zeros(352,352,798);
negative_tfce_scores = zeros(352,352,798);
for I = 1:size(scores,3)
    I
    positive_tfce_scores(:,:,I) = tfce(scores(:,:,I));
    negative_tfce_scores(:,:,I) = tfce(-scores(:,:,I));
end
cal_positive_smooth_scores = positive_tfce_scores(:,:,idx);
val_positive_smooth_scores = positive_tfce_scores(:,:,~idx);

cal_negative_smooth_scores = negative_tfce_scores(:,:,idx);
val_negative_smooth_scores = negative_tfce_scores(:,:,~idx);

%%
for I = 1:100
subplot(1,2,1)
imagesc(scores(:,:,I))
subplot(1,2,2)
imagesc(negative_tfce_scores(:,:,I))
fullscreen
pause
end