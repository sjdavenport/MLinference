anal_scores = scores(:,:,[zeros(1,id2stop-1) > 0,idx(id2stop:end)]);
anal_scores_dist = scores_dist(:,:,[zeros(1,id2stop-1) > 0,idx(id2stop:end)]);

rng(2, 'twister')
calvals = randperm(200);
noncalvals = setdiff(1:298, calvals);

cal_anal_scores = anal_scores(:,:,calvals);
val_anal_scores = anal_scores(:,:,noncalvals);
cal_anal_scores_dist = anal_scores_dist(:,:,calvals);
val_anal_scores_dist = anal_scores_dist(:,:,noncalvals);

cal_anal_gt_masks = anal_gt_masks(:,:,calvals);
val_anal_gt_masks = anal_gt_masks(:,:,noncalvals);

%%
threshold_dist_inner = CI_fwer(cal_anal_scores_dist, cal_anal_gt_masks, 0.1)
[threshold_dist_outer, allvals] = CI_fwer(-cal_anal_scores_dist, 1-cal_anal_gt_masks, 0.1)

%%
threshold_dist_inner = CI_fwer(cal_scores_dist, cal_gt_masks, 0.1)
[threshold_dist_outer, allvals] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, 0.1)

%%
threshold_dist_inner = CI_fwer(scores_dist(:,:,1000:1100), gt_masks(:,:,1000:1100), 0.1)
threshold_dist_outer = CI_fwer(-scores_dist(:,:,1000:1100), 1-gt_masks(:,:,1000:1100), 0.1)


%%
recordnoshows = []
for I = 1:size(cal_anal_scores,3)
    I
    score_im = cal_anal_scores(:,:,I);
    if sum(score_im(:) > 0.5) == 0
        recordnoshows = [recordnoshows,I];
    end
end
recordshows = setdiff(1:size(cal_anal_scores,3), recordnoshows);

%%
threshold_dist_inner = CI_fwer(cal_anal_scores_dist(:,:,recordshows), cal_anal_gt_masks(:,:,recordshows), 0.1)
threshold_dist_outer = CI_fwer(-cal_anal_scores_dist(:,:,recordshows), 1-cal_anal_gt_masks(:,:,recordshows), 0.1)

%%
[threshold_dist_inner, allvals_inner] = CI_fwer(anal_scores_dist, anal_gt_masks, 0.1)
[threshold_dist_outer, allvals_outer] = CI_fwer(-anal_scores_dist, 1-anal_gt_masks, 0.1)

%%
recordnoshows_orig = []
for I = 1:size(scores,3)
    I
    score_im = scores(:,:,I);
    if sum(score_im(:) > 0.5) == 0
        recordnoshows_orig = [recordnoshows_orig,I];
    end
end

%%
for I = 1:length(recordnoshows_orig)

end

%%
indices = randsample(1798,298);
threshold_dist_inner = CI_fwer(scores_dist(:,:,indices), gt_masks(:,:,indices), 0.1)
threshold_dist_outer = CI_fwer(-scores_dist(:,:,indices), 1-gt_masks(:,:,indices), 0.1)

%%
for I = 1:298
    subplot(1,3,1)
    imagesc(anal_scores(:,:,I) > 0.5)
    title(['Inner: ', num2str(allvals_inner(I))])
    subplot(1,3,2)
    imagesc(anal_scores_dist(:,:,I))
    title(['Outer: ', num2str(allvals(I))])
    BigFont(25)
    subplot(1,3,3)
    imagesc(anal_gt_masks(:,:,I))
    fullscreen
    pause
end

%%
val_anal_indices = anal_indices(calvals)-1;
val_anal_ex_indices = intersect(ex_indices, val_anal_indices);

%%
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = ['/Users/sdave' ...
    'nport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_90_distmix/'];

for I = 1:10
    I
    ex = val_anal_ex_indices(I);
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
    pause
    % saveim([num2str(ex), '.png'], saveloc)
    clf
end

