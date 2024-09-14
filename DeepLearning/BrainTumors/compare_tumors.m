%% Run conformal inference
nimages = 200;
max_pos_vals = zeros(1, nimages);
max_neg_vals = zeros(1, nimages);
for I = 1:nimages
    I
    [ scores, tumor_mask, orig_im, brain_mask ] = load_brats_scores( I );
    % scores_outside_tumor_mask = squeeze(scores.*(1 - tumor_mask));
    scores_outside_tumor_mask = scores;
    scores_outside_tumor_mask(tumor_mask) = -Inf;
    max_pos_vals(I) = max(scores_outside_tumor_mask(brain_mask));

    % negscores_inside_tumor_mask = squeeze(-scores.*(tumor_mask));
    negscores_inside_tumor_mask = -scores;
    negscores_inside_tumor_mask((1-tumor_mask) > 0) = -Inf;
    max_neg_vals(I) = max(negscores_inside_tumor_mask(brain_mask));
end