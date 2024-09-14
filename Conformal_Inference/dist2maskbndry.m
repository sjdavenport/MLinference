function [ distmask, mask_bndry ] = dist2maskbndry( mask, area2use )
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
% % 2D
% MNImask = imgload('MNImask');
% mask = squeeze(MNImask(40,:,:));
% [ distmask, mask_bndry ] = dist2maskbndry( mask )
% surf(distmask)
% out = dtmask; surf(out)
%
% % 3D
% MNImask = imgload('MNImask');
% [ distmask, mask_bndry ] = dist2maskbndry( MNImask )
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
distmask = zeros(size(mask));
thresh = 0.5;

if length(size(mask)) == 2
    mask_bndry = contourc(1:size(mask,2), 1:size(mask,1), double(mask), [thresh,thresh])';
    initial_points_locs = find(mask_bndry(:,1) == thresh);
    mask_bndry = mask_bndry(setdiff(1:size(mask_bndry, 1), initial_points_locs),:);
    if ~exist( 'area2use', 'var' )
        for I = 1:size(mask,1)
            for J = 1:size(mask,2)
                % dist2ij = pdist2(mask_bndry, [J,I]);
                dist2ij = sqrt(sum((mask_bndry - [J,I]).^2,2));
                distmask(I,J) = min(dist2ij);
            end
        end
    else
        for I = 1:size(mask,1)
            for J = 1:size(mask,2)
                % dist2ij = pdist2(mask_bndry, [J,I]);
                if area2use(I,J) % Only do this if it's in the area to use
                    dist2ij = sqrt(sum((mask_bndry - [J,I]).^2,2));
                    distmask(I,J) = min(dist2ij);
                end
            end
        end
    end
end

if length(size(mask)) == 3
    [x,y,z] = meshgrid(1:size(mask,2),1:size(mask,1),1:size(mask,3)); 
    s = isosurface(x,y,z,mask,thresh);
    mask_bndry = s.vertices;
    if ~exist( 'area2use', 'var' )
        for I = 1:size(mask,1)
            I
            for J = 1:size(mask,2)
                for K = 1:size(mask,3)
                    % dist2ij = pdist2(mask_bndry, [J,I]);
                    dist2ijk = sqrt(sum((mask_bndry - [I,J,K]).^2,2));
                    distmask(I,J,K) = min(dist2ijk);
                end
            end
        end
    else
        for I = 1:size(mask,1)
            for J = 1:size(mask,2)
                for K = 1:size(mask,3)
                    % dist2ij = pdist2(mask_bndry, [J,I]);
                    if area2use(I,J,K) % Only do this if it's in the area to use
                        dist2ijk = sqrt(sum((mask_bndry - [I,J,K]).^2,2));
                        distmask(I,J,K) = min(dist2ijk);
                    end
                end
            end
        end
    end
end
% plot(mask_bndry(:,1), mask_bndry(:,2), '*')

signmask = ones(size(mask));
signmask(mask == 0) = -1;
distmask = distmask.*signmask;

end

