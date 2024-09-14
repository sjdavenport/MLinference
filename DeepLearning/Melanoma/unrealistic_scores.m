%%
dtscores_unreal = zeros([128,128,2594]);
for I = 1:2594
    I
    dtscores_unreal(:,:,I) = dtmask( masks(:,:,I) > 0.5 );
end

%% CI on the unreal dtscores
% Generate inner sets
[threshold_inner_unreal, max_vals_inner] = CI_fwer(dtscores_unreal(:,:,1:1500), masks(:,:,1:1500), 0.1);

% Generate outer sets
[threshold_outer_unreal, max_vals_outer] = CI_fwer(-dtscores_unreal(:,:,1:1500), 1-masks(:,:,1:1500), 0.1);

%%
for id = 1:10
    orig_im = images(:,:,:,id);
    score_im = dtscores_unreal(:,:,id);
    orig_mask = masks(:,:,id)>0;

    predicted_inner = score_im > threshold_inner_unreal;
    predicted_outer = 1 - (-score_im > threshold_outer_unreal);

    subplot(1,2,1)
    cr_plot(predicted_inner, predicted_outer, orig_mask)
    % imagesc(score_im > 0.9)
    axis off image
    subplot(1,2,2)
    imagesc(orig_im)
    axis off image
    fullscreen
    pause
end