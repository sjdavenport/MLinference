function [probabilities] = softmaxfn(logits)
    % Ensure numerical stability by subtracting the maximum value
    %logits = logits - max(logits);
    
    % Compute softmax
    exp_logits = exp(logits);
    probabilities = exp_logits ./ sum(exp_logits, 3);
end
