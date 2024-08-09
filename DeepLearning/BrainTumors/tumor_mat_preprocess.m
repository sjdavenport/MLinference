cd('/Users/sdavenport/Documents/MATLAB/Examples/R2024a/images_deeplearning/Segment3DBrainTumorsUsingDeepLearningExample')
sourceDataLoc = "/Users/sdavenport/Documents/Data/SegmentationData/Exmatseg/";
preprocessDataLoc = "/Users/sdavenport/Documents/Data/SegmentationData/Exmatseg/preprocessed_data/";
preprocessBraTSDataset(preprocessDataLoc,sourceDataLoc);

%%
cd('/Users/sdavenport/Documents/MATLAB/Examples/R2024a/images_deeplearning/Segment3DBrainTumorsUsingDeepLearningExample')
sourceDataLoc = "/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/";
preprocessDataLoc = "/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/";
preprocessBraTSDataset(preprocessDataLoc,sourceDataLoc);

%%
a = load('/Users/sdavenport/Documents/Data/SegmentationData/Exmatseg/preprocessed_data/imagesTest/BraTS001.mat');
surf(a.cropVol(:,:,75,1))