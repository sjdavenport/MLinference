% Assume net is your existing dlnetwork object
layers = layerGraph(net2.Layers);

% Extract the layer to modify
layerToModify = layers.Layers(9);

% Modify the layer as needed
% For example, let's assume you want to change the number of filters in a convolutional layer
newLayer = CustomSoftmaxLayer('custom_softmax');

% Ensure newLayer has the same name as the old layer to avoid issues
newLayer.Name = layerToModify.Name;

% Replace the 9th layer in the layer graph with the modified layer
layers = replaceLayer(layers, layerToModify.Name, newLayer);

% Create a new dlnetwork with the modified layers
newNet = dlnetwork(layers);

%%
[testseg, scores, allscores] = semanticseg(imgTest,newNet);
imagesc(allscores(:,:,1))