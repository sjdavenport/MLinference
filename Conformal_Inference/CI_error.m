function error_rate = CI_error(threshold, scores, masks)
    % CIerror calculates the error rate based on conformal inference familywise error rate inference.
    %
    % Args:
    % - threshold: The threshold value for controlling the FWER.
    % - scores: A 3D array representing the statistical scores, where the last
    %           dimension corresponds to different images or samples.
    % - masks: A 3D binary array indicating the mask for each image or sample
    %          in 'scores'. It should have the same dimensions as 'scores'.
    % - opt1: Optional parameter (default value is 0).
    %
    % Returns:
    % - error_rate: The computed error rate value.
    
    % Main Function Loop
    s_scores = size(scores);
    n_images = s_scores(end);
    error_rate = 0;
    
    for I = 1:n_images
        thresholded_score = scores(:,:,I) > threshold;
        no_lesion_mask = 1 - masks(:,:,I);
        
        if any(thresholded_score(:).*no_lesion_mask(:))
            error_rate = error_rate + 1;
        end
    end
    
    error_rate = error_rate / n_images;
end
