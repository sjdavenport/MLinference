saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores_all.mat']);
scores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks_all.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images_all.mat']);
images = permute(is.images, [2,3,4,1]);

%%
for I = 1:4
    subplot(1,4,1);
    imagesc(scores(:,:,1));
end
fullscreen

%% Compare the scores
for I = 1500:1600
startid = 4*(I-1);
subplot(1,3,1);
imagesc(scores(:,:,startid + 1));
axis off image
subplot(1,3,2)
imagesc((scores(:,:,startid + 1) + fliplr(scores(:,:,startid + 2)) + flipud(scores(:,:,startid + 3)))/3);
axis off image
title('average')
BigFont(25)
subplot(1,3,3)
imagesc(masks(:,:,startid+1));
axis off image
title('true mask')
BigFont(25)
fullscreen
pause
end

%% Compare the masks
for I = 1600:1700
startid = 4*(I-1);
subplot(1,3,1);
imagesc(scores(:,:,startid + 1) > 0.6);
axis off image
subplot(1,3,2)
imagesc((scores(:,:,startid + 1) + fliplr(scores(:,:,startid + 2)) + flipud(scores(:,:,startid + 3)))/3 > 0.6);
axis off image
title('average')
BigFont(25)
subplot(1,3,3)
imagesc(masks(:,:,startid+1));
axis off image
title('true mask')
BigFont(25)
fullscreen
pause
end

%% CI on new dtscores
dtscores = zeros([128,128,2594]);
thresh = 0.7;
for I = 881:2594
    I
    score_im = scores(:,:,I);
    if sum(score_im(:) > thresh) > 0
        dtscores(:,:,I) = dist2maskbndry( score_im > thresh );
    end
end