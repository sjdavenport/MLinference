imdir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1-2_Training_Input/';
maskdir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1_Training_GroundTruth/';

imfiles = filesindir(imdir, '.jpg');
maskfiles = filesindir(maskdir, '.png');

im = imread([imdir, imfiles{1}]);
imagesc(im)

dark_brown = [63,54,59];
brown = [98, 65, 46];
light_brown = [200, 155, 130];
white = [255,255,255];
redish = [180, 122, 108];
%%
im = imread([imdir, imfiles{1}]);

colorim = double(im); 
colorim(:,:,1) = colorim(:,:,1) - white(1);
colorim(:,:,2) = colorim(:,:,1) - white(2);
colorim(:,:,3) = colorim(:,:,1) - white(3);

colorim = sqrt(sum(colorim.^2, 3));

surf(colorim, 'EdgeAlpha', 0.25)
fullscreen

%%
for I = 18:18
    im = imread([imdir, imfiles{I}]);
    colorim = double(im);
    colorim(:,:,1) = colorim(:,:,1) - redish(1);
    colorim(:,:,2) = colorim(:,:,1) - redish(2);
    colorim(:,:,3) = colorim(:,:,1) - redish(3);

    colorim = sqrt(sum(colorim.^2, 3));

    subplot(1,2,1)
    imagesc(im)
    axis off image
    subplot(1,2,2)
    imagesc(colorim > 500)
    axis off image
    fullscreen
    pause
end

%% Smooth the image
FWHM = 20;
for I = 18:18
    im = imread([imdir, imfiles{I}]);
    smooth_ones = fast_conv(ones(size(im)), FWHM, 2);
    colorim = fast_conv(im, FWHM, 2)./smooth_ones;
    colorim(:,:,1) = colorim(:,:,1) - redish(1);
    colorim(:,:,2) = colorim(:,:,1) - redish(2);
    colorim(:,:,3) = colorim(:,:,1) - redish(3);

    colorim = sqrt(sum(colorim.^2, 3));
    % smooth_im(:,:,1) = fast_conv(im(:,:,1), FWHM, 2)./smooth_ones;
    % smooth_im(:,:,2) = fast_conv(im(:,:,2), FWHM, 2)./smooth_ones;
    % smooth_im(:,:,3) = fast_conv(im(:,:,3), FWHM, 2)./smooth_ones;

    subplot(1,2,1)
    imagesc(im)
    axis off image
    subplot(1,2,2)
    imagesc(colorim)
    axis off image
    fullscreen
    pause
end

%%
ms = load([saveloc, 'train_masks.mat']);
masks = double(permute(ms.masks, [2,3,1]));

%%
for I = 1703:1800
    subplot(1,2,1)
    im = imread([imdir, imfiles{I}]);
    imagesc(im)
    fullscreen
    pause
    subplot(1,2,2)
    maskim = imread([maskdir, maskfiles{I}]);
    imagesc(maskim)
    fullscreen
    pause
end

%%
I = 1700
surf(scores(:,:,1703))
fullscreen
