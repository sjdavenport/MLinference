id = 3;
% Load the image data and ground truth mask
orig_im = imgload([skulldir, skullnames{id},'/sub-', skullnames{id}, '_ses-NFB3_T1w.nii.gz']);
orig_mask = imgload([skulldir, skullnames{id},'/sub-', skullnames{id}, '_ses-NFB3_T1w_brainmask.nii.gz']);
hdbet_mask = imgload([skulldir, skullnames{id},'/sub-', skullnames{id}, '_ses-NFB3_T1w_bet_mask.nii.gz']);

% Load and process scores
a = load([skulldir, skullnames{id},'/post_seg.mat']);
old_shape = load([skulldir, skullnames{id},'/old_shape.mat']).old_shape
scores = squeeze(a.post_seg);
scores = squeeze(scores(2,:,:,:));
scores = scores(1:old_shape(2), 1:old_shape(3), 1:old_shape(4));
scores = permute(scores, [3,2,1]);
scores = imresize3(scores, size(orig_im), 'cubic');

predicted_mask = scores > 0;

%%
maskdiff = orig_mask - predicted_mask;

sum(maskdiff(:) > 0)
sum(maskdiff(:) < 0)

slice = 120;
s_im = size(orig_im);
for slice = 40:120
    % im1 = viewdata(orig_im(:,:,slice), ones(s_im(1:2)), {orig_mask(:,:,slice), hdbet_mask(:,:,slice)}, {'red', 'white'}, 2, [], 0.5);
    im1 = viewdata(orig_im(:,:,slice), ones(s_im(1:2)), {orig_mask(:,:,slice), dilated_mask(:,:,slice)}, {'red', 'white'}, 2, [], 0.5);
    fullscreen
    pause
    clf
end

%%
histogram(scores(maskdiff < 0))

%% Editting the scores
predicted_mask = scores > 0;
dilated_mask = dilate_mask(predicted_mask, 0);
dilatedmaskdiff = dilated_mask-orig_mask;
sum(dilatedmaskdiff(:) > 0)

%%
histogram(scores(dilatedmaskdiff>0))