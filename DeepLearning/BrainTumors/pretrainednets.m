pretrainedURL = "https://ssd.mathworks.com/supportfiles/vision/data/deeplabv3plusResnet18CamVid_v2.zip";
pretrainedFolder = fullfile(tempdir,"pretrainedNetwork");
pretrainedNetworkZip = fullfile(pretrainedFolder,"deeplabv3plusResnet18CamVid_v2.zip"); 
if ~exist(pretrainedNetworkZip,'file')
    mkdir(pretrainedFolder);
    disp("Downloading pretrained network (58 MB)...");
    websave(pretrainedNetworkZip,pretrainedURL);
end

%%
unzip(pretrainedNetworkZip, pretrainedFolder)

%%
pretrainedNetwork = fullfile(pretrainedFolder,"deeplabv3plusResnet18CamVid_v2.mat");  
data = load(pretrainedNetwork);
net = data.net;

%%
classes = getClassNames()

%%
I = imread("parkinglot_left.png");

%%
% Access the trained model
[net, classes] = imagePretrainedNetwork("resnet18");

% See details of the architecture
net.Layers

% Read the image to classify
I = imread('peppers.png');

% Adjust size of the image
sz = net.Layers(1).InputSize
I = I(1:sz(1),1:sz(2),1:sz(3));

% Classify the image using ResNet-18
scores = predict(net, single(I));
label = scores2label(scores, classes)

% Show the image and the classification results
figure
imshow(I)
text(10,20,char(label),'Color','white')

%%
net = squeezenet;
I = imread("peppers.png");

act = activations(net,I,"fire2-squeeze1x1");

act = mat2gray(act);
act = imtile(act);
figure
imshow(act)