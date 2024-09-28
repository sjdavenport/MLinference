function [ boxdist ] = bb_dist( box1, box2 )
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
% box1 = zeros(40,40);
% box1(10:20, 10:20) = 1;
% box2 = zeros(40,40);
% box2(25:35, 16:25) = 1;
% [ out ] = bb_dist( box1, box2 )
%
% box1 = zeros(40,40);
% box1(10:30, 10:30) = 1;
% box2 = zeros(40,40);
% box2(15:25, 15:25) = 1;
% [ out ] = bb_dist( box1, box2 )
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
boundaries_1 = get_bndries(box1);
boundaries_2 = get_bndries(box2);

boxdist = zeros(1,4);

rlnames = {'right', 'left'};
for btype = 1:2
    box1boundary = boundaries_1.(rlnames{btype});
    locs1 = find(box1boundary);
    clocs1 = convind(locs1(1), size(box1));
    box2boundary = boundaries_2.(rlnames{btype});
    locs2 = find(box2boundary);
    clocs2 = convind(locs2(1), size(box2));
    boxdist(btype) = clocs1(2) - clocs2(2);
end

udnames = {'upper', 'lower'};
for btype = 1:2
    box1boundary = boundaries_1.(udnames{btype});
    locs1 = find(box1boundary);
    clocs1 = convind(locs1(1), size(box1));
    box2boundary = boundaries_2.(udnames{btype});
    locs2 = find(box2boundary);
    clocs2 = convind(locs2(1), size(box2));
    boxdist(btype+2) = clocs1(1) - clocs2(1);
end
boxdist = boxdist.*[-1,1,-1,1];

end


