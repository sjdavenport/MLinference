id = 195;
[ scores, tumor_mask, orig_im, brain_mask] = load_brats_scores( id );

slice = 60;
subplot(1,3,1)
imagesc(orig_im(:,:,slice));
axis off image
colormap('gray')
subplot(1,3,2)
imagesc(scores(:,:,slice));
colormap('winter')
axis off image
subplot(1,3,3)
imagesc(tumor_mask(:,:,slice))
axis off image
fullscreen

%%
surf(scores(:,:,slice))

%%
slice = 60;
viewdata(orig_im(:,:,slice,3), brain_mask(:,:,slice), {tumor_mask(:,:,slice)}, 'red', 4, [], 0.5)
axis image
fullscreen
colormap('gray')

%% Compare the brain masks
for I = 1:4
bm = brain_mask(:,:,60,I);
sum(bm(:))
end

combine_masks = (sum(brain_mask,4) == 4);
cm = combine_masks(:,:,60);
sum(cm(:))

%%
saveloc = '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/scores/';
id = 200;
idstrtemp = num2str(id);
idstr = '000';
if id < 10
    idstr(end) = idstrtemp;
elseif id < 100
    idstr(end-1:end) = idstrtemp;
else
    idstr = idstrtemp;
end
a = load([saveloc, 'scores_', num2str(id), '.mat']);

%%
X = extractdata(a.X);
scores = X(:,:,:,2);
slice = 80;
surf(scores(:,:,slice), 'EdgeAlpha',0.1)
axis off image
fullscreen
view([0,40])

%% Load image and tumor labels
% Load image
datadir =  '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/images/';
b = load([datadir, 'BRaTS', idstr]);
orig_im = b.cropVol;

% Load labels
labeldir =  '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/labels/';
b = load([labeldir, 'BRaTS', idstr]);
tumor_mask = b.cropLabel;

%% Shrink the output to the original input size
orig_im_size = size(orig_im);
extra_padding = [orig_im_size(1:3) - size(scores), 0];
shrunk_im = pad_im(orig_im, -extra_padding/2);
shrunk_tumor_mask = pad_im(tumor_mask, -extra_padding/2);

%%
slice = 60;
subplot(1,3,1)
imagesc(shrunk_im(:,:,slice,4));
axis off image
subplot(1,3,2)
mask = ~(shrunk_im == 0);
imagesc(scores(:,:,slice).*mask(:,:,slice));
axis off image
subplot(1,3,3)
imagesc(shrunk_tumor_mask(:,:,slice))
axis off image
fullscreen

%%
slice = 70;
subplot(1,3,1)
surf(shrunk_im(:,:,slice,1));
subplot(1,3,2)
surf(scores(:,:,slice));
subplot(1,3,3)
surf(scores(:,:,slice));
fullscreen
