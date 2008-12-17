function [ m kappa v] = mean( ebsd )
% returns mean, kappas and eigenvector of ebsd object
%
%% Input
%  ebsd      - list of @ebsd
%
%% Output
%  m         - one equivalent mean orientation @quaternion
%  kappa     - parameters of bingham distribution
%  v         - eigenvectors of kappa
%

m = quaternion;
kappa = zeros(4,4,numel(ebsd));
v = zeros(4,4,numel(ebsd));

S3G = get(ebsd,'data');

for i=1:numel(S3G)
  [m(i) kappa(:,:,i)  v(:,:,i)]  = mean(S3G(i));
end