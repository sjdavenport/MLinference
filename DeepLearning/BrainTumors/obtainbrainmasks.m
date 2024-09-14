im = imgload('/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/imagesTr/BRATS_001.nii.gz');

niftiwrite(squeeze(im(:,:,:,1)), './testmask001.nii.gz')

%%
