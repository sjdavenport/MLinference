rng(2, 'twister')
learning_idx = randsample(1798, 298);
non_learning_idx = setdiff(1:1798, learning_idx);

%%
rng(5, 'twister')

cal_sample = randsample(1500, 1000);
val_sample = setdiff(1:1500, cal_sample);
cal_idx = non_learning_idx(cal_sample);
val_idx = non_learning_idx(val_sample);

cal_scores = scores(:,:,cal_idx);
cal_scores_dist = scores_dist(:,:,cal_idx);
cal_masks = gt_masks(:,:,cal_idx);
val_scores = scores(:,:,val_idx);
val_scores_dist = scores_dist(:,:,val_idx);
val_masks = gt_masks(:,:,val_idx);


ncc_pred_cal = zeros(1, 1000);
ncc_pred_val = zeros(1, 500);

for I = 1:1000
    ncc_pred_cal(I) = numOfConComps(cal_masks(:,:,I), 0.5);
end
for I = 1:500
    ncc_pred_val(I) = numOfConComps(val_masks(:,:,I), 0.5);
end

%%
CI_fwer(-scores_dist(:,:,find(ncc_pred_cal >1)), 1-gt_masks(:,:,find(ncc_pred_cal > 1)), 0.1)

%%
CI_fwer(-cal_scores_dist(:,:,ncc_pred_cal <= 1), 1-cal_masks(:,:,ncc_pred_cal <= 1), 0.1)

%%
CI_fwer(-cal_scores_dist, 1-cal_masks, 0.1)

%%
CI_fwer(-scores_dist(:,:,ncc_pred <= 1), 1-gt_masks(:,:,ncc_pred <= 1), 0.1)
