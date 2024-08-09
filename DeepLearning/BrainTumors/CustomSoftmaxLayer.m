classdef CustomSoftmaxLayer < nnet.layer.Layer & nnet.layer.Formattable
    properties
        % Layer learnable parameters
    end
    
    methods
        function layer = CustomSoftmaxLayer(name)
            % Create a custom softmax layer
            layer.Name = name;
            layer.Description = 'Custom softmax layer';
        end
        
        function Z = predict(layer, X)
            % Forward input data through the layer and output the result
            try
                global savescores
                if savescores == 1
                    save('scores', 'X');
                end
            end
            Z = softmax(X);
        end

        function dLdX = backward(layer, X, Z, dLdZ, ~)
            % Backward propagate the derivative of the loss function
            % through the layer
            numClasses = size(Z, 3);
            dLdX = zeros(size(X), 'like', X);

            for i = 1:numClasses
                for j = 1:numClasses
                    if i == j
                        dLdX(:,:,i,:) = dLdX(:,:,i,:) + dLdZ(:,:,j,:) .* Z(:,:,i,:) .* (1 - Z(:,:,i,:));
                    else
                        dLdX(:,:,i,:) = dLdX(:,:,i,:) - dLdZ(:,:,j,:) .* Z(:,:,i,:) .* Z(:,:,j,:);
                    end
                end
            end
        end
    end
end
