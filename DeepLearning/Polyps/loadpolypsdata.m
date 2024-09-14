datadir = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/';

a = load([datadir, 'polpys_scores.mat' ] );

scores = permute(a.sgmd, [2,3,1]);

b = load([datadir, 'gt_masks.mat' ] );
gt_masks = permute(b.gt_masks, [2,3,1]);

n_images = size(scores, 3);
%%
subplot(1,2,1)
imagesc(scores(:,:,1))
axis off image
subplot(1,2,2)
imagesc(gt_masks(:,:,1))
axis off image

%% Split the softmax scores into calibration and validation sets (save the shuffling)
rng(1, 'twister')
ncal = 798;
idx = zeros(1,n_images);
idx(1:ncal) = 1;
idx = logical(idx(randperm(length(idx))));

id2stop = max(find(cumsum(idx) == 500));
cal_scores = scores(:,:,idx(1:id2stop));
anal_scores = scores(:,:,idx(id2stop:end));
val_scores = scores(:,:,~idx);

anal_size = 298;

cal_gt_masks = gt_masks(:,:,idx(1:id2stop));
anal_gt_masks = gt_masks(:,:,idx(id2stop:end));
val_gt_masks = gt_masks(:,:,~idx);

%%

%%
anal_max_dist = zeros(1, anal_size);
for I = 1:anal_size
    im = anal_scores(:,:,I);
    anal_max_dist(I) = max(im(:));
end

%% Inner anal distribution
[threshold_inner_anal, max_vals_inner_anal] = CI_fwer(anal_scores, anal_gt_masks, 0.2);
[threshold_outer_anal, max_vals_outer_anal] = CI_fwer(1-anal_scores, 1-anal_gt_masks, 0.2);

%% Compare histograms
subplot(1,2,1)
histogram(max_vals_inner_anal)
subplot(1,2,2)
histogram(max_vals_outer_anal)

%%
plot(max_vals_inner_anal,max_vals_outer_anal)

%% Example indicies
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';
ex_files = filesindir(path4ims, 'mask.jpg');
ex_indices = zeros(1, length(ex_files));
for I = 1:length(ex_files)
    endex = strfind(ex_files{I}, '_');
    ex_indices(I) = str2double(ex_files{I}(1:endex-1));
end
ex_indices = sort(ex_indices);

%%
val_indices = 1:1798;
val_indices = val_indices(~idx) + 1;
val_ex_indices = intersect(ex_indices, val_indices);

