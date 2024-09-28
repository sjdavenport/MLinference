loadpolypsdata

%% Count gt concomps
nnc = zeros(1, 1798);
ncc_pred = zeros(1, 1798);
for I = 1:1798
    I
    ncc(I) = numOfConComps(gt_masks(:,:,I), 0.5);
    ncc_pred(I) = numOfConComps(scores(:,:,I) > 0.5, 0.5);
end
twolocs = find(ncc > 1);
twolocspred = find(ncc_pred > 1);

%%
gt_outer_boxes = zeros(size(gt_masks));
gt_inner_boxes = zeros(size(gt_masks));

for I = 1:1798
    I
    mask = gt_masks(:,:,I);
    gt_inner_boxes(:,:,I) = largest_inner_box(mask);
    gt_outer_boxes(:,:,I) = bounding_box(mask);
end

%%
for I = 1:1798
    if gt_masks(1,1,I) == 1
        I
        imagesc(gt_masks(:,:,I))
        fullscreen
        pause
    end
end

%%
imagesc(gt_masks(:,:,109))

%%
testbox = bounding_box(gt_masks(:,:,629))
%%
sum(gt_masks(:,:,629), 2)

%%
predicted_outer_boxes = zeros(size(gt_masks));
predicted_inner_boxes = zeros(size(gt_masks));

for I = 1:1798
    I
    predicted_mask = scores(:,:,I) > 0.5;
    if sum(predicted_mask(:)) > 0
        predicted_inner_boxes(:,:,I) = largest_inner_box(predicted_mask);
        predicted_outer_boxes(:,:,I) = bounding_box(predicted_mask);
    else
        predicted_outer_boxes(:,:,I) = ones(352,352);
        % predicted_outer_boxes(:,:,I) = ones(352,352);
    end
end

%% HAve a look
for id = 1701
subplot(1,4,1)
imagesc(predicted_outer_boxes(:,:,id))
subplot(1,4,2)
imagesc(scores(:,:,id) > 0.5)
subplot(1,4,3)
imagesc(gt_outer_boxes(:,:,id))
subplot(1,4,4)
imagesc(gt_masks(:,:,id))
fullscreen
pause
end

%%
bb_dist( predicted_outer_boxes(:,:,1701),  gt_outer_boxes(:,:,1701))

%% Calculate the distance in each direction from the predicted to the true boxes
outer_distances = zeros(4, 1798);
inner_distances = zeros(4, 1798);
for I = 1:1798
    I
    predicted_mask = scores(:,:,I) > 0.5;
    if sum(predicted_mask(:)) > 0
        absouterdist = bb_dist( predicted_outer_boxes(:,:,I),  gt_outer_boxes(:,:,I));
        absinnerdist = bb_dist( predicted_inner_boxes(:,:,I),  gt_inner_boxes(:,:,I));
        outer_distances(:,I) = absouterdist';
        inner_distances(:,I) = absinnerdist';
    else
        % outer_distances(:,I) = 500;
        absouterdist = bb_dist( predicted_outer_boxes(:,:,I),  gt_outer_boxes(:,:,I));
        % outer_distances(:,I) = 500;
        inner_distances(:,I) = 500;
    end
end

%%
histogram(outer_distances(4,:))

%%
find(outer_distances(4,:)> 200)

%%
ods = outer_distances(4,:);
ids = inner_distances(4,:);
max_od = zeros(1,1798);
max_id = zeros(1,1798);
for I = 1:1798
    max_od(I) = max(outer_distances(:,I));
    max_id(I) = max(inner_distances(:,I));
end
threshold = prctile(ods(ids~=500), 100 * (1 - 0.1))
% threshold = prctile(max(outer_distances(:, ids~=500),2), 100 * (1 - 0.1))

%%
threshold = prctile(max_od(max_od~=500), 100 * (1 - 0.1))

%%
ods = outer_distances(4,:);
ids = inner_distances(4,:);
max_od = zeros(1,1798);
min_id = zeros(1,1798);
for I = 1:1798
    max_od(I) = max(outer_distances(:,I));
    min_id(I) = min(inner_distances(:,I));
end
threshold = prctile(ods(ids~=500), 100 * (1 - 0.1))
% threshold = prctile(max(outer_distances(:, ids~=500),2), 100 * (1 - 0.1))

%%
threshold = prctile(max_od(max_od~=500), 100 * (1 - 0.1))

%%
threshold = prctile(-min_id(max_od~=500), 100 * (1 - 0.1))

%%
max_od_single_component = max_od(setdiff(1:1798,twolocspred));
threshold = prctile(max_od_single_component(max_od_single_component~=500), 100 * (1 - 0.1))

%%
min_id_single_component = min_id(setdiff(1:1798,twolocspred));
threshold = prctile(-min_id_single_component(max_od_single_component~=500), 100 * (1 - 0.1))

%%
add_region({ones(352,352), gt_masks(:,:,43), gt_inner_boxes(:,:,43)}, {'black', 'yellow', 'red'})

%%
outerdiff = gt_outer_boxes(:,:,other_idx) - gt_masks(:,:,other_idx);
sum(outerdiff(:) > 0)/(352^2)/1500

%%
outerdiff = predicted_outer_boxes(:,:,other_idx) - gt_masks(:,:,other_idx);
sum(outerdiff(:) > 0)/(352^2)/1500

%%
dm_masks = scores_dist > -16;
outerdiff = dm_masks(:,:,other_idx) - gt_masks(:,:,other_idx);
sum(outerdiff(:) > 0)/(352^2)/1500

%%
for I = 1:length(other_idx)
    subplot(1,2,1)
    imagesc(gt_masks(:,:,other_idx(I)))
    subplot(1,2,2)
    imagesc(gt_outer_boxes(:,:,other_idx(I)))
    diffim = (gt_outer_boxes(:,:,other_idx(I)) - gt_masks(:,:,other_idx(I)))
    sum(diffim(:) > 0)
    pause
end

%%
for I = 1:length(other_idx)
    subplot(1,3,1)
    imagesc(gt_outer_boxes(:,:,other_idx(I)))
    subplot(1,3,2)
    imagesc(gt_masks(:,:,other_idx(I)))
    subplot(1,3,3)
    dm = scores_dist(:,:,other_idx(I)) > -16;
    imagesc(dm)
    diffim = (gt_outer_boxes(:,:,other_idx(I)) - gt_masks(:,:,other_idx(I)));
    sum(diffim(:) > 0)
    diffim = (dm - gt_masks(:,:,other_idx(I)));
    sum(diffim(:) > 0)
    pause
end

%%
% CI_fwer(1-scores, 1-gt_masks, 0.1)
 
%%
CI_fwer(-scores_dist(:,:,setdiff(1:1798,twolocspred)), 1-gt_masks(:,:,setdiff(1:1798,twolocspred)), 0.1)
CI_fwer(-scores_dist(:,:,twolocspred), 1-gt_masks(:,:,twolocspred), 0.1)

%%
CI_fwer(-scores_dist, 1-gt_masks, 0.1)

