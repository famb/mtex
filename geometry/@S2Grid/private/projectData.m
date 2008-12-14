function [X,Y,bounds] = projectData(theta,rho,varargin)


%% get projection
if isappdata(gcf,'projection')  
  projection = getappdata(gcf,'projection');
else
  projection = 'earea';
end
projection = get_option(varargin,'projection',projection);

%% get min and max rho
if isappdata(gcf,'minrho')
  minrho = getappdata(gcf,'minrho');
else
  minrho = get_option(varargin,'minrho',0);
  setappdata(gcf,'minrho',minrho);
end

if isappdata(gcf,'maxrho')
  maxrho = getappdata(gcf,'maxrho');
else
  maxrho = get_option(varargin,'maxrho',2*pi);
  setappdata(gcf,'maxrho',maxrho);
end


%% restrict to plotable domain

rho = mod(rho,2*pi);
rho(rho<minrho-1e-6 | rho >maxrho+1e-6) = nan;

%% modify polar coordinates

if ~strcmpi(projection,'plain')
  drho = appDataOption(varargin,'rotate',0);
  rho = rho + drho;  
  minrho = minrho + drho;
  maxrho = maxrho + drho;
end
if appDataOption(varargin,'flipud',false), rho = 2*pi-rho; end
if appDataOption(varargin,'fliplr',false), rho = pi-rho; end

brho = linspace(minrho,maxrho,100);
btheta = [0,pi/2];
[brho,btheta] = meshgrid(brho,btheta);

%% project data
switch lower(projection)
  
  case 'plain'

    X = rho; Y = theta;
    bx = brho; by = btheta;
    axis ij;
    
  case {'stereo','eangle'} % equal angle
  
    [X,Y] = stereographicProj(theta,rho);
    [bx,by] = stereographicProj(btheta,brho);
    
  case 'edist' % equal distance
  
    [X,Y] = edistProj(theta,rho);
    [bx,by]= edistProj(btheta,brho);
  
  case {'earea','schmidt'} % equal area
    
    [X,Y] = SchmidtProj(theta,rho);
    [bx,by] = SchmidtProj(btheta,brho);

  case 'orthographic'
    [X,Y] = orthographicProj(theta,rho);
    [bx,by] = orthographicProj(btheta,brho);

  otherwise
    
    error('Unknown Projection!')
    
end

% store projection
setappdata(gcf,'projection',projection);


% compute bounding box 
bounds = [min(bx(:)),min(by(:)),max(bx(:))-min(bx(:)),max(by(:))-min(by(:))];


function v = appDataOption(options,token,default)

if isappdata(gcf,token)
  v = getappdata(gcf,token);
else
  if islogical(default)
    v = check_option(options,token);
  else
    v = get_option(options,token,default);
  end
  setappdata(gcf,token,v);
end
