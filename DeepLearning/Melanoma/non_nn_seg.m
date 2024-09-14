saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
is = load([saveloc, 'train_images.mat']);
images = permute(is.images, [2,3,4,1]);
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));
ts = load([saveloc, 'train_scores.mat']);
scores = permute(ts.all_scores, [2,3,1]);

%%
for I = 1720:1800
subplot(2,3,1)
imagesc(images(:,:,1,I) < 0.5)
subplot(2,3,2)
imagesc(images(:,:,2,I) < 0.5)
subplot(2,3,3)
imagesc(images(:,:,3,I) < 0.5)
subplot(2,3,4)
imagesc(images(:,:,:,I))
subplot(2,3,5)
imagesc(scores(:,:,I)> 0.5)
subplot(2,3,6)
imagesc(masks(:,:,I))
fullscreen
pause
end