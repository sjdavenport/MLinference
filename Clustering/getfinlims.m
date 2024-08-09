function [ xvals ] = getfinlims( data, nincrem )
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
xmin = min(data(:,1));
xmax = max(data(:,1));

ymin = min(data(:,2));
ymax = max(data(:,2));

xvals = {linspace(xmin, xmax, nincrem), linspace(ymin, ymax, nincrem)};

end

