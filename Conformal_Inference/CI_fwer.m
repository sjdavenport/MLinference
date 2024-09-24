function [threshold, max_vals] = CI_fwer(scores, masks, alpha)
    % CI_FWER calculates the threshold for performing conformal inference
    % based familywise error rate inference.
    %
    % ARGUMENTS
    % scores: A 3D array representing the statistical scores, where the last
    %         dimension corresponds to different images or samples.
    % masks:  A 3D binary array indicating the mask for each image or sample
    %         in 'scores'. It should have the same dimensions as 'scores'.
    % alpha:  The significance level for controlling the FWER.
    % opt1:   Optional parameter, default value is 0.
    %
    % OUTPUT
    % threshold:  The computed threshold value that controls the FWER at the
    %             specified significance level 'alpha'.
    % max_vals:   An array containing the maximum values obtained after
    %             applying the masks to the scores for each image or sample.

    if nargin < 3
        alpha = 0.05; % Default value for alpha if not provided
    end

    s_scores = size(scores);
    nimages = s_scores(end);
    max_vals = zeros(1, nimages);

    for I = 1:nimages
        masked_image = squeeze(scores(:, :,I)) .* double((1 - squeeze(masks(:, :, I))));
        max_vals(I) = max(masked_image(:));
        % disp(max_vals(I))
        % subplot(1,2,1)
        % imagesc(masked_image)
        % subplot(1,2,2)
        % imagesc(masks(:, :, I))
        % pause
    end

    threshold = prctile(max_vals, 100 * (1 - alpha));
end
