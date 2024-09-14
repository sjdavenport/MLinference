%% EGGXAMINE
id = 141;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
% scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
scores_outside_tumor_mask = scores;
scores_outside_tumor_mask(tumor_mask) = -Inf;
max(scores_outside_tumor_mask(brain_mask))

% negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
negscores_inside_tumor_mask = -scores;
negscores_inside_tumor_mask((1-tumor_mask) > 0) = -Inf;
max(negscores_inside_tumor_mask(brain_mask))

%%
val = 6;
slice = bestclusterslice( 3, (-scores > val).*tumor_mask );
slice = 32
imagesc((-scores(:,:,slice) > val).*tumor_mask(:,:,slice))

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-scores(:,:,slice) > val).*tumor_mask(:,:,slice), (scores(:,:,slice) > 0).*tumor_mask(:,:,slice)}, {'red', 'white', 'blue'}, 4, [], 1)
axis image
subplot(1,2,2)
viewdata(-scores(:,:,slice), brain_mask(:,:,slice))
% surf(fliplr(-scores(:,:,slice)))
axis image
fullscreen

%%


%%
surf(scores(:,:,slice))
fullscreen
%%
slice = 32;
subplot(1,2,1)
viewdata(orig_im(:,:,slice,3), brain_mask(:,:,slice), {tumor_mask(:,:,slice)}, {'red'}, 4, [], 0.5)
subplot(1,2,2)
viewdata(orig_im(:,:,slice,3), brain_mask(:,:,slice))
fullscreen

%%
surf(orig_im(:,:,slice, 4))

%% EGGXAMINE
id = 141;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
smooth_scores = fast_conv(scores, FWHM, 3).*brain_mask;
smooth_ones = fast_conv(brain_mask, FWHM, 3);
smooth_scores(brain_mask) = smooth_scores(brain_mask)./smooth_ones(brain_mask);
% smooth_scores = max(

% scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
% scores_outside_tumor_mask = max(smooth_scores, scores);
scores_outside_tumor_mask = smooth_scores;
scores_outside_tumor_mask(tumor_mask) = -Inf;
max_pos_smooth_vals(I) = max(scores_outside_tumor_mask(brain_mask));

% negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
% negscores_inside_tumor_mask = max(-smooth_scores, -scores);
negscores_inside_tumor_mask = -smooth_scores;
negscores_inside_tumor_mask((1-tumor_mask) > 0) = -Inf;
max_neg_smooth_vals(I) = max(negscores_inside_tumor_mask(brain_mask));

%%
val = 5.5;
slice = bestclusterslice( 3, (-smooth_scores > val).*tumor_mask );
slice = 32;
imagesc((-smooth_scores(:,:,slice) > val).*tumor_mask(:,:,slice))

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-smooth_scores(:,:,slice) > val).*tumor_mask(:,:,slice), (smooth_scores(:,:,slice) > 0).*tumor_mask(:,:,slice)}, {'red', 'white', 'blue'}, 4, [], 1)
axis image
subplot(1,2,2)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-scores(:,:,slice) > val).*tumor_mask(:,:,slice), (scores(:,:,slice) > 0).*tumor_mask(:,:,slice)}, {'red', 'white', 'blue'}, 4, [], 1)
% surf(fliplr(-scores(:,:,slice)))
axis image
fullscreen

%% EGGXAMINE
id = 141;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
positive_scores = scores.*(scores > 0);
smooth_positive_scores = fast_conv(positive_scores, FWHM, 3).*brain_mask;
smooth_ones = fast_conv(scores > 0, FWHM, 3);
new_scores = scores;
new_scores(smooth_ones > 0.01) = smooth_positive_scores(smooth_ones > 0.01)./smooth_ones(smooth_ones > 0.01);

% scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
% scores_outside_tumor_mask = max(smooth_scores, scores);
scores_outside_tumor_mask = new_scores;
scores_outside_tumor_mask(tumor_mask) = -Inf;
max(scores_outside_tumor_mask(brain_mask))

% negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
% negscores_inside_tumor_mask = max(-smooth_scores, -scores);
negscores_inside_tumor_mask = -new_scores;
negscores_inside_tumor_mask((1-tumor_mask) > 0) = -Inf;
max(negscores_inside_tumor_mask(brain_mask))

%%
val = 5.5;
slice = bestclusterslice( 3, (-new_scores > val).*tumor_mask );
% slice = 50;
imagesc((-new_scores(:,:,slice) > val).*tumor_mask(:,:,slice))

%%
slice = 32;
subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-new_scores(:,:,slice) > val).*tumor_mask(:,:,slice), (new_scores(:,:,slice) > 0)}, {'red', 'white', 'blue'}, 4, [], 1)
axis image
subplot(1,2,2)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-scores(:,:,slice) > val).*tumor_mask(:,:,slice), (scores(:,:,slice) > 0)}, {'red', 'white', 'blue'}, 4, [], 1)
% surf(fliplr(-scores(:,:,slice)))
axis image
fullscreen

%%
subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-new_scores(:,:,slice) > val).*tumor_mask(:,:,slice), (new_scores(:,:,slice) > 0)}, {'red', 'white', 'blue'}, 4, [], 1)
axis image
subplot(1,2,2)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-scores(:,:,slice) > val).*tumor_mask(:,:,slice), (scores(:,:,slice) > 0)}, {'red', 'white', 'blue'}, 4, [], 1)
% surf(fliplr(-scores(:,:,slice)))
axis image
fullscreen

%%
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice), (-new_scores(:,:,slice) > val).*tumor_mask(:,:,slice), (new_scores(:,:,slice) > 0).*tumor_mask(:,:,slice)}, {'red', 'white', 'blue'}, 4, [], 1)
