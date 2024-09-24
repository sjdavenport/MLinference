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
badones = find(max_score_vec > 0.9);
for id = badones
subplot(1,3,1)
imagesc(images(:,:,:,id))
axis off image
subplot(1,3,2)
imagesc(scores(:,:,id))
BigFont(25)
title(max_score_vec(id))
axis off image
subplot(1,3,3)
imagesc(masks(:,:,id))
axis off image
fullscreen
pause
end
%%
id = 1900;
subplot(1,2,1)
imagesc(images(:,:,:,id))
axis off image
subplot(1,2,2)
surf(scores(:,:,id))
fullscreen

%%
dtscores = zeros([128,128,2594]);
for I = 1:2594
    I
    dtscores(:,:,I) = dtmask( scores(:,:,I) > 0.5 );
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

%% Normalize
dtscores(dtscores > 0) = dtscores(dtscores > 0)/max(dtscores(:))/2;
dtscores(dtscores < 0) = dtscores(dtscores < 0)/abs(min(dtscores(:)))/2;

%%
combined_scores = dtscores + scores - 0.5;

%%
dtscores = zeros([128,128,2594]);
for I = 1:2594
    I
    score_im = scores(:,:,I);
    if sum(score_im(:) > 0.5) > 0
        dtscores(:,:,I) = 0.5*dtmask( scores(:,:,I) > 0.5 );
    end
    dtscores(:,:,I) = 0.9*dtmask( scores(:,:,I) > 0.9 ) + 0.7*dtmask( scores(:,:,I) > 0.7 ) + 0.5*dtmask( scores(:,:,I) > 0.5 );
end


%%
imagesc(dtscores(:,:,1700))

%%
dtscores = zeros([128,128,2594]);
thresh = 0.7;
for I = 881:2594
    I
    score_im = scores(:,:,I);
    if sum(score_im(:) > thresh) > 0
        dtscores(:,:,I) = dist2maskbndry( score_im > thresh );
    end
end

%% 
save('./dtscores7.mat', 'dtscores')

%%
viewdata( scores(:,:,1), ones(128,128), {masks(:,:,1)}, 'red', 1, [], 1)

%%
id = 2
subplot(1,2,1)
surf(scores(:,:,id))
% zlim([0,1])
% axis off image
subplot(1,2,2)
distmask = dtmask( scores(:,:,id) > 0.9 );
surf(distmask)
fullscreen
% axis off image

%% CI on the original scores
% Generate inner sets
threshold_inner = CI_fwer(scores(:,:,1:2000), masks(:,:,1:2000), 0.25)

% Generate outer sets
threshold_outer = CI_fwer(1 - scores(:,:,1:2000), 1-masks(:,:,1:2000), 0.25)

%%
for id = 2001:2100
    orig_im = images(:,:,:,id);
    score_im = scores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner;
    predicted_outer = 1 - ((1-score_im) > threshold_outer);

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

%%
for I = 1700:1800
    orig_im = images(:,:,:,I);
    imagesc(orig_im)
    fullscreen
    axis off image
    pause
end

%% CI on the dtscores
% Generate inner sets
[threshold_inner_dt, max_vals_inner] = CI_fwer(dtscores(:,:,1:2000), masks(:,:,1:2000), 0.25);

% Generate outer sets
[threshold_outer_dt, max_vals_outer] = CI_fwer(-dtscores(:,:,1:2000), 1-masks(:,:,1:2000), 0.25);

%%
for id = 2000:2100
    orig_im = images(:,:,:,id);
    score_im = dtscores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_dt;
    predicted_outer = 1 - (-score_im > threshold_outer_dt);

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

%% CI on the combined scores
% Generate inner sets
[threshold_inner_cs, max_vals_inner] = CI_fwer(combined_scores(:,:,1:1500), masks(:,:,1:1500), 0.1);

% Generate outer sets
[threshold_outer_cs, max_vals_outer] = CI_fwer(-combined_scores(:,:,1:1500), 1-masks(:,:,1:1500), 0.1);

%%
for id = 1700:1750
    orig_im = images(:,:,:,id);
    score_im = combined_scores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_cs;
    predicted_outer = 1 - (-score_im > threshold_outer_cs);

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

%% Smooth scores
FWHM = 2;
smooth_scores = fast_conv(scores - 0.5, FWHM, 2);
smooth_ones = fast_conv(ones(128,128), FWHM);
smooth_scores = smooth_scores./smooth_ones;

%% CI on the smooth scores
% Generate inner sets
[threshold_inner_smooth, max_vals_inner] = CI_fwer(smooth_scores(:,:,1:2000), masks(:,:,1:2000), 0.25);

% Generate outer sets
[threshold_outer_smooth, max_vals_outer] = CI_fwer(-smooth_scores(:,:,1:2000), 1-masks(:,:,1:2000), 0.25);

%%
for id = 2001:2100
    orig_im = images(:,:,:,id);
    score_im = smooth_scores(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_smooth;
    predicted_outer = 1 - ((-score_im) > threshold_outer_smooth);

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

%% dt on smooth scores
dtscores_smooth = zeros([128,128,2594]);
thresh = 0;
for I = 1:2594
    I
    score_im = smooth_scores(:,:,I);
    if sum(score_im(:) > thresh) > 0
        dtscores_smooth(:,:,I) = dtmask( smooth_scores(:,:,I) > thresh );
    end
end

%%
minusmean = mean(dtscores_smooth(dtscores_smooth < 0));
for I = 1:2594
    I
    if sum(smooth_scores(:) > thresh) == 0
        print('doing')
        dtscores_smooth(:,:,I) = minusmean*ones(128,128);
    end
end

%% CI on the dtscores
% Generate inner sets
[threshold_inner_dt_smooth, max_vals_inner] = CI_fwer(dtscores_smooth(:,:,1:2000), masks(:,:,1:2000), 0.25);

% Generate outer sets
[threshold_outer_dt_smooth, max_vals_outer] = CI_fwer(-dtscores_smooth(:,:,1:2000), 1-masks(:,:,1:2000), 0.25);

%%
for id = 2001:2100
    orig_im = images(:,:,:,id);
    score_im = dtscores_smooth(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_dt_smooth;
    predicted_outer = 1 - (-score_im > threshold_outer_dt_smooth);

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