rng(5, 'twister')
nsim = 1000;
alpha_levels = 0.1:0.01:0.3;
set_of_outer_coverage_ob = zeros(1, nsim);
set_of_inner_coverage_ob = zeros(1, nsim);

set_of_inner_bounds_ob = zeros(1, nsim);
set_of_outer_bounds_ob = zeros(1, nsim);

average_bound_inner_ob = zeros(1, length(alpha_levels));
average_bound_outer_ob = zeros(1, length(alpha_levels));

average_ratio_inner_ob = zeros(1, length(alpha_levels));
average_ratio_outer_ob = zeros(1, length(alpha_levels));

median_ratio_inner_ob = zeros(1, length(alpha_levels));
median_ratio_outer_ob = zeros(1, length(alpha_levels));

median_ratio_outer_root_ob = zeros(1, length(alpha_levels));
median_ratio_inner_root_ob = zeros(1, length(alpha_levels));

coverage_curves_inner_ob = zeros(1, length(alpha_levels));
coverage_curves_outer_ob = zeros(1, length(alpha_levels));

for J = 1:1
    J
    cal_samples = randsample(1500, 1000);
    val_samples = setdiff(1:1500, cal_samples);
    cal_idx = other_idx(cal_samples);
    val_idx = other_idx(val_samples);
    max_od_cal = max_od(cal_samples);
    min_id_cal = min_id(cal_samples);
    % [~, max_vals_inner] = CI_fwer(scores(:,:,cal_idx), gt_masks(:,:,cal_idx), 0.1);
    % [~, max_vals_outer] = CI_fwer(1-scores(:,:,cal_idx), 1-gt_masks(:,:,cal_idx), 0.1);
    % 
    % [~, max_vals_inner_dt] = CI_fwer(scores_dist(:,:,cal_idx), gt_masks(:,:,cal_idx), 0.1);
    % [~, max_vals_outer_dt] = CI_fwer(-scores_dist(:,:,cal_idx), 1-gt_masks(:,:,cal_idx), 0.1);

    other_masks = gt_masks(:,:,val_idx);

    total_outer_ob = zeros(1, length(alpha_levels));
    total_inner_ob = zeros(1, length(alpha_levels));

    total_bound_outer_ob = zeros(1, length(alpha_levels));
    total_bound_inner_ob = zeros(1, length(alpha_levels));

    total_ratio_outer_ob = zeros(1, length(alpha_levels));
    total_ratio_inner_ob = zeros(1, length(alpha_levels));

    for K = 1:length(alpha_levels)
    % for K = 10
        K
        outer_dilation = ceil(prctile(max_od_cal, 100 * (1 - alpha_levels(K))));
        inner_dilation = ceil(prctile(-min_id_cal(min_id_cal ~= 500), 100 * (1 - 0.1)));
        
        save_ratios_outer_ob = zeros(1, 500);
        save_ratios_inner_ob = zeros(1, 500);
        for I = 1:500
            % Max-additive box
            mask = other_masks(:,:,I);
            nvoxmask = sum(mask(:) > 0);
            score_im = other_scores(:,:,I);
            predicted_mask = score_im > 0.5;
            if sum(score_im(:)> 0.5) > 0 
                predicted_outer_box = bounding_box(predicted_mask);
                predicted_inner_box = largest_inner_box(predicted_mask);
                predicted_inner = dilate_mask(predicted_inner_box, -inner_dilation);
                predicted_outer = dilate_mask(predicted_outer_box, outer_dilation);
            else
                predicted_outer = ones(352,352);
                predicted_inner = zeros(352,352);
            end

            outer_outer = 1 - predicted_outer;
            outer_mask = 1 - mask;
            if any(mask(:).*outer_outer(:))
                total_outer_ob(1, K) = total_outer_ob(1, K)+1;
            end
            if any(outer_mask(:).*predicted_inner(:))
                total_inner_ob(1, K) = total_inner_ob(1, K)+1;
            end
            total_bound_outer_ob(1,K) = sum((predicted_outer(:) - mask(:)) > 0) + total_bound_outer_ob(1,K);
            total_bound_inner_ob(1,K) = sum((mask(:) - predicted_inner(:)) > 0) + total_bound_inner_ob(1,K);

            save_ratios_outer_ob(1,I) = sum(predicted_outer(:) > 0)/nvoxmask;
            save_ratios_inner_ob(1,I) = sum(predicted_inner(:) > 0)/nvoxmask;
            
        end
        median_ratio_outer_ob(:,K) = median(save_ratios_outer_ob, 2) + median_ratio_outer_ob(:,K);
        median_ratio_inner_ob(:,K) = median(save_ratios_inner_ob, 2) + median_ratio_inner_ob(:,K);
        median_ratio_outer_root_ob(:,K) = median(sqrt(save_ratios_outer_ob), 2) + median_ratio_outer_root_ob(:,K);
        median_ratio_inner_root_ob(:,K) = median(sqrt(save_ratios_inner_ob), 2) + median_ratio_inner_root_ob(:,K);
    end

    coverage_curves_outer_ob = total_outer_ob/500 + coverage_curves_outer_ob;
    coverage_curves_inner_ob = total_inner_ob/500 + coverage_curves_inner_ob;

    average_bound_inner_ob = total_bound_inner_ob/500 + average_bound_inner_ob;
    average_bound_outer_ob = total_bound_outer_ob/500 + average_bound_outer_ob;

    average_ratio_inner_ob = total_ratio_inner_ob/500 + average_ratio_inner_ob;
    average_ratio_outer_ob = total_ratio_outer_ob/500 + average_ratio_outer_ob;

    set_of_outer_coverage_ob(:, J) = total_outer_ob(:, 10)/500;
    set_of_inner_coverage_ob(:, J) = total_inner_ob(:, 10)/500;

    save('./covinfo_origbox.mat', 'coverage_curves_outer', 'coverage_curves_inner', 'average_bound_inner', 'average_bound_outer', 'median_ratio_inner', 'median_ratio_outer', 'median_ratio_inner_root', 'median_ratio_outer_root', 'average_ratio_inner', 'average_ratio_outer', 'J')
end
