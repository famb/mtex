function l = or( grains,expr )
% logical or to compare a GrainSet with some other set, in particular
% for selecting grains.
%
%% Output
% l - logical array, where the position of |true| indicates that the grain
%    is in the complete GrainSet and valid for left |or| right side expression
%
%% Examples
%  grains('fe') | grainSize(grains) > 10
%  grains(grains('fe') | grainSize(grains) > 10)
%% See also
% GrainSet/and GrainSet/not GrainSet/logical

if isa(grains,'GrainSet'), grains = logical(grains); end
if isa(expr,'GrainSet'),  expr = logical(expr); end

l = grains(:) | expr(:);