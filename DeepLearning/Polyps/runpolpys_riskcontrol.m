loadpolypsdata

%%
alpha = 0.05;
tic
lamhat = fzero(@(x) lamhat_threshold(x, cal_scores, cal_gt_masks, alpha), [0, 1]);
toc

%%
predicted_masks = val_scores >= lamhat;

%%
ex = 298;
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';
true_mask = imresize(gt_masks(:,:,ex+1), im_size, 'nearest');
im = imread([path4ims, num2str(ex),'.jpg']);
im_size = size(im);
im_size = im_size(1:2);

idx(ex)
subplot(1,2,1)
outer_set = scores(:,:,ex+1) > lamhat;
outer_set = imresize(outer_set, im_size, 'nearest');
inner_mistake = true_mask - outer_set > 0;
imagesc(zeros([im_size, 3]))
hold on
add_region({outer_set, true_mask, inner_mistake}, {'blue','yellow', 'red'})
axis off image
% title('Inner set')
subplot(1,2,2)
imagesc(im)
axis off image

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

for I = 1:length(val_ex_indices)
    clf
    ex = val_ex_indices(I);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im_size = size(im);
    im_size = im_size(1:2);

    true_mask = imresize(gt_masks(:,:,ex+1), im_size, 'nearest');

    idx(ex)
    subplot(1,2,1)
    outer_set = scores(:,:,ex+1) > lamhat;
    outer_set = imresize(outer_set, im_size, 'nearest');
    inner_mistake = true_mask - outer_set > 0;
    imagesc(zeros([im_size, 3]))
    hold on
    add_region({outer_set, true_mask, inner_mistake}, {'blue','yellow', 'red'})
    axis off image
    % title('Inner set')
    subplot(1,2,2)
    imagesc(im)
    axis off image
    fullscreen
    pause
end


%%
CI_fnr(predicted_masks, val_gt_masks)

%%
CI_error(lamhat, val_scores, val_gt_masks)

%% Record Risk control thresholds
alpha_vals = 0.01:0.01:0.1;
lamhat = zeros(1,length(alpha_vals));
for I = 1:length(alpha_vals)
    alpha = alpha_vals(I)
    lamhat(I) = fzero(@(x) lamhat_threshold(x, cal_scores, cal_gt_masks, alpha), [0, 1]);
end

%% Calculate risk control
riskcontrol_fwer = zeros(1,length(alpha_vals));
riskcontrol_fndr = zeros(1,length(alpha_vals));

for I = 1:length(alpha_vals)
    alpha = alpha_vals(I)
    riskcontrol_fwer(I) = CI_error(lamhat(I), val_scores, val_gt_masks);
    predicted_masks = (val_scores >= lamhat(I));
    riskcontrol_fndr(I) = CI_fnr(predicted_masks, val_gt_masks);
    riskcontrol_fdr(I) = 1 - riskcontrol_fndr(I);
end

%%
plot(alpha_vals, riskcontrol_fwer)
plot(alpha_vals, riskcontrol_fndr)