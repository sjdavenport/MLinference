loadpolypsdata

%% TFCE scores
scores_tfce_positive = zeros(size(scores));
scores_tfce_negative = zeros(size(scores));

for I = 1:size(scores, 3)
    I
    score_im = scores(:,:,I);
    scores_tfce_positive(:,:,I) = tfce(score_im - 0.5, 2,0.5,8,0.001);
    scores_tfce_negative(:,:,I) = tfce((1-score_im) - 0.5, 2,0.5,8,0.001);
end

save('tfce_scores', 'scores_tfce_positive', 'scores_tfce_negative')

%%
load('tfce_scores')

% Positive tfce scores
cal_scores_tfce_positive = scores_tfce_positive(:,:,idx(1:id2stop));
anal_scores_tfce_positive = scores_tfce_positive(:,:,idx(id2stop:end));
val_scores_tfce_positive = scores_tfce_positive(:,:,~idx);

% Negative tfce scores
cal_scores_tfce_negative = scores_tfce_negative(:,:,idx(1:id2stop));
anal_scores_tfce_negative = scores_tfce_negative(:,:,idx(id2stop:end));
val_scores_tfce_negative = scores_tfce_negative(:,:,~idx);


%% Examine the scores
subplot(1,3,1)
imagesc(scores(:,:,1))
subplot(1,3,2)
imagesc(scores_tfce_positive(:,:,1))
subplot(1,3,3)
imagesc(scores_tfce_negative(:,:,1))
fullscreen

% Generate inner sets
[threshold_tfce_inner, max_vals_tfce_inner] = CI_fwer(cal_scores_tfce_positive, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_tfce_outer, max_vals_tfce_outer] = CI_fwer(cal_scores_tfce_negative, 1-cal_gt_masks, 0.1);

% Joint inference
joint_tfce_max_vals = max(max_vals_tfce_inner,max_vals_tfce_outer);
alpha = 0.1;
threshold_joint = prctile(joint_tfce_max_vals, 100 * (1 - alpha))

%%
saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_joint';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 1:10
    I
    ex = val_ex_indices(I);
    tfce_positive_score_im = scores_tfce_positive(:,:,ex+1);
    tfce_negative_score_im = scores_tfce_negative(:,:,ex+1);
    % vec_scores =

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');
    % im_size = size(im);
    % im_size = im_size(1:2);

    % predicted_inner = scores(:,:,ex+1) > threshold;
    predicted_inner = tfce_positive_score_im > threshold_joint;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - (tfce_negative_score_im > threshold_joint);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    % imagesc(im); hold on

    % viewdata(im2double(im), ones(im_size), {predicted_inner, predicted_outer, im2double(true_mask(:,:,1))}, {'red', 'blue', 'yellow'});

    [~, ~, ~, components] = numOfConComps(predicted_outer, 0.5);
    relevant_outer_set = zeros(im_size);
    for I = 1:length(components)
        component_mask = cluster_im( im_size, components(I), 1 );
        if any(component_mask(:).*predicted_inner(:))
            relevant_outer_set = relevant_outer_set + component_mask;
        end
    end

    % subplot(1,2,1)
    % cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    cr_plot(predicted_inner, relevant_outer_set, imresize(true_mask(:,:,1), im_size, 'nearest'));
    axis off image
    saveim([num2str(ex), '.png'], [saveloc,'_', num2str(100*(1-alpha)), '_tfce/'])
    % size(predicted_inner)
    % subplot(1,2,2)
    % imagesc(im)
    % axis off image
    % saveim([num2str(ex), '.png'], savelocims)
    % fullscreen
    pause
    clf
end

%%
% Generate inner sets
[threshold_tfce_inner, max_vals_tfce_inner] = CI_fwer(cal_scores_tfce_positive, cal_gt_masks, 0.02);

% Generate outer sets
[threshold_tfce_outer, max_vals_tfce_outer] = CI_fwer(cal_scores_tfce_negative, 1-cal_gt_masks, 0.08);

%% Joint inference
joint_tfce_max_vals = max(max_vals_tfce_inner,max_vals_tfce_outer);
alpha = 0.1;
threshold_joint = prctile(joint_tfce_max_vals, 100 * (1 - alpha))

%%
saveloc = '/Users/sdavenport/Documents/MyPapers/0Papers/2024_crsegmentation/figures/val_crs_joint';
path4ims = '/Users/sdavenport/Documents/Data/SegmentationData/polyps/examples/';

im_size = [530,600];

for I = 11:40
    I
    ex = val_ex_indices(I);
    tfce_positive_score_im = scores_tfce_positive(:,:,ex+1);
    tfce_negative_score_im = scores_tfce_negative(:,:,ex+1);
    % vec_scores =

    true_mask = imread([path4ims, num2str(ex),'_gt_mask.jpg']);
    im = imread([path4ims, num2str(ex),'.jpg']);
    im = imresize(im, im_size, 'nearest');
    % im_size = size(im);
    % im_size = im_size(1:2);

    % predicted_inner = scores(:,:,ex+1) > threshold;
    predicted_inner = tfce_positive_score_im > threshold_tfce_inner;

    predicted_inner = imresize(predicted_inner, im_size, 'nearest');
    % predicted_outer = 1 - ((1-scores(:,:,ex+1)) > threshold_outer);
    predicted_outer = 1 - (tfce_negative_score_im > threshold_tfce_outer);
    predicted_outer = imresize(predicted_outer, im_size, 'nearest');

    % imagesc(im); hold on

    % viewdata(im2double(im), ones(im_size), {predicted_inner, predicted_outer, im2double(true_mask(:,:,1))}, {'red', 'blue', 'yellow'});

    [~, ~, ~, components] = numOfConComps(predicted_outer, 0.5);
    relevant_outer_set = zeros(im_size);
    for I = 1:length(components)
        component_mask = cluster_im( im_size, components(I), 1 );
        if any(component_mask(:).*predicted_inner(:))
            relevant_outer_set = relevant_outer_set + component_mask;
        end
    end

    % subplot(1,2,1)
    % cr_plot(predicted_inner, predicted_outer, imresize(true_mask(:,:,1), im_size, 'nearest'))
    cr_plot(predicted_inner, relevant_outer_set, imresize(true_mask(:,:,1), im_size, 'nearest'));
    axis off image
    % saveim([num2str(ex), '.png'], [saveloc,'_', num2str(100*(1-alpha)), '_tfce/'])
    % size(predicted_inner)
    % subplot(1,2,2)
    % imagesc(im)
    % axis off image
    % saveim([num2str(ex), '.png'], savelocims)
    % fullscreen
    pause
    clf
end