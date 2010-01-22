function omega = angle(q1,q2)
% calcualtes the rotational angle between rotations q1 and q2
%
%% Syntax  
%  omega = angle(q)
%  omega = angle(q1,q2)
%
%% Input
%  q1, q2 - @quaternion
% 
%% Output
%  omega  - double [q1 x q2]

if nargin == 2
  
  omega = 2*acos(min(1,dot_outer(q1,q2)));
  
else

  omega = 2*acos(min(1,abs(q1.a)));
  
end