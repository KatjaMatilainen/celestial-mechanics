;*****************************************************
; elem_orbit_demo_vertical.pro
; use elem_orbit to plot orbits with different elements
; elem = orbital elements [a,eks,ink,ome,w,tau]
; HS 05.11.02
;*****************************************************



;here plotting vertical velocity increments

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
;try here various tangential velocities

  norb=16
  dv=findgen(norb)*2.
  npart=n_elements(dv)
  vx=v_earth(0)+dv*0
  vy=v_earth(1)+dv*0
  vz=v_earth(2)+dv
  title='vertical velocity'

;*************************************************************
;1) calculate and store orbital elements
;   rv_to_elem returns: elem=[a,eks,ink,ome,w,tau]
;*************************************************************
 elem_tab=fltarr(6,norb)   ; norb different orbits
 ene_tab=fltarr(norb)

ene_earth=abs(myy/2.)     ; Maan energia 

 print,'Satellite launched from Earth orbit (v_cir=30km/sec)'
 print,'----------------------------------------------------------------------'
 print,'dv_ver     a     eks      ink     ome       w     tau  ene/|ene_earth|'
 print,'----------------------------------------------------------------------'
 ff='(f4.1,2x, 2f8.3, 4f8.2, 2x,f9.3)'



 for i=0,norb-1 do begin
  v=[vx(i),vy(i),vz(i)]
  r=r_earth
  v=v*vscale
;orbital elements
  rv_to_elem,0.,r,v,elem,myy=myy,ene=ene
  print,dv(i),elem,ene/ene_earth,f=ff
  elem_tab(*,i)=elem
  ene_tab(i)=ene
 endfor
 print,'----------------------------------------------------------------------'


;*****************************************
;2) calculate and plot orbits
;*****************************************

 nwin
 timet=findgen(1000)/100.   ; 0-9 years

 for i=0,norb-1 do begin
     elem=elem_tab(*,i)
     elem_orbit,elem,timet,rr,vv,myy=myy

     if(i eq 0) then begin
         plot,rr(*,0),rr(*,1),psym=3,xtitle='x',ytitle='y',$
           xr=[-5,5]-3,yr=[-5,5],xs=1,ys=1,/iso,title=title
         plots,0,0,psym=1
     endif
     if(i ne 0) then oplot,rr(*,0),rr(*,1),psym=3,col=i+1
 endfor
 xyouts,0.01,0.01,/normal,'elem_orbit_demo.pro',chars=.75
 
;***************************************************
;3 plot energy/|energy vs |dv|/|v_earth|
;***************************************************
nwin

ene_earth=abs(myy/2.)
plot,dv/30.,ene_tab/ene_earth,xtitle='|dv|/|v_earth|',ytitle='ene/|ene_Earth|'

;indicate the limit for hyperbolic orbit
oplot,[0,1],[0,0],lines=1
oplot,(sqrt(2)-1)*[1,1],[-1,2],lines=1

xyouts,0.01,1.8,'|dv|/v_circ=sqrt(2)-1 --> v/v_circ=sqrt(2)'

xyouts,0.01,0.01,/normal,'elem_orbit_demo.pro',chars=.75
  



startti:


;***************************************************
;4) calculate and plot orbits, using 3d-plot
;***************************************************

nwin
;use shade-surface to make the viewing transformation
;and draw a box with size lim

  lim=2

  x=findgen(6)/5.*20
  surface,x#x,x,x,/save,xr=[-1,1]*lim,yr=[-1,1]*lim,zr=[-1,1]*lim,/nod,$
  xs=1,ys=1,zs=1,pos=[.15,.1,.85,.9],xtit='X',ytit='Y',ztit='Z',chars=1.5,$
  title=title

  x=lim*[-1,1,1,-1,-1,1,1,-1]
  y=lim*[-1,-1,1,1,-1,-1,1,1]
  z=lim*[-1,-1,-1,-1,1,1,1,1]
  front=[0,1,2,3,0]
  back=[4,5,6,7,4]
  ls=2
  plots,x(front),y(front),z(front),/t3d,/data,linestyle=ls
  plots,x(back),y(back),z(back),/t3d,/data,linestyle=2
  for i=0,3 do begin
    side=[i,i+4]
    plots,x(side),y(side),z(side),/t3d,/data,linestyle=2
  endfor


;calculate and plot
 timet=findgen(1000)/100.   ; 0-9 years

 for i=0,npart-1 do begin
   elem=elem_tab(*,i)
   elem_orbit,elem,timet,rr,vv,myy=myy
   plots,rr(*,0),rr(*,1),rr(*,2),psym=3,/t3d,col=i+1
   index=where(rr(*,2) gt 0, count)
   if(count gt 0) then plots,rr(index,0),rr(index,1),rr(index,2),psym=6,$
                  /t3d,col=i+1,syms=.5
 endfor

xyouts,0.01,0.01,/normal,'elem_orbit_demo_vertical.pro',chars=.75


skippi:


end
