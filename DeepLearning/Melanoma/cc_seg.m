saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores_all.mat']);
scores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images.mat']);
images = permute(is.images, [2,3,4,1]);

%%
for I = 1501:1600
    startid = 4*(I-1);
    cs_scores_im = (scores(:,:,startid + 1) + fliplr(scores(:,:,startid + 2)) + flipud(scores(:,:,startid + 3)))/3;
    largestcomponent = getlargestcluster(cs_scores_im > 0.5);
    largestcomponentfilled = imfill(largestcomponent, 'holes');
    subplot(2,2,1);
    imagesc(combined_scores > 0.5);
    axis off image
    title('Combined scores')
    subplot(2,2,2);
    imagesc(largestcomponentfilled);
    axis off image
    title('Combined mask')
    BigFont(25)
    subplot(2,2,3)
    imagesc(masks(:,:,startid + 1))
    axis off image
    title('Original Mask')
    BigFont(25)
    subplot(2,2,4)
    imagesc(images(:,:,:,startid + 1));
    axis off image
    title('Original Image')
    BigFont(25)
    fullscreen
    pause
end

%%
cs_scores = zeros(size(masks));
for I = 1:2594
    I
    startid = 4*(I-1);
    cs_scores(:,:,I) = (scores(:,:,startid + 1) + fliplr(scores(:,:,startid + 2)) + flipud(scores(:,:,startid + 3)))/3;
end

%%
dtscores = zeros([128,128,2594]);
thresh = 0.5;
for I = 1:2594
    I
    cs_score_im = cs_scores(:,:,I);
    if sum(cs_score_im(:) > thresh) > 0
        largestcomponent = getlargestcluster(cs_score_im > thresh);
        largestcomponentfilled = imfill(largestcomponent, 'holes');
        dtscores(:,:,I) = dtmask( largestcomponentfilled > thresh );
    end
end

minusmean = mean(dtscores(dtscores < 0));
for I = 1:2594
    dtI = dtscores(:,:,I);
    if sum(dtI) == 0
        dtscores(:,:,I) = minusmean*ones(128,128);
    end
end

%% CI on the dtscores
% Generate inner sets
[threshold_inner_dt, max_vals_inner] = CI_fwer(dtscores(:,:,1:1500), masks(:,:,1:1500), 0.1);

% Generate outer sets
[threshold_outer_dt, max_vals_outer] = CI_fwer(-dtscores(:,:,1:1500), 1-masks(:,:,1:1500), 0.1);

%%
for id = 1706
    orig_im = images(:,:,:,id);
    score_im = dtscores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_dt;
    predicted_outer = 1 - (-score_im > threshold_outer_dt);

    subplot(1,3,1)
    cr_plot(predicted_inner, predicted_outer, orig_mask)
    % imagesc(score_im > 0.9)
    axis off image
    subplot(1,3,2)
    imagesc(score_im > 0.5)
    axis off image
    subplot(1,3,3)
    imagesc(orig_im)
    axis off image
    fullscreen
    pause
end

%%
for I = 1720:1800
    startid = 4*(I-1);
    cs_scores_im = (scores(:,:,startid + 1) + fliplr(scores(:,:,startid + 2)) + flipud(scores(:,:,startid + 3)))/3;
    subplot(1,3,1);
    imagesc(cs_scores_im > 0.5);
    axis off image
    title('Combined mask')
    subplot(1,3,2);
    imagesc(cs_scores_im);
    axis off image
    title('Combined scores')
    BigFont(25)
    subplot(1,3,3)
    imagesc(masks(:,:,I))
    axis off image
    title('Original Mask')
    BigFont(25)
    fullscreen
    pause
end

%%
for I = 1700:1800
    subplot(1,2,1)