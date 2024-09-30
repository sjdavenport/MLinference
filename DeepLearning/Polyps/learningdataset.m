loadpolypsdata

%% dist scores
scores_dist = zeros(size(scores));

recordshows = [];
for I = 1:size(scores, 3)
    I
    score_im = scores(:,:,I);
    maskim = score_im > 0.5;
    if sum(maskim(:)) > 0
        recordshows = [recordshows, I];
        scores_dist(:,:,I) = dtmask( maskim );
        % scores_dist(:,:,I) = dist2maskbndry( mask_im );
    end
end
recordnoshows = setdiff(1:1798, recordshows);

%% dist scores2
scores_dist2 = zeros(size(scores));

recordshows = [];
for I = 1:size(scores, 3)
    I
    score_im = scores(:,:,I);
    maskim = score_im > 0.7;
    if sum(maskim(:)) > 0
        recordshows = [recordshows, I];
        scores_dist2(:,:,I) = dtmask( maskim );
        % scores_dist(:,:,I) = dist2maskbndry( mask_im );
    end
end
recordnoshows = setdiff(1:1798, recordshows);


%%
rng(2, 'twister')
learning_idx = randsample(1798, 298);

learning_scores = scores(:,:,learning_idx);
learning_masks = gt_masks(:,:,learning_idx);

[threshold_inner, max_vals_inner] = CI_fwer(learning_scores, learning_masks, 0.1);
[threshold_outer, max_vals_outer] = CI_fwer(1-learning_scores, 1-learning_masks, 0.1);

%%
ncc_pred_learn = zeros(1, 298);

for I = 1:298
    ncc_pred_learn(I) = numOfConComps(learning_masks(:,:,I), 0.5);
end

%%
learning_scores_dist = scores_dist(:,:,learning_idx);
% learning_scores_dist2 = scores_dist2(:,:,learning_idx);

[threshold_inner_dt, max_vals_inner] = CI_fwer(learning_scores_dist, learning_masks, 0.1);
[threshold_outer_dt, max_vals_outer] = CI_fwer(-learning_scores_dist, 1-learning_masks, 0.1);

%% Learning orignal scores plot
close all
[ scoresinmask, scoresoutofmask] = mask_scores( learning_scores, learning_masks );
h = histogram(scoresoutofmask, 'Normalization','probability')
h.BinWidth = 0.015;
matnicehist('white')
hold on
h = histogram(scoresinmask, 'Normalization','probability');
h.BinWidth = 0.015;
matnicehist('white')

plot([threshold_inner, threshold_inner], [0,0.25], '--', 'LineWidth', 6, 'color', 'red')
plot([1-threshold_outer, 1-threshold_outer], [0,0.25], '--', 'LineWidth', 6, 'color', 'blue')
xlabel('scores')
ylabel('density')
title('Original scores')
BigFont(50)
ylim([0,0.25])
surfscreen
snshot('origscores', 1, '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/hist_scores/')

%% Learning distance transformed scores plot
[ scoresinmask, scoresoutofmask] = mask_scores( learning_scores_dist, learning_masks );
h = histogram(scoresoutofmask(scoresoutofmask ~= 0), 'Normalization','probability')
h.BinWidth = 8;
matnicehist('white')
hold on
h = histogram(scoresinmask(scoresinmask ~= 0), 'Normalization','probability');
h.BinWidth = 8;
matnicehist('white')

plot([threshold_inner_dt, threshold_inner_dt], [0,0.25], '--', 'LineWidth', 6, 'color', 'red')
plot([-threshold_outer_dt, -threshold_outer_dt], [0,0.25], '--', 'LineWidth', 6, 'color', 'blue')
% legend('Scores outside the masks', 'Scores inside the masks', 'Inner 90% threshold', 'Outer 90% threshold')
xlabel('scores')
ylabel('density')
title('Distance transformed scores')
BigFont(50)
surfscreen
snshot('distscores', 1, '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/hist_scores/')

% print(gcf, '-dpdf', '/Users/sdavenport/Documents/Other/Figures/scoredist.pdf'); 

%% BT scores
%%
learning_scores_dist_bt = scores_dist_bt(:,:,learning_idx);
% learning_scores_dist2 = scores_dist2(:,:,learning_idx);

[threshold_inner_bt, max_vals_inner] = CI_fwer(learning_scores_dist_bt, learning_masks, 0.1);
[threshold_outer_bt, max_vals_outer] = CI_fwer(-learning_scores_dist_bt, 1-learning_masks, 0.1);


%% Learning distance transformed scores plot
[ scoresinmask, scoresoutofmask] = mask_scores( learning_scores_dist_bt, learning_masks );
h = histogram(scoresoutofmask(scoresoutofmask ~= 0), 'Normalization','probability')
h.BinWidth = 8;
matnicehist('white')
hold on
h = histogram(scoresinmask(scoresinmask ~= 0), 'Normalization','probability');
h.BinWidth = 8;
matnicehist('white')

plot([threshold_inner_bt, threshold_inner_bt], [0,0.25], '--', 'LineWidth', 6, 'color', 'red')
plot([-threshold_outer_bt, -threshold_outer_bt], [0,0.25], '--', 'LineWidth', 6, 'color', 'blue')
% legend('Scores outside the masks', 'Scores inside the masks', 'Inner 90% threshold', 'Outer 90% threshold')
legend('Scores outside the masks', 'Scores inside the masks', 'Inner 90% threshold', 'Outer 90% threshold', 'Location', 'NW')
xlabel('scores')
ylabel('density')
title('Bounding box scores')
BigFont(50)
surfscreen
ylim([0,0.25])
xlim([-400,120])
snshot('btscores', 1, '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/learning/hist_scores/')

% print(gcf, '-dpdf', '/Users/sdavenport/Documents/Other/Figures/scoredist.pdf'); 




%%
alpha = 0.01;
lamhat = fzero(@(x) lamhat_threshold(x, learning_scores, learning_masks, alpha), [0, 1]);

%% Risk control thresholds
[ scoresinmask, scoresoutofmask] = mask_scores( learning_scores, learning_masks );
h = histogram(scoresoutofmask, 'Normalization','probability')
h.BinWidth = 0.01;
matnicehist('white')
hold on
h = histogram(scoresinmask, 'Normalization','probability');
h.BinWidth = 0.01;
matnicehist('white')

plot([lamhat, lamhat], [0,0.18], '--', 'LineWidth', 3, 'color', 'blue')

%%
df = 15;
subplot(1,2,1)
imagesc(learning_masks(:,:,I))
subplot(1,2,2)
imagesc(dilate_mask(learning_masks(:,:,I),df))
dilated_masks = zeros(size(gt_masks));
for I = 1:1798

end

%%

for I = 1:298
    I
    score_im = learning_scores(:,:,I);
    dt_score_im = learning_scores_dist(:,:,I);
    adj_score_im = score_im;
    adj_score_im()
    % adj_score_im(score_im < 0.5) = score_im(score_im < 0.5)./(-dt_score_im(score_im < 0.5) +1);
    % adj_score_im(score_im < 0.5) = score_im(score_im < 0.5)./((dt_score_im(score_im < 0.5).^2)/10000 +1);
end

%%
surf(adj_score_im)

%%
surf(score_im./(dt_score_im +1))

%% Learn 2D 
subplot(1,2,1)
histogram(ncc(learning_idx))
subplot(1,2,2)
histogram(ncc_pred(learning_idx))

%%
CI_fwer(1-learning_scores(:,:,ncc_pred_learn > 1), 1-learning_masks(:,:,ncc_pred_learn > 1), 0.1)

%%
CI_fwer(-learning_scores_dist2(:,:,ncc_pred_learn > 1), 1-learning_masks(:,:,ncc_pred_learn <= 1), 0.1)

%%
CI_fwer(-learning_scores_dist, 1-learning_masks, 0.1)

%%
CI_fwer(-learning_scores_dist, 1-learning_masks, 0.1)

%% Have a look
for id = find(ncc_pred_learn > 1)
subplot(1,4,1)
imagesc(learning_masks(:,:,id))
subplot(1,4,2)
imagesc(learning_scores(:,:,id) > 0.7)
% imagesc(1-((1-learning_scores(:,:,id)) > 0.9393))
% imagesc(learning_scores_dist(:,:,id) > -35.8)
subplot(1,4,3)
surf(learning_scores(:,:,id), 'EdgeAlpha', 0.1)
subplot(1,4,4)
surf(learning_scores_dist(:,:,id), 'EdgeAlpha', 0.1)
fullscreen
pause
end
