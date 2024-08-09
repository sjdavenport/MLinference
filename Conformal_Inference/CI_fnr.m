function fnr = CI_fnr(pred_masks, true_masks)
    intersection = sum(sum(pred_masks .* true_masks, 2), 1);
    true_sum = sum(sum(true_masks, 2), 1);
    fnr = 1 - mean(intersection ./ true_sum);
end
