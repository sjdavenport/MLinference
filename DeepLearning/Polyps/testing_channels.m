a = load('/Users/sdavenport/Documents/Data/SegmentationData/polyps/channel_output.mat')
surf(a.channel_output); fullscreen

%%
histogram(a.channel_output)

%%
probs = exp(a.channel_output)./(exp(a.channel_output) + exp(-a.channel_output));
histogram(probs)

%%
a = load('/Users/sdavenport/Documents/Data/SegmentationData/polyps/channel_output_2.mat')
surf(a.channel_output); fullscreen

%%
subplot(1,2,1)
histogram(a.channel_output)
subplot(1,2,2)
histogram(scores(:,:,6))

%%
subplot(1,2,1)
surf(a.channel_output)
subplot(1,2,2)
surf(scores(:,:,6))

%%
imagesc(scores(:,:,6))

%%
probs = exp(a.channel_output)./(exp(a.channel_output) + exp(-a.channel_output));

%%
histogram(probs)

%%
a = filesindir('/Users/sdavenport/Documents/Code/Python/Other_Packages/PraNet/data/TrainDataset/image');

%%
folders = filesindir('/Users/sdavenport/Documents/Data/SegmentationData/polyps/rcds_data/TestDataset/')
nimages = 0;
for I = 1:5
    folder = folders{I};
    imagepaths = filesindir(['/Users/sdavenport/Documents/Data/SegmentationData/polyps/rcds_data/TestDataset/', folder, '/images/']);
    nimages = nimages + length(imagepaths);
end
nimages

%%
a = load('/Users/sdavenport/Documents/Data/SegmentationData/polyps/result.mat');
histogram(a.result(:))

%%
a = load('/Users/sdavenport/Documents/Data/SegmentationData/polyps/predictions_np.mat')
surf(a.predictions_np); fullscreen

%%
b = load('/Users/sdavenport/Documents/Data/SegmentationData/polyps/predictions_flipped_np.mat')
surf(flipud(fliplr(b.predictions_flipped_np))); fullscreen

%%
subplot(1,2,1)
histogram(a.predictions_np)
subplot(1,2,2)
histogram(b.predictions_flipped_np)

%%
histogram(a.predictions_np - flipud(fliplr(b.predictions_flipped_np)))
