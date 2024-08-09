function dataOut = tconv2Dforward(layer, dataIn)
    weights = layer.Weights;
    bias = layer.Bias;
    % Get the transposed convolution layer parameters
    crop = layer.CroppingSize;
    upsample = layer.Stride;
    % Apply transposed convolution
    dataOut = dltranspconv(dataIn, weights, bias, 'Cropping', crop, 'Stride', upsample);
end
