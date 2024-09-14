netdir = '/Users/sdavenport/Documents/MATLAB/Examples/R2024a/images_deeplearning/Segment3DBrainTumorsUsingDeepLearningExample';
a = load(fullfile(netdir,"brainTumorSegmentation3DUnet_v2.mat"));

newnet = swap_layer2(a.trainedNet);
clear a

%%
% Brain image directory
datadir =  '/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/images/';

% Go to the save directory
cd('/Users/sdavenport/Documents/Data/SegmentationData/Task01_BrainTumour/preprocessed_data/scores');

% Calculate the scores!
for id = 299:482
    id
    % Generate id string
    idstrtemp = num2str(id);
    idstr = '000';
    if id < 10
        idstr(end) = idstrtemp;
    elseif id < 100
        idstr(end-1:end) = idstrtemp;
    else
        idstr = idstrtemp;
    end

    % Load in the image
    % im = niftiread([datadir, 'BRATS_', idstr]);
    a = load([datadir, 'BRaTS', idstr]);
    orig_im = a.cropVol;
    clear a;
    im = pad_im( orig_im, [25,25,25,0] );

    %
    global savescores
    savescores = 1;
    classNames = ["background","tumor"];
    [C, scores, allScores] = semanticseg(im,newnet,Classes=classNames);

    system(['mv scores.mat scores_', num2str(id), '.mat'])
end