function display(rot)
% standart output

disp(' ');
disp([inputname(1) ' = ' doclink('Rotations','rotation') ': (size: ' int2str(size(rot)) ')']);

if numel(rot) < 30 && numel(rot)>0
  
  disp('  Bunge Euler angles in degree: ');

  [phi1,Phi,phi2] = Euler(rot);
  d = [phi1(:)/degree,Phi(:)/degree,phi2(:)/degree];
  
  d(abs(d)<1e-10)=0;
  cprintf(d,'-L','  ','-Lc',{'phi1' 'Phi' 'phi2' 'inversion'});

end

disp(' ');