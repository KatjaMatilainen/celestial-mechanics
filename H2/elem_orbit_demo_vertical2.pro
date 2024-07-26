;*****************************************************
; elem_orbit_demo_vertical2.pro
; use elem_orbit to plot orbits with different elements
; elem = orbital elements [a,eks,ink,ome,w,tau]
; HS 05.11.02

;vertical velocity increments
;uses xplot3d for 3D draving
;*****************************************************


;**************************************************************
;Earth position (AU) and velocity (km/sec)
;assuming circular orbit with velocity 30 km/sec
;units: AU and year -> G(m1+m2)=4*pi^2
;orbital speed of Earth = 30 km/sec   = 2*pi AU/year
;km/sec converted to au/year by multiplying with vscale=(2*pi)/30.
;**************************************************************

  myy=4.*!pi^2
  vscale=(2.*!pi)/30.
  r_earth=[1.,0.,0.]
  v_earth= [0.,30.,0.]

;add different velocity increments

  npart=10
  dv=findgen(npart)*3.
  npart=n_elements(dv)
  vx=v_earth(0)+dv*0
  vy=v_earth(1)+dv*0
  vz=v_earth(2)+dv
  title='vertical velocity increments, max='+string(max(dv))+' km/sec'
  title='plot using xplot3d'

;*************************************************************
;1) calculate and store orbital elements
;   rv_to_elem returns: elem=[a,eks,ink,ome,w,tau]
;*************************************************************

 elem_tab=fltarr(6,npart)   ; npart different particles
 for i=0,npart-1 do begin
  v=[vx(i),vy(i),vz(i)]
  r=r_earth
  v=v*vscale
;orbital elements
  rv_to_elem,0.,r,v,elem,myy=myy
  elem_tab(*,i)=elem
 endfor



;*****************************************
;2) calculate and plot orbits with xplot3d-procedure (see HELP)

 timet=findgen(1000)/100.   ; 0-9 years

;to get the color_palette
 TVLCT,R,G,B,/GET
 lim=2
 for i=0,npart-1 do begin
   elem=elem_tab(*,i)
   elem_orbit,elem,timet,rr,vv,myy=myy
  
   IF(I EQ 0) THEN XPLOT3D, rr(*,0),rr(*,1),rr(*,2),title=title,chars=0.5,$
   COL=[R(I+1),G(I+1),B(I+1)],xr=[-1,1]*lim,yr=[-1,1]*lim,zr=[-1,1]*lim
   IF(I NE 0) then XPLOT3D, rr(*,0),rr(*,1),rr(*,2),/OVERPLOT,COL=[R(I+1),G(I+1),B(I+1)]
 endfor


end
