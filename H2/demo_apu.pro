xylim,0,1,-1,2
!p.multi=[0,2,3]

psdirect,'demo_apu',1,pic='.',ysize=18,xsize=12,/color
!p.charsize=0.7
.run elem_orbit_demo_tangential
.run elem_orbit_demo_radial
.run elem_orbit_demo_vertical
psdirect,'demo_apu',-1,pic='.',ysize=18,xsize=12,/stop
