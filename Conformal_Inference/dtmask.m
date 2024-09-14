function [ distmask ] = dtmask( mask )
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
distmask = bwdist(1-mask, 'euclidean') - bwdist(mask, 'euclidean') - mask;
% distmask = bwdist(1-mask, 'cityblock') - bwdist(mask, 'cityblock') - mask;

end

