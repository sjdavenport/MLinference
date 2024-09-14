saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/Scores/';
ts = load([saveloc, 'train_scores_full.mat']);
scores = permute(ts.all_scores, [2,3,1]);
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));
is = load([saveloc, 'train_images.mat']);
images = permute(is.images, [2,3,4,1]);

%%
scores_smoothoutsidemask = zeros([128,128,2594]);
centred_scores = scores - 0.5;

for I = 1:2594
    score_im = scores(:,:,I);
    mask = masks(:,:,I);
    scores_smoothoutsidemask(:,:,I) = 
end