saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores_full.mat']);
scores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images.mat']);
images = permute(is.images, [2,3,4,1]);

%%
max_score_vec = zeros(1, 2594);
for I = 1:2594
    score_im = scores(:,:,I);
    max_score_vec(I) = max(score_im(:));
end

%%
dtscores = zeros([128,128,2594]);
thresh = 0.5;
for I = 1:2594
    I
    score_im = scores(:,:,I);
    if sum(score_im(:) > thresh) > 0
        dtscores(:,:,I) = dtmask( scores(:,:,I) > thresh );
    end
end

minusmean = mean(dtscores(dtscores < 0));
for I = 1:2594
    if sum(score_im(:) > thresh) == 0
        dtscores(:,:,I) = minusmean*ones(128,128);
    end
end

%%
maxdt = max(dtscores(:));
mindt = min(dtscores(:));

%%
dtscores_scaled = zeros(size(dtscores));
for I = 1:2594
    I
    dtim = dtscores(:,:,I);
    dtim(dtim < 0) =  dtim(dtim < 0)/abs(mindt);
    dtim(dtim > 0) =  dtim(dtim > 0)/abs(maxdt);
    dtscores_scaled(:,:,I) = dtim;
end
dtscores_scaled = dtscores_scaled/2 + 0.5;

%% Set the scores outside the 0.5 score area to the minimum of the dtscores and the original scores
newscores = zeros(size(scores));
for I = 1:2594
    I
    dtim = dtscores_scaled(:,:,I);
    score_im = scores(:,:,I);
    score_im(dtim < 0.42) = 0;
    newscores(:,:,I) = score_im;
end

%% CI on the original scores
% Generate inner sets
threshold_inner = CI_fwer(scores(:,:,1:2000), masks(:,:,1:2000), 0.1)

% Generate outer sets
threshold_outer = CI_fwer(1 - scores(:,:,1:2000), 1-masks(:,:,1:2000), 0.1)

%% CI on the dtscores
% Generate inner sets
[threshold_inner_dt, max_vals_inner] = CI_fwer(dtscores(:,:,1:2000), masks(:,:,1:2000), 0.1);

% Generate outer sets
[threshold_outer_dt, max_vals_outer] = CI_fwer(-dtscores(:,:,1:2000), 1-masks(:,:,1:2000), 0.1);

%% CI on the dtscores_scaled
% Generate inner sets
threshold_inner_dtscaled = CI_fwer(dtscores_scaled(:,:,1:2000), masks(:,:,1:2000), 0.1)

% Generate outer sets
threshold_outer_dtscaled = CI_fwer(1-dtscores_scaled(:,:,1:2000), 1-masks(:,:,1:2000), 0.1)

%%
for id = 1:1
    orig_im = images(:,:,:,id);
    score_im = dtscores_scaled(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_dtscaled;
    predicted_outer = 1 - ((1-score_im) > threshold_outer_dtscaled);

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

%% CI on the new scores
% Generate inner sets
threshold_inner_new = CI_fwer(newscores(:,:,1:2000), masks(:,:,1:2000), 0.1)

% Generate outer sets
threshold_outer_new = CI_fwer(1-newscores(:,:,1:2000), 1-masks(:,:,1:2000), 0.1)

%%
for id = 2001:2100
    orig_im = images(:,:,:,id);
    score_im = newscores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_new;
    predicted_outer = 1 - ((1-score_im) > threshold_outer_new);

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

