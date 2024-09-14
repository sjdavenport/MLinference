train_2019_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2019/ISIC_2019_Training_Input/';

train_2019_images = filesindir(train_2019_dir, 'jpg');

WSIC_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/WSIC_labels/';
WSIC_gt = filesindir(WSIC_dir, 'ISIC' );

%%
for I = 20000:20100
mask_name = WSIC_gt{I};
im_name = strrep(mask_name, 'png', 'jpg');

image = imread([train_2019_dir, im_name]);

mask = imread([WSIC_dir, mask_name]);
outer_boundary = (mask == 255);
outer_mask = mask > 2;
inner_mask = (mask == 1) ;

imagesc(image)
hold on
add_region(outer_mask - inner_mask, 'red', 0.5)
fullscreen
pause
end

%% Examine the ones in the calibration set
train_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Training_Data/';
val_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Validation_Data/';
test_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Test_v2_Data/';

train_2016_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2016/ISBI2016_ISIC_Part1_Training_Data/';
test_2016_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2016/ISBI2016_ISIC_Part1_Test_Data/';

for I = onesleft
mask_name = all_names{I};
im_name = strrep(mask_name, 'png', 'jpg');

try
    image = imread([train_2017_dir, im_name]);
catch
    try 
        image = imread([val_2017_dir, im_name]);
    catch
        try 
            image = imread([test_2017_dir, im_name]);
        catch
            try 
                image = imread([train_2016_dir, im_name]);
            catch
                image = imread([test_2016_dir, im_name]);
            end
        end
    end
end

mask = imread([WSIC_dir, mask_name]);
outer_boundary = (mask == 255);
outer_mask = mask > 2;
inner_mask = (mask == 1) ;

subplot(1,2,1)
imagesc(image)
hold on
add_region(outer_mask - inner_mask, 'red', 0.5)
title(num2str(I)); BigFont(25)
subplot(1,2,2)
imagesc(gt_masks(:,:,I))
title(num2str(imhausdorff(gt_masks(:,:,I), wsic_innermasks(:,:,I))/sqrt(sumsum(inner_mask)))); BigFont(25)
fullscreen
pause
clf
end