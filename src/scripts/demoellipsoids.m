%  DEMOPARTICLE01 - Plot elementary particle shapes.

diameter = 10;
figure
for it = 1 : 4
  
  switch it
    case 1
      %  triangulated sphere with given number of vertices
      %    32 60 144 169 225 256 289 324 361 400 441 484 529 576 625 676 
      %    729 784 841 900 961 1024 1225 1444
      p = trisphere( 32, diameter );
      p.verts( :, 3 ) = 2 * p.verts( :, 3 );
      
    case 2
      p = trisphere( 60, diameter );
      p.verts( :, 3 ) = 2 * p.verts( :, 3 );
      
    case 3
      p = trisphere( 144, diameter );
      p.verts( :, 3 ) = 2 * p.verts( :, 3 );
      
    case 4
      p = trisphere( 256, diameter );
      p.verts( :, 3 ) = 2 * p.verts( :, 3 );
  end
  
  
  %  plot particle
  p.verts( :, 1 ) = p.verts( :, 1 ) + ( it - 1 ) * 12;
  plot( p, 'EdgeColor', 'b' ); hold on
end
title('Discrete boundary elements of prolate spheroids')
view(0,0)
