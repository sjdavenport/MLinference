classdef PassthroughLayer < nnet.layer.Layer
    methods
        function layer = PassthroughLayer(name)
            % Set layer name
            layer.Name = name;
            % Set layer description
            layer.Description = 'Passthrough layer';
        end
        
        function Z = predict(~, X)
            % Forward input data through the layer
            Z = X;
        end
    end
end
