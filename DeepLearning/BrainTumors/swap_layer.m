function [ newNet ] = swap_layer( net )
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
layers = layerGraph(net.Layers);

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

% layers = connectLayers(layers, layers.Connections.Source, layers.Connections.Destination);
source_layers = net.Connections.Source;
destination_layers = net.Connections.Destination;
for i = 1:length(source_layers) % Iterate through layers except the last one
    % Get source and destination layer names
    if i == 8
       a = 4 
    end
    try
        i
        sourceName = source_layers{i};
        destName = destination_layers{i};
        if strcmp(destName(end-2:end), '/in')
            destName = destName(1:end-3);
        end
        if strcmp(destName, 'encoderDecoderSkipConnectionCrop1')

        end
        layers = connectLayers(layers, sourceName, destName);
    end
end

% Create a new dlnetwork with the modified layers
newNet = dlnetwork(layers);

end

