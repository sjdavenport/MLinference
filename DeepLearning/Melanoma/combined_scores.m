saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores_all.mat']);
allscores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks_all.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images_all.mat']);
images = permute(is.images, [2,3,4,1]);

%%
cs_scores = zeros(size(allscores));
for I = 1:2594
    I
    startid = 4*(I-1);
    cs_scores(:,:,I) = (allscores(:,:,startid + 1) + fliplr(allscores(:,:,startid + 2)) + flipud(allscores(:,:,startid + 3)))/3;
end

%%
for I = 1:2594
    I
    subplot(1,2,1)
    imagesc(allscores(:,:,I));
    subplot(1,2,2)
    imagesc(cs_scores(:,:,I));
    pause
end

%% CI on the combined scores
% Generate inner sets
threshold_inner_cs = CI_fwer(cs_scores(:,:,1:1500), masks(:,:,1:1500), 0.1)

% Generate outer sets
threshold_outer_cs = CI_fwer(1-cs_scores(:,:,1:1500), 1-masks(:,:,1:1500), 0.1)

%%
for id = 1:10
    orig_im = images(:,:,:,id);
    score_im = cs_scores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_cs;
    predicted_outer = 1 - ((1-score_im) > threshold_outer_cs);

    subplot(1,2,1)
    cr_plot(predicted_inner, predicted_outer, orig_mask)
    % imagesc(score_im > 0.9)
    axis off image
    subplot(1,2,2)
    imagesc(orig_im)
    axis off image
    fullscreen
    pause
end
