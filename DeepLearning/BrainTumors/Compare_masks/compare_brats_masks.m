orig_im = imgload('testmask001.nii.gz');
masked_im = imgload('testmask001_bet.nii.gz');
mask = imgload('testmask001_bet_mask.nii.gz');

%%
subplot(1,2,1)
imagesc(orig_im(:,:,100))
subplot(1,2,2)
imagesc(masked_im(:,:,100))

%%
orig_im = imgload('sub-01_T1w.nii.gz');
masked_im = imgload('sub-01_T1w_bet.nii.gz');
mask = imgload('sub-01_T1w_bet_mask.nii.gz');

%%
subplot(1,2,1)
imagesc(orig_im(:,:,100))
subplot(1,2,2)
imagesc(masked_im(:,:,100))