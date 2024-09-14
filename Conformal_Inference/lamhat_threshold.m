function result = lamhat_threshold(lam, scores, gt_masks, alpha)
    % LAMHAT_THRESHOLD calculates the difference between the false negative rate
    % and a threshold based on the given lambda.
    %
    % Args:
    % - lam: The threshold lambda value.
    %
    % Returns:
    % - result: The calculated result.
    
    % Compute the false negative rate using the lambda threshold
    fnr = CI_fnr(scores >= lam, gt_masks);
    
    s_scores = size(scores);
    n_images = s_scores(end);

    % Calculate the result by subtracting the threshold expression
    result = fnr - ((n_images + 1)/n_images*alpha - 1 / n_images);
end
