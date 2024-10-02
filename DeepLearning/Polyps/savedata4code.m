codeloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/code4submission/';

scores_resized = imresize3(scores, [50,50,1798], 'nearest');
scores_DT_resized = imresize3(scores_dist, [50,50,1798], 'nearest');
scores_BB_outer_resized = imresize3(scores_dist_bt_outer, [50,50,1798], 'nearest');
scores_BB_inner_resized = imresize3(scores_dist_bt_inner, [50,50,1798], 'nearest');
gt_masks_resized = imresize3(gt_masks, [50,50,1798], 'nearest');
bb_masks_resized = imresize3(box_gt, [50,50,1798], 'nearest');

save([codeloc, 'scores.mat'], 'scores_resized')
save([codeloc, 'scores_DT.mat'], 'scores_DT_resized')
save([codeloc, 'scores_BB.mat'], 'scores_BB_outer_resized', 'scores_BB_inner_resized')
save([codeloc, 'gt_masks.mat'], 'gt_masks_resized')
save([codeloc, 'gt_masks_bb.mat'], 'bb_masks_resized')
%%

save([codeloc, 'scores.mat'], 'scores')
save([codeloc, 'scores_DT.mat'], 'scores_dist')
save([codeloc, 'scores_BB.mat'], 'scores_dist_bt_outer', 'scores_dist_bt_inner')
save([codeloc, 'gt_masks.mat'], 'gt_masks')
save([codeloc, 'gt_masks_bb.mat'], 'box_gt')
