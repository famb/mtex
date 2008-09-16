function S2G = add(S2G,points)
% add points to a grid
%% Input
%  S2G    - @S2Grid
%  points - @vector3d
%
%% Output
%  S2G    - @S2Grid

S2G.options = delete_option(S2G.options,'INDEXED');
S2G.Grid = [S2G.Grid(:);points(:)]; 
S2G.theta = [];
S2G.rho = [];
