function [ebsd,options] = loadEBSD_generic(fname,varargin)
% load pole figure data from (alpha,beta,gamma) files
%
%% Description 
%
% *loadEBSD_txt* is a generic function that reads any txt files of
% diffraction intensities that are of the following format
%
%  alpha_1 beta_1 gamma_1 phase_1
%  alpha_2 beta_2 gamma_2 phase_2
%  alpha_3 beta_3 gamma_3 phase_3
%  .      .       .       .
%  .      .       .       .
%  .      .       .       .
%  alpha_M beta_M gamma_M phase_m
%
% The actual position and order of the columns in the file can be specified
% by the option |LAYOUT|. Furthermore, the files can be contain any number
% of header lines and columns to be ignored using the options |HEADER| and
% |HEADERC|.
%
%% Syntax
%  pf   = loadEBSD_txt(fname,<options>)
%  pf   = loadEBSD_txt(fname,'layout',[col_phi1,col_Phi,col_phi2]
%
%% Input
%  fname - file name (text files only)
%
%% Options
%  RADIANS           - treat input in radiand
%  DELIMITER         - delimiter between numbers
%  HEADER            - number of header lines
%  HEADERC           - number of header colums
%  BUNGE             - [phi1 Phi phi2] Euler angle in Bunge convention (default)
%  ABG               - [alpha beta gamma] Euler angle in Mathies convention 
%  LAYOUT            - colums of the Euler angle (default [1 2 3])
%  XY                - colums of the xy data
%
% 
%% Example
%
% ebsd = loadEBSD('ebsd.txt',symmetry('cubic'),symmetry,'header',1,'layout',[5,6,7]) 
%
%% See also
% interfacesEBSD_index loadEBSD ebsd_demo

% load data
[d,varargin,header,c] = load_generic(fname,varargin{:});

% no data found
if size(d,1) < 10 || size(d,2) < 3
  error('Generic interface could not detect any numeric data in %s',fname);
end

% no options given -> ask
if ~check_option(varargin,'layout')
  
  options = generic_wizard('data',d,'type','EBSD','header',header,'colums',c);
  if isempty(options), ebsd = []; return; end
  varargin = {options{:},varargin{:}};

end

%extract options
dg = degree + (1-degree)*check_option(varargin,{'radians','radiant','radiand'});
layout = get_option(varargin,'LAYOUT',[1 2 3]);
xy = get_option(varargin,'xy',[]);
phase = get_option(varargin,'phase',[],'double');
    


% columnames = 1;
names =  get_option (varargin,'columnnames',[]);
indi =  get_option (varargin,'columnindex',[]);
if check_option (varargin,'columnnames')
  if size (names) ~= size (indi),
    error ('dimension of COLUMNNAMES and COLUMNINDEX must agree!'), 
  end
end


try
    
  % eliminate nans
  d(any(isnan(d(:,layout)),2),:) = [];
  
  % extract right phase
  if length(layout) == 4 && ~isempty(phase)    
    d = d(any(d(:,layout(4))==repmat(reshape(phase,1,[]),size(d,1),1),2),:);
  end
  
  % get Euler angles option 
  bunge = set_default_option(...
    extract_option(varargin,{'bunge','ABG','Quaternion'}),{'bunge','ABG','Quaternion'},...
    'bunge');
  
  % eliminate rows where angle is 4*pi
  ind = abs(d(:,layout(1))*dg-4*pi)<1e-3;
  d(ind,:) = [];
 
   % extract data
  if ~strcmp(bunge,'Quaternion')
    alpha = d(:,layout(1))*dg; 
    beta  = d(:,layout(2))*dg;
    gamma = d(:,layout(3))*dg;

    if check_option(varargin,'aufstellung2')
      gamma = gamma+30*degree;
    end
    mtex_assert(all(beta >=0 & beta <= pi & alpha >= -2*pi & alpha <= 4*pi & gamma > -2*pi & gamma<4*pi));

    % check for choosing 
    if max(alpha) < 6*degree
      warndlg('The imported Euler angles appears to be quit some, maybe your data are in radians and not in degree as you specified?');
    end
    % store data as quaternions
    q = euler2quat(alpha,beta,gamma,bunge{:});  

    if check_option(varargin,'inverse'), q = inverse(q); end
  else
    q = quaternion(d(:,layout(1))*dg,d(:,layout(2))*dg,d(:,layout(3))*dg,d(:,layout(4))*dg);    
  end
   
  if ~isempty(xy), xy = d(:,xy);end

  d1 = {};
  parameter = {};
  if ~isempty(phase)
    phases = unique(d(:,phase));
    for i =1:numel(phases)
      id = find(d(:,phase) == phases(i));
      
      SO3G(i) = SO3Grid(q(id),symmetry('cubic'),symmetry());
      xy_s{i,1} = xy(id,:);
      ph{i,1} = phases(i);
      
      if ~isempty(names)
        d1 = [d1; mat2cell(d(id,indi),numel(id), ones(1,size(indi,2)))];
      end
          
    end
    xy = xy_s;
  else
    ph = {0};
    SO3G = SO3Grid(q,symmetry('cubic'),symmetry());
    d1 = d(:,indi);
    xy = {xy};
  end
  
  if  ~isempty(names)       
    for i=1:length(names), parameter{i} = {names{i} {d1(:,i)}}; end
    parameter = [parameter{:}];
    ebsd = EBSD(SO3G,'xy',xy,'phase',ph,parameter{:}); 
  else
    ebsd = EBSD(SO3G,'xy',xy,'phase',ph);   
  end
  
  options = varargin;

catch %#ok<CTCH>
  error('Generic interface could not extract data of file %s (%s)' ,fname,lasterr); %#ok<LERR>
  %rethrow(lasterror);
end
