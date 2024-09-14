path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_images/';

for I = 1:275
    I
    ex = val_ex_indices(I);

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');

    imagesc(im)
    axis off image
    fullscreen
    saveim([num2str(ex), '.png'], saveloc)
    clf
    close all
end
