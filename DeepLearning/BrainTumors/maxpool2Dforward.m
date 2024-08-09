function dataOut = maxpool2Dforward(layer, dataIn)
    % Get the pooling layer parameters
    poolSize = layer.PoolSize;
    stride = layer.Stride;
    padding = layer.PaddingSize;
    % Apply max pooling
    dataOut = maxpool(dataIn, poolSize, 'Stride', stride, 'Padding', padding);
end