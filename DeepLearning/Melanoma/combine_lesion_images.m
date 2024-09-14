
train_2018_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1_Training_GroundTruth/';
val_2018_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1_Validation_GroundTruth/';
test_2018_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1_Test_GroundTruth/';

idx_2018_train_gt = filesindir(train_2018_dir, 'ISIC');
idx_2018_val_gt = filesindir(val_2018_dir, 'ISIC');
idx_2018_test_gt = filesindir(test_2018_dir, 'ISIC');

all_2018 = upper([idx_2018_train_gt, idx_2018_val_gt, idx_2018_test_gt]);

train_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Training_Part1_GroundTruth/';
val_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Validation_Part1_GroundTruth/';
test_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Test_v2_Part1_GroundTruth/';

idx_2017_train_gt = filesindir(train_2017_dir, 'ISIC');
idx_2017_val_gt = filesindir(val_2017_dir, 'ISIC');
idx_2017_test_gt = filesindir(test_2017_dir, 'ISIC');

all_2017 = upper([idx_2017_train_gt, idx_2017_val_gt, idx_2017_test_gt]);

train_2016_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2016/ISBI2016_ISIC_Part1_Training_GroundTruth/';
test_2016_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2016/ISBI2016_ISIC_Part1_Test_GroundTruth/';

idx_2016_train_gt = filesindir(train_2016_dir, 'ISIC');
idx_2016_test_gt = filesindir(test_2016_dir, 'ISIC');

all_2016 = upper([idx_2016_train_gt, idx_2016_test_gt]);

all_files = unique([all_2016, all_2017, all_2018]);

%%
WSIC_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/WSIC_labels/';
WSIC_gt = upper(filesindir(WSIC_dir, 'ISIC'));

%%
all_files_minusseg = strrep(all_files, '_SEGMENTATION', '');
setdiff(all_files_minusseg, WSIC_gt)

%%
all_proc = strrep(upper(all_files), '_SEGMENTATION', '');
setdiff(all_proc, setdiff(all_proc, WSIC_gt))

%%
train_2018_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1-2_Training_Input/';
val_2018_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1-2_Validation_Input/';
test_2018_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2018/ISIC2018_Task1-2_Test_Input/';

idx_2018_train = filesindir(train_2018_dir, 'ISIC');
idx_2018_val = filesindir(val_2018_dir, 'ISIC');
idx_2018_test = filesindir(test_2018_dir, 'ISIC');

train_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Training_Data/';
val_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Validation_Part1_GroundTruth/';
test_2017_dir = '/Users/sdavenport/Documents/Data/SegmentationData/Melanoma/2017/ISIC-2017_Test_v2_Part1_GroundTruth/';

idx_2017_train = filesindir(train_2017_dir, 'ISIC');
idx_2017_val = filesindir(val_2017_dir, 'ISIC');
idx_2017_test = filesindir(test_2017_dir, 'ISIC');

