function [ newNet ] = swap_layer2( net )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
% Assume net is your existing dlnetwork object
% layers = dlnetwork(net.Layers, initialize = false);
layers = layerGraph();

for i = 1:numel(net.Layers)
    % layerName = net.Layers(i).Name;
    layers = addLayers(layers, net.Layers(i));
end

% layers = connectLayers(layers, layers.Connections.Source, layers.Connections.Destination);
source_layers = net.Connections.Source;
destination_layers = net.Connections.Destination;

for i = 1:length(source_layers) % Iterate through layers except the last one
    % Get source and destination layer names
    sourceName = source_layers{i};
    destName = destination_layers{i};
    layers = connectLayers(layers, sourceName, destName);
end

% Extract the layer to modify
nlayers = length(net.Layers);
layerToModify = layers.Layers(nlayers);

% Modify the layer as needed
% For example, let's assume you want to change the number of filters in a convolutional layer
% newLayer = CustomSoftmaxLayer('custom_softmax');
newLayer = CustomSoftmaxLayer('FinalNetworkSoftmax-Layer');

% Ensure newLayer has the same name as the old layer to avoid issues
newLayer.Name = layerToModify.Name;

% Replace the 9th layer in the layer graph with the modified layer
layers = replaceLayer(layers, layerToModify.Name, newLayer);

% Create a new dlnetwork with the modified layers
newNet = dlnetwork(layers);

end

