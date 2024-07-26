;************************************
; elem_rv_demo1.pro  = HARJ II.1
; HS 05.11.02/01.11.06
;
;************************************

;**************************************************************
;Earth position (AU) and velocity (km/sec)
;assuming circular orbit with velocity 30 km/sec, f=45 degrees
;**************************************************************
   sinf=sin(45/!radeg)
   cosf=sin(45/!radeg)
   r_earth=[cosf,sinf,0.]
   v_earth=[-sinf,cosf,0.]*30.

;**************************************************************
;units: AU and year -> G(m1+m2)=4*pi^2
;orbital speed of Earth = 30 km/sec   = 2*pi AU/year
;km/sec converted to au/year by multiplying with vscale=(2*pi)/30.
;**************************************************************
   myy=4.*!pi^2
   vscale=(2.*!pi)/30.

;-------------------------------------------------------------
;a) satellite launched from Earth, with velocity dv (km/sec),
;   in perpendicular direction N
;-------------------------------------------------------------
   dv=[0.,0.,15.]
   r=r_earth
   v=v_earth+dv
   v=v*vscale

   print,'-------------------------------------------------'
   print,'PERPENDICULAR INITIAL VELOCITY'
   rv_to_elem,0.,r,v,elem,myy=myy,/print

;-------------------------------------------------------------
;b) satellite launched from Earth, with velocity dv (km/sec),
;   dv perpendicular to radius vector,
;   with angle alpha to N and 90-alpha to V
;-------------------------------------------------------------
   alpha=45.
   sina=sin(45/!radeg)
   cosa=sin(45/!radeg)
   vtan=30.+sina*15.
   vnor=cosa*15.
   v=[-sinf*vtan,cosf*vtan,vnor]
   r=r_earth
   v=v*vscale

   print,'-------------------------------------------------'
   print,'PERPENDICULAR INITIAL VELOCITY, ALPHA=45'
   rv_to_elem,0.,r,v,elem,myy=myy,/print


;-------------------------------------------------------------
;c) satellite launched from Earth, with velocity dv (km/sec),
;   dv perpendicular to radius vector,
;   with angle alpha to N
;-------------------------------------------------------------
   alpha=89.99                  ; in the direction of velocity vector
   sina=sin(alpha/!radeg)
   cosa=cos(alpha/!radeg)
   vtan=30.+sina*15.
   vnor=cosa*15.   
   v=[-sinf*vtan,cosf*vtan,vnor]
   r=r_earth
   v=v*vscale

   print,'-------------------------------------------------'
   print,'INITIAL VELOCITY in the direction of Earth velocity'
   print,'R [AU]     =',r
   print,'V [AU/year]=',v
   rv_to_elem,0.,r,v,elem,myy=myy,/print


;**********************************************************
;d) Calculate the same with different directions of the
;initial velocity alpha=0,1,...,90 degrees
;dv is the absolute value of velocity increment
;**********************************************************
   dv=15.

;plot a,eks,ink, ene, amom as a function of alpha
;make arrays for alpha, a,eks,ink
;rv_to_elem returns: elem=[a,eks,ink,ome,w,tau]

   alpha_tab=findgen(91)*1.
   a_tab=alpha_tab*0.
   e_tab=alpha_tab*0.
   i_tab=alpha_tab*0.

   for i=0,n_elements(alpha_tab)-1 do begin
       alpha=alpha_tab(i)
       sina=sin(alpha/!radeg)
       cosa=cos(alpha/!radeg)
       vtan=30.+sina*dv
       vnor=cosa*dv
       v=[-sinf*vtan,cosf*vtan,vnor]
       r=r_earth
       v=v*vscale
;orbital elements
       rv_to_elem,0.,r,v,elem,myy=myy
       a_tab(i)=elem(0)
       e_tab(i)=elem(1)
       i_tab(i)=elem(2)
   endfor
   
;calculate also angular momentum and energy, 
;take into account the sign for elliptic and hyperbolic
   k_tab=a_tab*abs(1.-e_tab^2)   
   h_tab=-myy/(2*a_tab)
   index=where(e_tab gt 1,count)
   if(count ge 1) then h_tab(index)=-h_tab(index)
   

   !p.multi=[0,3,2]
   nwin   
   plot,alpha_tab,a_tab,xtitle='alpha',ytitle='a'
   plot,alpha_tab,e_tab,xtitle='alpha',ytitle='EKS'
   plot,alpha_tab,i_tab,xtitle='alpha',ytitle='INK'
   plot,alpha_tab,h_tab,xtitle='alpha',ytitle='energy'
   oplot,alpha_tab(index(0))*[1,1],[-30,30],lines=2
   plot,alpha_tab,k_tab,xtitle='alpha',ytitle='angular momentum'
   

   xyouts,0.67,0.40,/normal, 'Particle launched from Earth (v=30 km/s)',chars=0.7
   xyouts,0.67,0.35,/normal,'fixed initial speed='+string(dv,'(f6.2)')+'km/s',chars=0.7
   xyouts,0.67,0.30,/normal, 'velocity perpendicular to radius-vector',chars=0.7
   xyouts,0.67,0.25,/normal, 'alpha= angle from normal direction',chars=0.7
   xyouts,0.67,0.20,/normal, '(alpha=90 -> tangential increment)',chars=0.7
   
xyouts,0.01,0.01,'elem_rv_demo1.pro',/normal,chars=.5
!p.charsize=1
charsize,1
!p.multi=0


end








