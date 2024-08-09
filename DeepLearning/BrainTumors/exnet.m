layers = [
    imageInputLayer([32 32 1]) % Input layer for 32x32 grayscale images
    %convolution2dLayer(1, z, 'Padding', 'same') % Convolutional layer with 16 filters of size 3x3
    %reluLayer % ReLU activation layer
    convolution2dLayer(1, 2)
    softmaxLayer
];

deepNetworkDesigner(layers);

%%
net = trainnet(cds,net_12,"crossentropy",options);

%%
[testseg, scores, allscores] = semanticseg(dlarray(double(I), 'SSCB'), net);
imagesc(allscores(:,:,1))

%%
Icentred = double(I) - mean(I(:));
% Icentred = Icentred/max(Icentred(:));
layer2out = conv2DForward(net.Layers(2), dlarray(Icentred, 'SSCB'));
layer3out = softmaxfn(layer2out);
output = extractdata(layer3out);
imagesc(nan2zero(output(:,:,1), 1))

%%
imagesc(squeeze(extractdata(layer2out(:,:,1,1))))

%%
surf(squeeze(extractdata(layer2out(:,:,1,1))))

%%
surf(squeeze(extractdata(layer2out(:,:,1,1))) - squeeze(extractdata(layer2out(:,:,2,1))))

%
imagesc(Icentred*0.844)

%%
imagesc(extractdata(layer3out(:,:,1)))

%%

%%
for J = 1:64
imagesc(extractdata(layer3out(:,:,J)))
pause
end

%% Increasing the complexity
layers = [
    imageInputLayer([32 32 1]) % Input layer for 32x32 grayscale images
    convolution2dLayer(3, 16, 'Padding', 'same')
    %convolution2dLayer(1, z, 'Padding', 'same') % Convolutional layer with 16 filters of size 3x3
    %reluLayer % ReLU activation layer
    convolution2dLayer(1, 2)
    softmaxLayer
];

deepNetworkDesigner(layers);

%%
net_morecomplex = trainnet(cds,net_15,"crossentropy",options);

%%
[testseg, scores, allscores] = semanticseg(dlarray(double(I), 'SSCB'), net_morecomplex);
imagesc(allscores(:,:,1))

%%
Icentred = double(I) - mean(I(:));
% Icentred = Icentred/max(Icentred(:));
layer2out = conv2DForward(net_morecomplex.Layers(2), dlarray(Icentred, 'SSCB'));
layer3out = conv2DForward(net_morecomplex.Layers(3), layer2out);
layer4out = softmaxfn(layer3out);
output = extractdata(layer4out);
imagesc(output(:,:,1))
%imagesc(nan2zero(output(:,:,1), 1))

%%
layers = [
    imageInputLayer([32 32 1])
    convolution2dLayer([3,3],64,Padding=[1,1,1,1])
    reluLayer
    convolution2dLayer(1, 2)
    softmaxLayer];

deepNetworkDesigner(layers)

%%
net_morecomplex2 = trainnet(cds,net_16,"crossentropy",options);

%%
[testseg, scores, allscores] = semanticseg(dlarray(double(I), 'SSCB'), net_morecomplex2);
imagesc(allscores(:,:,1))

%%
Icentred = double(I) - mean(I(:));
layer2out = conv2DForward(net_morecomplex2.Layers(2), dlarray(Icentred, 'SSCB'));
layer3out = relu(layer2out);
layer4out = conv2DForward(net_morecomplex2.Layers(4), layer3out);
layer5out = softmaxfn(layer4out);
output = extractdata(layer5out);
imagesc(output(:,:,1))

%%
layers = [
    imageInputLayer([32 32 1])
    convolution2dLayer([3,3],64,Padding=[1,1,1,1])
    reluLayer
    maxPooling2dLayer([2,2],Stride=[2,2])
    convolution2dLayer([3,3],64,Padding=[1,1,1,1])
    reluLayer
    convolution2dLayer([1,1],2)
    softmaxLayer];

deepNetworkDesigner(layers)

%%
net_morecomplex3 = trainnet(cds,net_17,"crossentropy",options);
