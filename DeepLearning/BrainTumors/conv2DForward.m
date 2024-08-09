function dataOut = conv2DForward(layer, dataIn)
    %EX: convolution2DForward(net.Layers(2), dlarray(double(I), 'SSCB'))
    weights = layer.Weights;
    bias = layer.Bias;
    % Get the convolutional layer parameters
    % padding = layer.PaddingSize;
    padding_size = layer.PaddingSize;
    padding_value = layer.PaddingValue;
    stride = layer.Stride;
    dilfactor = layer.DilationFactor;
    % Apply convolution
    dataOut = dlconv(dataIn, weights, bias, 'Padding', padding_size, 'PaddingValue', padding_value, 'Stride', stride, 'DilationFactor', dilfactor);
end
