saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores.mat']);
scores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images.mat']);
images = permute(is.images, [2,3,4,1]);

%% Orig scores calulate
alpha = 0.1;
lamhat = fzero(@(x) lamhat_threshold(x, scores(:,:,1:1500), masks(:,:,1:1500), alpha), [0, 1]);

%% Orig scores plot
for id = 1700:1750
    orig_im = images(:,:,:,id);
    score_im = scores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    outer_set = score_im > lamhat;

    subplot(1,3,1)
    inner_mistake = orig_mask - outer_set > 0;
    imagesc(zeros([size(orig_mask), 3]))
    hold on
    add_region({outer_set}, {'blue'})
    axis off image
    subplot(1,3,2)
    imagesc(zeros([size(orig_mask), 3]))
    add_region({orig_mask}, {'yellow'})
    % imagesc(score_im > 0.9)
    axis off image
    subplot(1,3,3)
    imagesc(orig_im)
    axis off image
    fullscreen
    pause
end

%% Calcualte dt scores
dtscores = zeros([128,128,2594]);
for I = 1:2594
    I
    dtscores(:,:,I) = dtmask( scores(:,:,I) > 0.5 );
end

%%
alpha = 0.1;
lamhat_dt = fzero(@(x) lamhat_threshold(x, dtscores(:,:,1:1500), masks(:,:,1:1500), alpha), [-10,10]);

%% dt scores plot
for id = 100:150
    orig_im = images(:,:,:,1500+id);
    score_im = dtscores(:,:,1500+id);
    orig_mask = masks(:,:,1500+id)>0;

    outer_set = score_im > lamhat_dt;

    subplot(1,3,1)
    inner_mistake = orig_mask - outer_set > 0;
    imagesc(zeros([size(orig_mask), 3]))
    hold on
    add_region({outer_set}, {'blue'})
    axis off image
    subplot(1,3,2)
    imagesc(zeros([size(orig_mask), 3]))
    add_region({orig_mask}, {'yellow'})
    % imagesc(score_im > 0.9)
    axis off image
    subplot(1,3,3)
    imagesc(orig_im)
    axis off image
    fullscreen
    pause
end

%% Compare scores and dtscores
%% dt scores plot
for id = 100:150
    orig_im = images(:,:,:,1500+id);
    score_im = dtscores(:,:,1500+id);
    orig_mask = masks(:,:,1500+id)>0;

    outer_set = score_im > lamhat_dt;

    subplot(2,2,1)
    imagesc(zeros([size(orig_mask), 3]))
    hold on
    add_region({outer_set}, {'blue'})
    axis off image
    subplot(2,2,2)
    imagesc(zeros([size(orig_mask), 3]))
    add_region({orig_mask}, {'yellow'})
    % imagesc(score_im > 0.9)
    axis off image

    outer_set = score_im > lamhat;

    subplot(2,2,3)
    inner_mistake = orig_mask - outer_set > 0;
    imagesc(zeros([size(orig_mask), 3]))
    hold on
    add_region({outer_set}, {'blue'})
    axis off image
    subplot(2,2,4)
    imagesc(zeros([size(orig_mask), 3]))
    add_region({orig_mask}, {'yellow'})
    axis off image
    fullscreen
    pause
end