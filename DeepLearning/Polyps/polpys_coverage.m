loadpolypsdata

%%
rng(2, 'twister')
learning_idx = randsample(1798, 298);
other_idx = setdiff(1:1798, learning_idx);

%%
alpha_levels = 0:0.1:1;
coverage = zeros(1, length(alpha_levels));

[threshold_dist_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_dist, 1-cal_gt_masks, alpha_levels(J))

% threshold_dist_outer = 16;
for J = 1:length(coverage)
    total = 0;
    J
    for I = 1:1000
        mask = val_gt_masks(:,:,I);
        score_im = val_scores_dist(:,:,I);
        predicted_outer = 1 - ( (-score_im) > threshold_dist_outer);
        outer_outer = 1 - predicted_outer;
        if any(mask(:).*outer_outer(:))
            total = total+1;
        end
    end
    coverage(J) = total/1000;
end

%%
plot(alpha_levels, coverage)

%%
rng(5, 'twister')
nsim = 1000;
alpha_levels = 0:0.01:1;
set_of_outer_coverage = zeros(3, nsim);
set_of_inner_coverage = zeros(3, nsim);

set_of_inner_bounds = zeros(3, nsim);
set_of_outer_bounds = zeros(3, nsim);

average_bound_inner = zeros(3, length(alpha_levels));
average_bound_outer = zeros(3, length(alpha_levels));

median_ratio_inner = zeros(3, length(alpha_levels));
median_ratio_outer = zeros(3, length(alpha_levels));

median_ratio_outer_root = zeros(3, length(alpha_levels));
median_ratio_inner_root = zeros(3, length(alpha_levels));

coverage_curves_inner = zeros(3, length(alpha_levels));
coverage_curves_outer = zeros(3, length(alpha_levels));

[~, max_vals_inner_all] = CI_fwer(scores, gt_masks, 0.1);
[~, max_vals_outer_all] = CI_fwer(1-scores, 1-gt_masks, 0.1);

[~, max_vals_inner_dt_all] = CI_fwer(scores_dist, gt_masks, 0.1);
[~, max_vals_outer_dt_all] = CI_fwer(-scores_dist, 1-gt_masks, 0.1);

for J = 1:1000
    J
    cal_samples = randsample(1500, 1000);
    val_samples = setdiff(1:1500, cal_samples);
    cal_idx = other_idx(cal_samples);
    val_idx = other_idx(val_samples);
    max_vals_inner = max_vals_inner_all(cal_idx);
    max_vals_outer = max_vals_outer_all(cal_idx);
    max_vals_inner_dt = max_vals_inner_dt_all(cal_idx);
    max_vals_outer_dt = max_vals_outer_dt_all(cal_idx);
    max_od_cal = max_od(cal_sample);
    min_id_cal = min_id(cal_sample);
    % [~, max_vals_inner] = CI_fwer(scores(:,:,cal_idx), gt_masks(:,:,cal_idx), 0.1);
    % [~, max_vals_outer] = CI_fwer(1-scores(:,:,cal_idx), 1-gt_masks(:,:,cal_idx), 0.1);
    % 
    % [~, max_vals_inner_dt] = CI_fwer(scores_dist(:,:,cal_idx), gt_masks(:,:,cal_idx), 0.1);
    % [~, max_vals_outer_dt] = CI_fwer(-scores_dist(:,:,cal_idx), 1-gt_masks(:,:,cal_idx), 0.1);

    other_scores = scores(:,:,val_idx);
    other_scores_dist = scores_dist(:,:,val_idx);

    other_masks = gt_masks(:,:,val_idx);

    total_outer = zeros(3, length(alpha_levels));
    total_inner = zeros(3, length(alpha_levels));

    total_bound_outer = zeros(3, length(alpha_levels));
    total_bound_inner = zeros(3, length(alpha_levels));

    total_ratio_outer = zeros(3, length(alpha_levels));
    total_ratio_inner = zeros(3, length(alpha_levels));

    for K = 1:length(alpha_levels)
    % for K = 10
        K
        threshold_inner = prctile(max_vals_inner, 100 * (1 - alpha_levels(K)));
        threshold_outer = prctile(max_vals_outer, 100 * (1 - alpha_levels(K)));
        threshold_inner_dt = prctile(max_vals_inner_dt, 100 * (1 - alpha_levels(K)));
        threshold_outer_dt = prctile(max_vals_outer_dt, 100 * (1 - alpha_levels(K)));
        outer_dilation = prctile(max_od_cal, 100 * (1 - alpha_levels(K)));
        inner_dilation = prctile(-min_id_cal(min_id_cal ~= 500), 100 * (1 - 0.1));
        
        save_ratios_outer = zeros(3, 500);
        save_ratios_inner = zeros(3, 500);
        for I = 1:500
            % Original scores
            mask = other_masks(:,:,I);
            score_im = other_scores(:,:,I);
            predicted_inner = score_im > threshold_inner;
            predicted_outer = 1 - ( (1-score_im) > threshold_outer);
            outer_outer = 1 - predicted_outer;
            outer_mask = 1 - mask;
            if any(mask(:).*outer_outer(:))
                total_outer(1, K) = total_outer(1, K)+1;
            end
            if any(outer_mask(:).*predicted_inner(:))
                total_inner(1, K) = total_inner(1, K)+1;
            end
            total_bound_outer(1,K) = sum((predicted_outer(:) - mask(:)) > 0) + total_bound_outer(1,K);
            total_bound_inner(1,K) = sum((mask(:) - predicted_inner(:)) > 0) + total_bound_inner(1,K);

            nvoxmask = sum(mask(:) > 0);
            save_ratios_outer(1,I) = sum(predicted_outer(:) > 0)/nvoxmask;
            save_ratios_inner(1,I) = sum(predicted_inner(:) > 0)/nvoxmask;
            total_ratio_outer(1,K) = sqrt(sum(predicted_outer(:) > 0)/nvoxmask) + total_ratio_outer(1,K);
            total_ratio_inner(1,K) = sqrt(sum(predicted_inner(:) > 0)/nvoxmask) + total_ratio_inner(1,K);
            
            % Distance transformed scores
            score_im_dt = other_scores_dist(:,:,I);
            predicted_inner = score_im_dt > threshold_inner_dt;
            predicted_outer = 1 - ((-score_im_dt) > threshold_outer_dt);
            outer_outer = 1 - predicted_outer;
            outer_mask = 1 - mask;
            if any(mask(:).*outer_outer(:))
                total_outer(2, K) = total_outer(2, K)+1;
            end
            if any(outer_mask(:).*predicted_inner(:))
                total_inner(2, K) = total_inner(2, K)+1;
            end
            total_bound_outer(2,K) = sum((predicted_outer(:) - mask(:))> 0) + total_bound_outer(2,K);
            total_bound_inner(2,K) = sum((mask(:) - predicted_inner(:)) > 0) + total_bound_inner(2,K);
            
            % sum((predicted_outer(:) - mask(:)) > 0)/nvoxmask
            save_ratios_outer(2,I) = sum(predicted_outer(:) > 0)/nvoxmask;
            save_ratios_inner(2,I) = sum(predicted_inner(:) > 0)/nvoxmask;

            total_ratio_outer(2,K) = sqrt(sum(predicted_outer(:) > 0)/nvoxmask) + total_ratio_outer(2,K);
            total_ratio_inner(2,K) = sqrt(sum(predicted_inner(:) > 0)/nvoxmask) + total_ratio_inner(2,K);
            % total_ratio_outer(2,K) = sum((predicted_outer(:) - mask(:)) > 0)/nvoxmask + total_ratio_outer(2,K);
            % total_ratio_inner(2,K) = sum((mask(:) - predicted_inner(:)) > 0)/nvoxmask + total_ratio_inner(2,K);
            % disp(total_ratio_inner(2,K))

            % % Max-additive box
            % mask = other_masks(:,:,I);
            % score_im = other_scores(:,:,I);
            % predicted_mask = score_im > 0.5;
            % if sum(score_im(:)> 0.5) > 0 
            %     predicted_outer_box = bounding_box(predicted_mask);
            %     predicted_inner_box = largest_inner_box(predicted_mask);
            %     predicted_inner = dilate_mask(predicted_inner_box, -inner_dilation);
            %     predicted_outer = dilate_mask(predicted_outer_box, outer_dilation);
            % else
            %     predicted_outer = ones(352,352);
            %     predicted_inner = zeros(352,352);
            % end
            % 
            % outer_outer = 1 - predicted_outer;
            % outer_mask = 1 - mask;
            % if any(mask(:).*outer_outer(:))
            %     total_outer(3, K) = total_outer(3, K)+1;
            % end
            % if any(outer_mask(:).*predicted_inner(:))
            %     total_inner(3, K) = total_inner(3, K)+1;
            % end
            % total_bound_outer(3,K) = sum((predicted_outer(:) - mask(:)) > 0) + total_bound_outer(3,K);
            % total_bound_inner(3,K) = sum((mask(:) - predicted_inner(:)) > 0) + total_bound_inner(3,K);
            % 
            % save_ratios_outer(3,I) = sum(predicted_outer(:) > 0)/nvoxmask;
            % save_ratios_inner(3,I) = sum(predicted_inner(:) > 0)/nvoxmask;
            
        end
        median_ratio_outer(:,K) = median(save_ratios_outer, 2) + median_ratio_outer(:,K);
        median_ratio_inner(:,K) = median(save_ratios_inner, 2) + median_ratio_inner(:,K);
        median_ratio_outer_root(:,K) = median(sqrt(save_ratios_outer), 2) + median_ratio_outer(:,K);
        median_ratio_inner_root(:,K) = median(sqrt(save_ratios_inner), 2) + median_ratio_inner(:,K);
    end

    coverage_curves_outer = total_outer/500 + coverage_curves_outer;
    coverage_curves_inner = total_inner/500 + coverage_curves_inner;

    average_bound_inner = total_bound_inner/500 + average_bound_inner;
    average_bound_outer = total_bound_outer/500 + average_bound_outer;

    average_ratio_inner = total_ratio_inner/500 + average_ratio_inner;
    average_ratio_outer = total_ratio_outer/500 + average_ratio_outer;

    set_of_outer_coverage(:, J) = total_outer(:, 10)/500;
    set_of_inner_coverage(:, J) = total_inner(:, 10)/500;

    save('./covinfo.mat', 'coverage_curves_outer', 'coverage_curves_inner', 'average_bound_inner', 'average_bound_outer', 'median_ratio_inner', 'median_ratio_outer', 'median_ratio_inner_root', 'median_ratio_outer_root', 'average_ratio_inner', 'average_ratio_outer', 'J')
end


%%
plot(1-alpha_levels(1:21), average_bound_outer(1,1:21)/123904, 'LineWidth', 4, 'color', [0.5, 0.5, 1])
hold on
plot(1-alpha_levels(1:21), average_bound_outer(2,1:21)/123904, 'LineWidth', 4, 'color', [0.8,0.4,0.8])
plot(1-alpha_levels(1:21), average_bound_outer(3,1:21)/123904, 'LineWidth', 4, 'color', 'black')

% plot([0.1, 0.1], [0, 1], '--', 'color', [0.5,0.5,0.5], 'LineWidth', 3)
matniceplot
BigFont(25)
ylim([0,1])
xlabel('1-\alpha_2')
ylabel('Ratio')
title('Outer bounds')
legend('Original scores', 'DT scores', 'Location', 'NW')

%% Inner
plot(1-alpha_levels(1:21), average_bound_inner(1,1:21)/123904, 'LineWidth', 4, 'color', [0.5, 0.5, 1])
hold on
plot(1-alpha_levels(1:21), average_bound_inner(2,1:21)/123904, 'LineWidth', 4, 'color', [0.8,0.4,0.8])
plot(1-alpha_levels(1:21), average_bound_inner(3,1:21)/123904, 'LineWidth', 4, 'color', 'black')
% plot([0.1, 0.1], [0, 1], '--', 'color', [0.5,0.5,0.5], 'LineWidth', 3)
matniceplot
BigFont(25)
ylim([0,0.15])
xlabel('1-\alpha_1')
ylabel('Ratio')
title('Inner bounds')
legend('Original scores', 'DT scores', 'Location', 'NW')

%%
plot(alpha_levels(1:20), total_bound_inner(1,1:20), 'LineWidth', 4, 'color', [0.5, 0.5, 1])
hold on
% plot(alpha_levels(1:20), total_bound_inner(2,1:20), 'LineWidth', 4, 4, 'color', [0.8,0.4,0.8])
matniceplot
ylim([0,max(total_bound_inner(:))])

%%
plot(alpha_levels(:), average_ratio_outer(1,:), 'LineWidth', 4, [0.5, 0.5, 1])
hold on
plot(alpha_levels(:), average_ratio_outer(2,:), 'LineWidth', 4, [0.8,0.4,0.8])
plot([0.1, 0.1], [0, 1], '--', 'color', [0.5,0.5,0.5], 'LineWidth', 3)
matniceplot
BigFont(25)
% ylim([0,1])
xlabel('\alpha_1')
ylabel('Ratio')
title('Outer bounds')
legend('Original scores', 'DT scores')

%% Plot coverage curves
plot([0,.2], [0,.2], '--', 'color', [0.5, 0.5, 0.5], 'LineWidth', 3, 'HandleVisibility', 'off')
hold on
plot(alpha_levels(1:21), coverage_curves_outer(1,1:21), 'LineWidth', 4, 'color', [0.5, 0.5, 1])
plot(alpha_levels(1:21), coverage_curves_outer(2,1:21), 'LineWidth', 4, 'color', [0.8,0.4,0.8])
plot(alpha_levels(1:21), coverage_curves_outer(3,1:21), 'LineWidth', 4, 'color', 'black')
matniceplot
BigFont(25)
% ylim([0,1])
xlabel('\alpha_1')
ylabel('Error rate')
title('Outer coverage')
legend('Original scores', 'DT scores', 'Bounding box', 'Location', 'SE')

%% Compute the oracle bounding box scores


%%
h = histogram(set_of_outer_coverage);
matnicehist('white')
hold on
plot([mean(set_of_outer_coverage), mean(set_of_outer_coverage)], [0,160], '--', 'LineWidth', 4, 'color', 'black')
xticks(0.05:0.01:0.15)
BigFont(25)
xlim([0.05, 0.15])
% h.BinWidth = 0.002

%%
h = histogram(set_of_inner_coverage);
matnicehist('white')
hold on
plot([mean(set_of_inner_coverage), mean(set_of_inner_coverage)], [0,180], '--', 'LineWidth', 4, 'color', 'black')
ylim([0,180])
xlim([0.05, 0.15])
xticks(0.05:0.01:0.15)
BigFont(25)
% h.BinWidth = 0.005;


%% Examine the scores in and outside the masks
% [ scoresinmask, scoresoutofmask] = mask_scores( scores, gt_masks );
subplot(1,2,1)
h = histogram(scoresinmask);
h.BinWidth = 0.01;
matnicehist('white')
subplot(1,2,2)
h = histogram(scoresoutofmask);
h.BinWidth = 0.01;
matnicehist('white')

%%
h = histogram(scoresinmask, 'Normalization','probability');
h.BinWidth = 0.01;
matnicehist('white')
hold on
h = histogram(scoresoutofmask, 'Normalization','probability')
h.BinWidth = 0.01;
matnicehist('white')

