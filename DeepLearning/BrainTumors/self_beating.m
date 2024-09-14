id
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );

slice = 50;

%%
surf(orig_im(:,:,slice))

