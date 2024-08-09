function dataOut = convolution2DForward(layer, dataIn)
    weights = layer.Weights;
    bias = layer.Bias;
    % Get the convolutional layer parameters
    padding = layer.PaddingSize;
    stride = layer.Stride;
    % Apply convolution
    dataOut = dlconv(dataIn, weights, bias, 'Padding', padding, 'Stride', stride);
end

function dataOut = maxPooling2DForward(layer, dataIn)
    % Get the pooling layer parameters
    poolSize = layer.PoolSize;
    stride = layer.Stride;
    padding = layer.PaddingSize;
    % Apply max pooling
    dataOut = maxpool(dataIn, poolSize, 'Stride', stride, 'Padding', padding);
end

function dataOut = transposedConvolution2DForward(layer, dataIn)
    weights = layer.Weights;
    bias = layer.Bias;
    % Get the transposed convolution layer parameters
    crop = layer.CroppingSize;
    upsample = layer.Stride;
    % Apply transposed convolution
    dataOut = dltranspconv(dataIn, weights, bias, 'Cropping', crop, 'Stride', upsample);
end
