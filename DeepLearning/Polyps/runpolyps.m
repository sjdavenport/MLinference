%%
[threshold, max_vals] = CI_fwer(cal_scores, cal_gt_masks, 0.05);

%%
CI_error(threshold, val_scores, val_gt_masks)

%%
alpha_vals = 0.005:0.005:0.1;
record_thresh = zeros(1,length(alpha_vals));
for I = 1:length(alpha_vals)
    alpha = alpha_vals(I)
    threshold = prctile(max_vals, 100 * (1 - alpha));
    record_thresh(I) = CI_error(threshold, val_scores, val_gt_masks);
end

%% Calculate bernstds
lowerintervals = zeros(1,length(alpha_vals));
upperintervals = zeros(1,length(alpha_vals));

for I = 1:length(alpha_vals)
    alpha = alpha_vals(I)
    [ interval, std_error ] = bernstd( alpha, 1298, 0.95 );
    lowerintervals(I) = interval(1);
    upperintervals(I) = interval(2);
end

%%
plot(alpha_vals, record_thresh, 'LineWidth', 4)
hold on
plot(alpha_vals, alpha_vals, '--', 'Color', [0.5,0.5,0.5], 'LineWidth', 4)
% plot(alpha_vals, upperintervals, '--', 'Color', [0.5,0.5,0.5], 'LineWidth', 2)
matniceplot
BigFont(22)
title('Error Rate')
xlabel('\alpha')
ylabel('Error')

%%
