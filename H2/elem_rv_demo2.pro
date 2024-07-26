;***********************
;elem_rv_demo2.pro
;***********************
;plot the evolution of a swarm of particles launched from Earth

;**************************************************************
;Earth position (AU) and velocity (km/sec)
;assuming circular orbit with velocity 30 km/sec, f=0
;**************************************************************
  r_earth=[1.,0.,0.]
  v_earth= [0.,30.,0.]

;initial launch speed dv, in different directions
;in the plane of Earth's orbit, angle is the direction with 
;respect to x-axis
;try different values!
  dv=5
  pscale=3
;dv=1.
;pscale=2.

;choose the number of particles,
;corresponding launching angles
  npart=3600*.5
  angle_tab=findgen(npart)*360./npart

;**************************************************************
;units: AU and year -> G(m1+m2)=4*pi^2
;orbital speed of Earth = 30 km/sec   = 2*pi AU/year
;km/sec converted to au/year by multiplying with vscale=(2*pi)/30.
;**************************************************************
  myy=4.*!pi^2
  vscale=(2.*!pi)/30.

;*************************************************************
;1) calculate and store orbital elements
;   rv_to_elem returns: elem=[a,eks,ink,ome,w,tau]
;*************************************************************
  elem_tab=fltarr(6,npart)      ; npart different particles
  nwin
  for i=0,n_elements(angle_tab)-1 do begin
      angle=angle_tab(i)
      sina=sin(angle/!radeg)
      cosa=cos(angle/!radeg)
      v=v_earth+[cosa,sina,0]*dv ; rad,tan
      r=r_earth
      v=v*vscale
;orbital elements
      rv_to_elem,0.,r,v,elem,myy=myy
      elem_tab(*,i)=elem
  endfor

;********************************************
;2) start calculating positions
;   plot for different times
;********************************************
;store positions to arrays
  xpos=angle_tab*0.
  ypos=angle_tab*0.
;plotting times
  ntimes=1000
  times=findgen(ntimes)*.05
;  ntimes=9
;  times=findgen(ntimes)*.25+.25

  for j=0,ntimes-1 do begin
      time=times(j)
;earth position (circular orbit)
      x_earth=cos(2.*!pi*time)
      y_earth=sin(2.*!pi*time)      
      for i=0,n_elements(angle_tab)-1 do begin
          elem=elem_tab(*,i)
          elem_to_rv,elem,time,rad,vel,myy=myy
          xpos(i)=rad(0)
          ypos(i)=rad(1)
      endfor      
      plot,xpos,ypos,psym=3,xr=[-1,1]*pscale,yr=[-1,1]*pscale,xs=1,ys=1,/iso,$
        title='dv='+string(dv,'(f6.2)')+'km/sec  T/PER ='+string(time,'(f8.3)')
      plots,x_earth,y_earth,psym=1,symsize=1
      plots,0,0,psym=2,symsize=1 
;if you want to stop between plots - uncomment the next lines
;  answ=''
;  read,answ      
  endfor                        ;end loop over times  
end









