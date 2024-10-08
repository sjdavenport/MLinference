function [ distmask ] = dtmask( mask, dtype )
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
% MNImask = imgload('MNImask');
% MNImask2D = MNImask(:,:,50);
% distmask = dtmask( imfill(MNImask2D, 'holes') );
% surf(distmask)
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'dtype', 'var' )
   % Default value
   dtype = 'euclidean';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
distmask = bwdist(1-mask, dtype) - bwdist(mask, dtype) - mask;
% distmask = bwdist(1-mask, 'cityblock') - bwdist(mask, 'cityblock') - mask;

end

