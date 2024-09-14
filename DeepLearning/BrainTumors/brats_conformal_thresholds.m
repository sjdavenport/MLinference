%%
% Calculate dist values
nimages = 200;
for I = 1:1
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
    bmscores = scores(brain_mask);

end
%% Run conformal inference
nimages = 200;
max_pos_vals = zeros(1, nimages);
max_neg_vals = zeros(1, nimages);
for I = 1:nimages
    I
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
    bmscores = scores(brain_mask);
    scores = scores - mean(bmscores(:));
    % scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
    scores_outside_tumor_mask = scores;
    scores_outside_tumor_mask(tumor_mask) = -Inf;
    max_pos_vals(I) = max(scores_outside_tumor_mask(brain_mask));

    % negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
    negscores_inside_tumor_mask = -scores;
    negscores_inside_tumor_mask((1-tumor_mask) > 0) = -Inf;
    max_neg_vals(I) = max(negscores_inside_tumor_mask(brain_mask));
end

%% Obtain one-sided thresholds
alpha = 0.1;
pos_thresh = prctile(max_pos_vals, 100 * (1 - alpha));
neg_thresh = prctile(max_neg_vals, 100 * (1 - alpha));

%%
id = 210;
slice = 60;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
bmscores = scores(brain_mask);
scores = scores - mean(bmscores(:));

inner_set = scores > pos_thresh;
outer_set = (-scores) > neg_thresh;

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice)}, 'red', 4, [], 0.5)
subplot(1,2,2)
viewdata(orig_im(:,:,slice,3), brain_mask(:,:,slice), {1-outer_set(:,:,slice), inner_set(:,:,slice)}, {'blue', 'red'}, 4, [], 1)

%%
slice = 60;
surf(scores(:,:,slice))

%% Smooth the scores
nimages = 200;
max_pos_smooth_vals = zeros(1, nimages);
max_neg_smooth_vals = zeros(1, nimages);
FWHM = 30;
for I = 1:nimages
    I
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
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
end

%% Obtain one-sided thresholds
alpha = 0.2;
pos_smooth_thresh = prctile(max_pos_smooth_vals, 100 * (1 - alpha));
neg_smooth_thresh = prctile(max_neg_smooth_vals, 100 * (1 - alpha));

%%
id = 215;
slice = 60;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
smooth_scores = fast_conv(scores, FWHM, 3).*brain_mask;
smooth_ones = fast_conv(brain_mask, FWHM, 3);
smooth_scores(brain_mask) = smooth_scores(brain_mask)./smooth_ones(brain_mask);

% inner_set = smooth_scores > pos_smooth_thresh;
% outer_set = (-smooth_scores) > neg_smooth_thresh;

inner_set = smooth_scores > pos_smooth_thresh;
outer_set = -smooth_scores > neg_smooth_thresh;

% slice = bestclusterslice( 3, inner_set );

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice)}, 'red', 4, [], 0.5)
axis image
subplot(1,2,2)
viewdata(orig_im(:,:,slice,3), brain_mask(:,:,slice), {1-outer_set(:,:,slice), inner_set(:,:,slice)}, {'blue', 'red'}, 4, [], 1)
axis image
fullscreen

%% compare scores
slice = 60;
subplot(1,2,1)
surf(scores(:,:,slice))
% axis image
subplot(1,2,2)
surf(smooth_scores(:,:,slice))
fullscreen

%% Emphasize positive scores
nimages = 200;
max_pos_emppos_vals = zeros(1, nimages);
max_neg_emppos_vals = zeros(1, nimages);
FWHM = 8;
for I = 1:nimages
    I
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
    positive_scores = scores.*(scores > 0);
    smooth_positive_scores = fast_conv(positive_scores, FWHM, 3).*brain_mask;
    smooth_ones = fast_conv(scores > 0, FWHM, 3);
    new_scores = scores;
    new_scores(smooth_ones > 0.01) = smooth_positive_scores(smooth_ones > 0.01)./smooth_ones(smooth_ones > 0.01);

    % scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
    % scores_outside_tumor_mask = max(smooth_scores, scores);
    scores_outside_tumor_mask = new_scores;
    scores_outside_tumor_mask(tumor_mask) = -Inf;
    max_pos_emppos_vals(I) = max(scores_outside_tumor_mask(brain_mask));

    % negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
    % negscores_inside_tumor_mask = max(-smooth_scores, -scores);
    negscores_inside_tumor_mask = -new_scores;
    negscores_inside_tumor_mask((1-tumor_mask) > 0) = -Inf;
    max_neg_emppos_vals(I) = max(negscores_inside_tumor_mask(brain_mask));
end

%% Obtain one-sided thresholds
alpha = 0.2;
pos_emppos_thresh = prctile(max_pos_emppos_vals, 100 * (1 - alpha));
neg_emppos_thresh = prctile(max_neg_emppos_vals, 100 * (1 - alpha));

%%
id = 205;
slice = 60;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
positive_scores = scores.*(scores > 0);
smooth_positive_scores = fast_conv(positive_scores, FWHM, 3).*brain_mask;
smooth_ones = fast_conv(scores > 0, FWHM, 3);
new_scores = scores;
new_scores(smooth_ones > 0.01) = smooth_positive_scores(smooth_ones > 0.01)./smooth_ones(smooth_ones > 0.01);

% inner_set = smooth_scores > pos_smooth_thresh;
% outer_set = (-smooth_scores) > neg_smooth_thresh;

inner_set = new_scores > pos_emppos_thresh;
outer_set = -new_scores > neg_emppos_thresh;

% slice = bestclusterslice( 3, inner_set );

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask(:,:,slice), {tumor_mask(:,:,slice)}, 'red', 4, [], 0.5)
axis image
subplot(1,2,2)
viewdata(orig_im(:,:,slice,3), brain_mask(:,:,slice), {1-outer_set(:,:,slice), inner_set(:,:,slice)}, {'blue', 'red'}, 4, [], 1)
axis image
fullscreen

%%
sum(max_neg_smooth_vals - max_neg_emppos_vals > 0)