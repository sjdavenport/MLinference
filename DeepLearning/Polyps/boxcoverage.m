%% Bounding box coverage
rng(5, 'twister')
nsim = 1000;
alpha_levels_bt = 0:0.01:0.3;
set_of_outer_coverage_bt = zeros(1, nsim);
set_of_inner_coverage_bt = zeros(1, nsim);

set_of_inner_bounds_bt = zeros(1, nsim);
set_of_outer_bounds_bt = zeros(1, nsim);

average_bound_inner_bt = zeros(1, length(alpha_levels_bt));
average_bound_outer_bt = zeros(1, length(alpha_levels_bt));

average_ratio_inner_bt = zeros(1, length(alpha_levels_bt));
average_ratio_outer_bt = zeros(1, length(alpha_levels_bt));

median_ratio_inner_bt = zeros(1, length(alpha_levels_bt));
median_ratio_outer_bt = zeros(1, length(alpha_levels_bt));

median_ratio_outer_root_bt = zeros(1, length(alpha_levels_bt));
median_ratio_inner_root_bt = zeros(1, length(alpha_levels_bt));

coverage_curves_inner_bt = zeros(1, length(alpha_levels_bt));
coverage_curves_outer_bt = zeros(1, length(alpha_levels_bt));

[~, max_vals_inner_all_bt] = CI_fwer(scores_dist_bt_inner, gt_masks, 0.1);
[~, max_vals_outer_all_bt] = CI_fwer(-scores_dist_bt_outer, 1-gt_masks, 0.1);
% [~, max_vals_inner_all_bt] = CI_fwer(scores_dist_bt, gt_masks, 0.1);
% [~, max_vals_outer_all_bt] = CI_fwer(-scores_dist_bt, 1-gt_masks, 0.1);

% for J = 1:1000
for J = 1:1000
    J
    cal_samples = randsample(1500, 1000);
    val_samples = setdiff(1:1500, cal_samples);
    cal_idx = other_idx(cal_samples);
    val_idx = other_idx(val_samples);
    max_vals_inner_bt = max_vals_inner_all_bt(cal_idx);
    max_vals_outer_bt = max_vals_outer_all_bt(cal_idx);

    % other_scores_bt = scores_dist_bt(:,:,val_idx);
    other_scores_bt_inner = scores_dist_bt_inner(:,:,val_idx);
    other_scores_bt_outer = scores_dist_bt_outer(:,:,val_idx);

    other_masks = gt_masks(:,:,val_idx);

    total_outer_bt = zeros(1, length(alpha_levels_bt));
    total_inner_bt = zeros(1, length(alpha_levels_bt));

    total_bound_outer_bt = zeros(1, length(alpha_levels_bt));
    total_bound_inner_bt = zeros(1, length(alpha_levels_bt));

    total_ratio_outer_bt = zeros(1, length(alpha_levels_bt));
    total_ratio_inner_bt = zeros(1, length(alpha_levels_bt));

    for K = 1:length(alpha_levels_bt)
        % for K = 10
        K
        threshold_inner_bt = prctile(max_vals_inner_bt, 100 * (1 - alpha_levels_bt(K)));
        threshold_outer_bt = prctile(max_vals_outer_bt, 100 * (1 - alpha_levels_bt(K)));
        
        save_ratios_outer_bt = zeros(1, 500);
        save_ratios_inner_bt = zeros(1, 500);
        for I = 1:500
            % Distance transformed scores
            mask = other_masks(:,:,I);
            nvoxmask = sum(mask(:) > 0);
            % score_im_bt = other_scores_bt(:,:,I);
            score_im_bt_inner = other_scores_bt_inner(:,:,I);
            score_im_bt_outer = other_scores_bt_outer(:,:,I);
            % predicted_inner = score_im_bt > threshold_inner_bt;
            predicted_inner = score_im_bt_inner > threshold_inner_bt;
            % predicted_outer = 1 - ((-score_im_bt) > threshold_outer_bt);
            predicted_outer = 1 - ((-score_im_bt_outer) > threshold_outer_bt);
            outer_outer = 1 - predicted_outer;
            outer_mask = 1 - mask;
            if any(mask(:).*outer_outer(:))
                total_outer_bt(1, K) = total_outer_bt(1, K)+1;
            end
            if any(outer_mask(:).*predicted_inner(:))
                total_inner_bt(1, K) = total_inner_bt(1, K)+1;
            end
            total_bound_outer_bt(1,K) = sum((predicted_outer(:) - mask(:))> 0) + total_bound_outer_bt(1,K);
            total_bound_inner_bt(1,K) = sum((mask(:) - predicted_inner(:)) > 0) + total_bound_inner_bt(1,K);

            % sum((predicted_outer(:) - mask(:)) > 0)/nvoxmask
            save_ratios_outer_bt(1,I) = sum(predicted_outer(:) > 0)/nvoxmask;
            save_ratios_inner_bt(1,I) = sum(predicted_inner(:) > 0)/nvoxmask;

            total_ratio_outer_bt(1,K) = sqrt(sum(predicted_outer(:) > 0)/nvoxmask) + total_ratio_outer_bt(1,K);
            total_ratio_inner_bt(1,K) = sqrt(sum(predicted_inner(:) > 0)/nvoxmask) + total_ratio_inner_bt(1,K);
        end
        median_ratio_outer_bt(:,K) = median(save_ratios_outer_bt, 2) + median_ratio_outer_bt(:,K);
        median_ratio_inner_bt(:,K) = median(save_ratios_inner_bt, 2) + median_ratio_inner_bt(:,K);
        median_ratio_outer_root_bt(:,K) = median(sqrt(save_ratios_outer_bt), 2) + median_ratio_outer_root_bt(:,K);
        median_ratio_inner_root_bt(:,K) = median(sqrt(save_ratios_inner_bt), 2) + median_ratio_inner_root_bt(:,K);
    end

    coverage_curves_outer_bt = total_outer_bt/500 + coverage_curves_outer_bt;
    coverage_curves_inner_bt = total_inner_bt/500 + coverage_curves_inner_bt;

    average_bound_inner_bt = total_bound_inner_bt/500 + average_bound_inner_bt;
    average_bound_outer_bt = total_bound_outer_bt/500 + average_bound_outer_bt;

    average_ratio_inner_bt = total_ratio_inner_bt/500 + average_ratio_inner_bt;
    average_ratio_outer_bt = total_ratio_outer_bt/500 + average_ratio_outer_bt;

    set_of_outer_coverage_bt(:, J) = total_outer_bt(:, 10)/500;
    set_of_inner_coverage_bt(:, J) = total_inner_bt(:, 10)/500;

    save('./covinfo_bt.mat', 'coverage_curves_outer', 'coverage_curves_inner', 'average_bound_inner', 'average_bound_outer', 'median_ratio_inner', 'median_ratio_outer', 'median_ratio_inner_root', 'median_ratio_outer_root', 'average_ratio_inner', 'average_ratio_outer', 'J')
end