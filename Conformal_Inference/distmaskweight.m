function [ weighted_mask ] = distmaskweight( mask )
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
weighted_mask = mask;
stuffstillinmask = (sum(mask(:)) > 0);
I = 0;
while stuffstillinmask
    I = I+1;
    dilated_mask = dilate_mask(mask, -I);
    stuffstillinmask = (sum(dilated_mask(:)) > 0);
    weighted_mask = weighted_mask + dilated_mask;
end
outsize_mask = (1 - mask)>0;  

weighted_mask = outside_mask;
stuffstillinmask = (sum(outsize_mask(:)) > 0);
I = 0;
while stuffstillinmask
    I = I+1;
    dilated_mask = dilate_mask(outsize_mask, -I);
    stuffstillinmask = (sum(dilated_mask(:)) > 0);
    weighted_mask = weighted_mask + dilated_mask;
end

end

