saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores_all.mat']);
scores_128 = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks_all.mat']);
masks_128 = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images_all.mat']);
images_128 = permute(is.images, [2,3,4,1]);

%%
ts = load([saveloc, 'train_scores_all_224.mat']);
scores_224 = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks_all_224.mat']);
masks_224 = double(permute(ms.masks, [2,3,1]));

%% Single run
for I = 2000:2200
startid = 4*(I-1);
subplot(1,3,1);
imagesc(scores_128(:,:,startid + 1));
axis off image
title('128')
BigFont(25)
subplot(1,3,2)
imagesc(scores_224(:,:,startid + 1));
axis off image
title('224')
subplot(1,3,3)
imagesc(masks_224(:,:,startid+1));
axis off image
title('true mask')
fullscreen
pause
end

%% Single run averaging across augmentations
for I = 2000:2200
startid = 4*(I-1);
subplot(1,3,1);
imagesc((scores_128(:,:,startid + 1) + fliplr(scores_128(:,:,startid + 2)) + flipud(scores_128(:,:,startid + 3)))/3);
axis off image
title('128')
BigFont(25)
subplot(1,3,2)
imagesc((scores_224(:,:,startid + 1) + fliplr(scores_224(:,:,startid + 2)) + flipud(scores_224(:,:,startid + 3)))/3);
axis off image
title('224')
subplot(1,3,3)
imagesc(masks_224(:,:,startid+1));
axis off image
title('true mask')
fullscreen
pause
end

%% Single run averaging across augmentations
for I = 1500:2000
startid = 4*(I-1);
subplot(1,3,1);
imagesc((scores_128(:,:,startid + 1) + fliplr(scores_128(:,:,startid + 2)) + flipud(scores_128(:,:,startid + 3)))/3 > 0.5);
axis off image
title('128')
BigFont(25)
subplot(1,3,2)
imagesc((scores_224(:,:,startid + 1) + fliplr(scores_224(:,:,startid + 2)) + flipud(scores_224(:,:,startid + 3)))/3 > 0.5);
axis off image
title('224')
subplot(1,3,3)
imagesc(masks_224(:,:,startid+1));
axis off image
title('true mask')
fullscreen
pause
end

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