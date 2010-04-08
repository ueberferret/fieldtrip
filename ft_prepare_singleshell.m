function [vol, cfg] = ft_prepare_singleshell(cfg, mri)

% FT_PREPARE_SINGLESHELL creates a simple and fast method for the MEG forward
% calculation for one shell of arbitrary shape. This is based on a
% correction of the lead field for a spherical volume conductor by a
% superposition of basis functions, gradients of harmonic functions
% constructed from spherical harmonics.
%
% Use as
%   [vol, cfg] = ft_prepare_singleshell(cfg, seg), or
%   [vol, cfg] = ft_prepare_singleshell(cfg, mri), or
%   [vol, cfg] = ft_prepare_singleshell(cfg)
%
% If you do not use a segmented MRI, the configuration should contain
%   cfg.headshape   = a filename containing headshape, a structure containing a
%                     single triangulated boundary, or a Nx3 matrix with surface
%                     points
%   cfg.numvertices = number, to retriangulate the mesh with a sphere (default = 3000)
%                     instead of specifying a number, you can specify 'same' to keep the
%                     vertices of the mesh identical to the original headshape points
%
% The following options are relevant if you use a segmented MRI
%   cfg.smooth      = 'no' or the FWHM of the gaussian kernel in voxels (default = 5)
%   cfg.mriunits    = 'mm' or 'cm' (default is 'mm')
%   cfg.sourceunits = 'mm' or 'cm' (default is 'cm')
%   cfg.threshold   = 0.5, relative to the maximum value in the segmentation
%
% This function implements
%   G. Nolte, "The magnetic lead field theorem in the quasi-static
%   approximation and its use for magnetoencephalography forward calculation
%   in realistic volume conductors", Phys Med Biol. 2003 Nov 21;48(22):3637-52.

% TODO the spheremesh option should be renamed consistently with other mesh generation cfgs
% TODO shape should contain pnt as subfield and not be equal to pnt (for consistency with other use of shape)

% Copyright (C) 2006-2007, Robert Oostenveld
%
% Subversion does not use the Log keyword, use 'svn log <filename>' or 'svn -v log | less' to get detailled information

fieldtripdefs

cfg = checkconfig(cfg, 'trackconfig', 'on');
cfg = checkconfig(cfg, 'renamed', {'spheremesh', 'numvertices'});

% set the defaults
if ~isfield(cfg, 'smooth');        cfg.smooth = 5;          end % in voxels
if ~isfield(cfg, 'mriunits');      cfg.mriunits = 'mm';     end
if ~isfield(cfg, 'sourceunits'),   cfg.sourceunits = 'cm';  end
if ~isfield(cfg, 'threshold'),     cfg.threshold = 0.5;     end % relative
if ~isfield(cfg, 'numvertices'),   cfg.numvertices = 4000;  end % approximate number of vertices in sphere

% construct the geometry of the volume conductor model, containing a single boundary
% the initialization of the forward computation code is done later in prepare_headmodel
vol = [];
if nargin==1
  vol.bnd = prepare_mesh(cfg);
else
  vol.bnd = prepare_mesh(cfg, mri);
end
vol.type = 'nolte';

% get the output cfg
cfg = checkconfig(cfg, 'trackconfig', 'off', 'checksize', 'yes'); 

