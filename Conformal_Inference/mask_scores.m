function [ scoresinmask, scoresoutofmask] = mask_scores( scores, masks )
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

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
nimages = size(scores, 3);

scoresinmask = [];
scoresoutofmask = [];

for I = 1:nimages
    modul(I,100)
    score_im = scores(:,:,I);
    mask_im = masks(:,:,I);
    
    scoresinmask = [scoresinmask; score_im(mask_im > 0)];
    scoresoutofmask = [scoresoutofmask; score_im((1-mask_im) > 0 )];
end

end

