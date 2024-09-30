%%
rng(5, 'twister')
nsim = 1000;
alpha_levels = 0.1;
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
        end
    end

    set_of_outer_coverage(:, J) = total_outer/500;
    set_of_inner_coverage(:, J) = total_inner/500;

    save('./covinfo_hist.mat', 'set_of_outer_coverage', 'set_of_inner_coverage', 'J')
end

%% Outer histogram
histogram(set_of_outer_coverage(1,:))
hold on
histogram(set_of_outer_coverage(2,:))
screenshape([1,1,1000,500], 'white')
matnicehist('white')


%% Inner histogram
histogram(set_of_inner_coverage(1,:))
hold on
histogram(set_of_inner_coverage(2,:))
screenshape([1,1,1000,500], 'white')
matnicehist('white')

%% Together
subplot(2,2,1)
h1 = histogram(set_of_inner_coverage(1,:));
h1.FaceColor = [0.5, 0.5, 1];
matnicehist('white')
BigFont(15)
legend('Original')
subplot(2,2,2)
h2 = histogram(set_of_inner_coverage(2,:));
h2.FaceColor = [0.8,0.4,0.8];
legend('DT')
title('Inner coverage, \alpha_1 = 0.1')
matnicehist('white')
BigFont(15)

subplot(2,2,3)
h3 = histogram(set_of_outer_coverage(1,:));
h3.FaceColor = [0.5, 0.5, 1];
matnicehist('white')
BigFont(15)
subplot(2,2,4)
h4 = histogram(set_of_outer_coverage(2,:));
h4.FaceColor = [0.8,0.4,0.8];
screenshape([1,1,750,500], 'white')
title('Outer coverage, \alpha_2 = 0.1')
matnicehist('white')
BigFont(15)
screenshape([1,1,750,750], 'white')

% saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/';
% saveim('val_hist.pdf', saveloc)

%% Separate
saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/validation/';
h1 = histogram(1-set_of_inner_coverage(1,:));
h1.FaceColor = [0.5, 0.5, 1];
matnicehist('white')
% BigFont(30)
title('Original inner')
xlabel('1-\alpha_1')
screenshape([1,1,1000,600], 'white')
ylim([0,160])
xlim([0.84,0.96])
BigFont(40)
saveim('val_hist_orig_inner.pdf', saveloc)

h2 = histogram(1-set_of_inner_coverage(2,:));
h2.FaceColor = [0.8,0.4,0.8];
title('DT inner')
matnicehist('white')
xlabel('1-\alpha_1')
% BigFont(15)
screenshape([1,1,1000,600], 'white')
ylim([0,160])
xlim([0.84,0.96])
BigFont(40)
saveim('val_hist_dt_inner.pdf', saveloc)

h1 = histogram(1-set_of_outer_coverage(1,:));
h1.FaceColor = [0.5, 0.5, 1];
matnicehist('white')
% BigFont(30)
title('Original outer')
xlabel('1-\alpha_2')
screenshape([1,1,1000,600], 'white')
ylim([0,160])
xlim([0.84,0.96])
BigFont(40)
saveim('val_hist_orig_outer.pdf', saveloc)

h2 = histogram(1-set_of_outer_coverage(2,:));
h2.FaceColor = [0.8,0.4,0.8];
% legend('DT')
matnicehist('white')
% BigFont(15)
title('DT outer')
xlabel('1-\alpha_2')
screenshape([1,1,1000,600], 'white')
ylim([0,160])
xlim([0.84,0.96])
BigFont(40)
saveim('val_hist_dt_outer.pdf', saveloc)