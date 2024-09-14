saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores.mat']);
scores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images.mat']);
images = permute(is.images, [2,3,4,1]);

%%