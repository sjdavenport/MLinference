%% Run conformal inference - orig
nimages = 200;
max_pos_vals = zeros(1, nimages);
max_neg_vals = zeros(1, nimages);
slice = 50;
for I = 1:nimages
    I
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
    brain_mask_2D = brain_mask(:,:,slice);
    tumor_mask2D = tumor_mask(:,:,slice);

    scores2D = scores(:,:,slice);
    scores2D((1 - brain_mask_2D)>0) = -Inf;

    % scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
    scores_outside_tumor_mask = scores2D;
    scores_outside_tumor_mask(tumor_mask2D) = -Inf;
    max_pos_vals(I) = max(scores_outside_tumor_mask(brain_mask_2D));

    % negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
    negscores_inside_tumor_mask = -scores2D;
    negscores_inside_tumor_mask((1-tumor_mask2D) > 0) = -Inf;
    max_neg_vals(I) = max(negscores_inside_tumor_mask(brain_mask_2D));
end

%%
save('./brats_conformal_2D.mat', 'max_pos_vals', 'max_neg_vals')

%% Obtain one-sided thresholds
alpha = 0.2;
pos_thresh = prctile(max_pos_vals, 100 * (1 - alpha));
neg_thresh = prctile(max_neg_vals, 100 * (1 - alpha));

%%
for id = 201:220
slice = 50;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
brain_mask_2D = brain_mask(:,:,slice);
tumor_mask2D = tumor_mask(:,:,slice);

scores2D = scores(:,:,slice);
scores2D((1 - brain_mask_2D)>0) = -Inf;

inner_set = scores2D > pos_thresh;
outer_set = (-scores2D) > neg_thresh;

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask_2D, {tumor_mask2D}, 'red', 4, [], 0.5)
subplot(1,2,2)
viewdata(orig_im(:,:,slice,3), brain_mask_2D, {1-outer_set, inner_set}, {'blue', 'red'}, 4, [], 1)
fullscreen
pause
end
%% Run conformal inference - distance adjusted
nimages = 200;
max_pos_vals_dist = zeros(1, nimages);
max_neg_vals_dist = zeros(1, nimages);
slice = 50;
for I = 1:nimages
    I
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
    brain_mask_2D = brain_mask(:,:,slice);
    tumor_mask2D = tumor_mask(:,:,slice);

    scores2D = scores(:,:,slice);
    scores2D((1 - brain_mask_2D)>0) = -Inf;
    predicted_mask = scores2D > 0;
    if sum(predicted_mask(:)) > 0
        dist_scores = dist2maskbndry( predicted_mask, brain_mask_2D );
 
        % scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
        scores_outside_tumor_mask = dist_scores;
        scores_outside_tumor_mask(tumor_mask2D) = -Inf;
        max_pos_vals_dist(I) = max(scores_outside_tumor_mask(brain_mask_2D));

        % negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
        negscores_inside_tumor_mask = -dist_scores;
        negscores_inside_tumor_mask((1-tumor_mask2D) > 0) = -Inf;
        max_neg_vals_dist(I) = max(negscores_inside_tumor_mask(brain_mask_2D));
    else
        disp(I)
    end
end

%%
save('./brats_conformal_2D_dist.mat', 'max_pos_vals_dist', 'max_neg_vals_dist')

%% Obtain one-sided thresholds
alpha = 0.2;
pos_thresh = prctile(max_pos_vals_dist, 100 * (1 - alpha));
neg_thresh = prctile(max_neg_vals_dist, 100 * (1 - alpha));

%%
for id = 201:220
slice = 50;
[ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( id );
brain_mask_2D = brain_mask(:,:,slice);
tumor_mask2D = tumor_mask(:,:,slice);

scores2D = scores(:,:,slice);
scores2D((1 - brain_mask_2D)>0) = -Inf;

predicted_mask = scores2D > 0;
dist_scores = dist2maskbndry( predicted_mask, brain_mask_2D );

inner_set = dist_scores > pos_thresh;
outer_set = (-dist_scores) > neg_thresh;

subplot(1,2,1)
viewdata(orig_im(:,:,slice), brain_mask_2D, {tumor_mask2D}, 'red', 4, [], 0.5)
subplot(1,2,2)
viewdata(orig_im(:,:,slice,3), brain_mask_2D, {1-outer_set, tumor_mask2D, inner_set}, {'blue', 'yellow', 'red'}, 4, [], 1)

fullscreen
pause
end