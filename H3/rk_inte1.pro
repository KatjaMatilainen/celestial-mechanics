;*******************************************************************
; rk_inte1.pro
;*******************************************************************
;Integrate 2-body equations with Runge-Kutta 4 (RK4)
;check the accuracy of the orbital elements
;OCT 2002/2006 Celestial mechanics (HS) --> 
;*******************************************************************

pro rk_inte1,elem,t1_0,t2_0,dt_0,output0=output0,myy0=myy0,example=example,$
             plot=plot,cplot=cplot,wid0=wid0,oplot=oplot,dl=dl,de=de,$
             t_out=t_out,l_out=l_out,e_out=e_out,taylor=taylor,title0=title0,$
             dtorb=dtorb,silent=silent,connect=connect,$
             x_out=x_out,y_out=y_out,z_out=z_out,$
             vx_out=vx_out,vy_out=vy_out,vz_out=vz_out

if(n_params() le 0) then begin
    print,'-----------------------------------------------------------------------------'
    print,'pro rk_inte1,elem,t1,t2,dt,output=output,plot=plot'
    print,'-----------------------------------------------------------------------------'
    print,'Cartesian integration of non-perturbed 2-body orbit HS 20.11.02/12.02.06'
    print,'  elem=[a,e,i,ome,w,tau]  initial orbital elements'
    print,'  t1,t2                   integration time interval (in orbital periods)'
    print,'  dt                      time step (orbital periods)'
    print,'KEYWORDS:'
    print,'-----------------------------------------------------------------------------'
    print,'  myy                     G * (m1+m2)   def=1.'    
    print,'  taylor=choice           use Taylor series, with degree=taylor (def=rk4)'
    print,'                          choices=  1, 2               explicitly written                   '
    print,'                                   -1,-2,-3,-4,-5,-6   using f,g-series' 
    print,'  dtorb =value            -> dt=period/dtorb'    
    print,'-----------------------------------------------------------------------------'
    print,'PLOTTING KEYWORDS:' 
    print,'  plot=istep              plot every istep steps (def=no plot)'
    print,'  oplot=color             plot on top of previous orbit with'
    print,'                          color=oplot+2 (i.e 1->col=3=green)'  
    print,'  /connect                -> connect orbit points in the plot (def=no)'
    print,'  wid                     limit of the plot region (DEF=1.25 a)'
    print,'  /cplot                  plot analytic solution (white squares)'
    print,'  title                   -> plot title' 
    print,'  output=val              output interval of ELEM,L,E in steps (def=nsteps/10)'
    print,'                          val=negative -> just store'  
    print,'-----------------------------------------------------------------------------'
    print,'OUTPUT/STORE KEYWORDS:'
    print,'  t_out,l_out,e_out       dL/L and dE/E vs t_out (stored every |output| step)'
    print,'  x_out,y_out,z_out       positions'
    print,'  vx_out,vy_out,vz_out    velocities'
    print,'  dl,de                   return averaged change in dL/L and dE/E /orbit period'   
    print,'  /silent                 -> do not print anything to terminal'
    print,'-----------------------------------------------------------------------------'
    print,'EXAMPLE INPUT VALUES:'
    print,'  /example                example of integration:'
    print,'                          a=1,ecc=0.5,i=10,ome=90.,w=0,tau=0, t1=0, t2=10*TORB, dt=0.01*TORB'
    print,'  rk_inte1,elem,t1,t2,dt,/example,/plot'
    print,'-----------------------------------------------------------------------------'
    return
endif

;to transfer the value of myy into the function 
;which evaluates the forces for RK4-procedure
   common rk_inte1_com,myy

   myy=1.d0
   if(keyword_set(myy0)) then myy=myy0*1.d0

   if(keyword_set(example)) then begin
       t1_0=0.d0  &  t2_0=10.d0  &  dt_0=0.01d0
       elem=[1.d0,0.5d0,10.d0,90.d0,0.d0,0.d0]
   endif

   elem=elem*1.d0
   torb=2.d0*!dpi*sqrt(elem(0)^3/myy)
   per=torb
   t1=t1_0*torb   &   t2=t2_0*torb   &   dt=dt_0*torb

   if(keyword_set(dtorb)) then dt=torb/dtorb

   dt2=dt^2                     ;needed in taylor
   tapu0=1.d0
   tapu1=dt
   tapu2=tapu1*dt/2.d0
   tapu3=tapu2*dt/3.d0
   tapu4=tapu3*dt/4.d0
   tapu5=tapu4*dt/5.d0
   tapu6=tapu5*dt/6.d0
   tapu7=tapu6*dt/7.d0
   tapu8=tapu7*dt/8.d0

   wid=elem(0)*(1.+elem(1))*1.25
   if(keyword_set(wid0)) then wid=wid0
   
;************************************************************
;   R,V at t=t1:
;   use the procedure elem_to_rv to calculate
;   R and V corresponding to the given orbital elements
;************************************************************
   elem_to_rv,elem,t1,rad,vel

;check + obtain constants of integration
   rv_to_elem,t1,rad,vel,elem2,kvec=kvec,evec=evec,ene=ene0,imp=imp0
   
;number of steps, output interval
   nsteps=long((t2-t1)/dt)
   time=t1
   output=long(nsteps/10.)
   if(keyword_set(output0)) then output=output0

;arrays for storing constants of motion vs. time
   noutput=long(nsteps/abs(output))+1
   t_out=dblarr(abs(noutput))
   l_out=t_out
   e_out=t_out
   iout=0l

;some formats needed later
   ff=    '(f10.4,6f12.6,2e14.2)'
   ff_ori='(f10.4,6f12.6,e12.2,2h=L,e12.2,2h=E)'
   
   if(not keyword_set(silent)) then begin
       print,'--------------------------------------------------------'
       print,'CARTESIAN INTEGRATION OF NON-PERTURBED 2-BODY MOTION'
       print,'--------------------------------------------------------'
       if(not keyword_set(taylor)) then $
         print,' USING RK4'
       if(    keyword_set(taylor)) then $
         print,' USING TAYLOR-SERIES, with degree ',taylor       
       print,'MYY= G* (m1+m2) = ',myy
       print,'PERIOD = ',per
       print,'T1,T2,DT (in periods) = ',t1/per,t2/per,dt/per
       print,'NSTEPS, OUTPUT = ',nsteps,output
       print,' '
       otsi='      TIME      AMAJ        ECC         INC         OME         W'
       otsi=otsi+'         TAU          dL/L         dE/E'    
       print,otsi
       print,time,elem,imp0,ene0,f=ff_ori
   endif

   istep=0l
   if(keyword_set(plot)) then begin
       istep=plot
       if(not keyword_set(oplot)) then begin
           title=''
           if(keyword_set(title0)) then title=title0
           nwin
           plot,lindgen(10),xr=[-1,1]*wid,yr=[-1,1]*wid,$
             xs=1,ys=1,/nod,/iso,title=title
           plots,rad(0),rad(1),psym=1
           plots,0,0,psym=1,syms=3
       endif
   endif
   
   col=2
   if(keyword_set(oplot)) then col=oplot+2

   xold=rad(0)
   yold=rad(1)

;--------------------------------------------------------------
;MAKE INTEGRATION
;--------------------------------------------------------------
   
   for i=1l,nsteps do begin

;-----------------------------------------------------
;RK4 INTEGRATION
;-----------------------------------------------------
       if(not keyword_set(taylor)) then begin
           yy=[rad,vel]
           dydx=rk_inte1_func(time,yy)
           res=rk4(yy,dydx,time,dt,'rk_inte1_func',/double)
           rad=res(0:2)
           vel=res(3:5)
           time=time+dt
       endif

;-----------------------------------------------------
;TAYLOR SERIES
;-----------------------------------------------------
       
       if(keyword_set(taylor)) then begin
           x=rad(0)
           y=rad(1)
           z=rad(2)
           vx=vel(0)
           vy=vel(1)
           vz=vel(2)           
; I degree?
           if(taylor eq 1) then begin
               r2=(x^2+y^2+z^2)
               r3=r2^1.5
               dx=vx
               dy=vy
               dz=vz
               dvx=-myy/r3*x
               dvy=-myy/r3*y
               dvz=-myy/r3*z
               x=x+dx*dt
               y=y+dy*dt
               z=z+dz*dt
               vx=vx+dvx*dt
               vy=vy+dvy*dt
               vz=vz+dvz*dt
               time=time+dt
               rad=[x,y,z]
               vel=[vx,vy,vz]
           endif        
; II degree?
           if(taylor eq 2) then begin
               r2=(x^2+y^2+z^2)
               r3=r2^1.5
               rpv=x*vx+y*vy+z*vz
               dvx=-myy/r3*x
               dvy=-myy/r3*y
               dvz=-myy/r3*z
               ddvx=-myy/r3*(vx-3.*rpv/r2*x)
               ddvy=-myy/r3*(vy-3.*rpv/r2*y)
               ddvz=-myy/r3*(vz-3.*rpv/r2*z)
               dx=vx
               dy=vy
               dz=vz
               ddx=dvx
               ddy=dvy
               ddz=dvz
               x=x+dx*dt+0.5*ddx*dt2
               y=y+dy*dt+0.5*ddy*dt2
               z=z+dz*dt+0.5*ddz*dt2
               vx=vx+dvx*dt+0.5*ddvx*dt2
               vy=vy+dvy*dt+0.5*ddvy*dt2
               vz=vz+dvz*dt+0.5*ddvz*dt2
               time=time+dt
               rad=[x,y,z]
               vel=[vx,vy,vz]
           endif

;taylor=negative -use f,g series with order=|taylor|
           if(taylor lt 0) then begin
               nt=-taylor
               r2=x^2+y^2+z^2
               r3=r2^1.5
               rpv=x*vx+y*vy+z*vz
               
               u=myy/r3
               p=1.d0/r2*rpv
               q=(vx^2+vy^2+vz^2)/r2-u
               up=u*p
               p2=p*p
               q2=q*q
               u2=u*u
               p3=p2*p
               
               f0=1.d0
               f1=0.d0
               f2=-u
               f3=3.d0*up
               f4=u*(-15.*p2+3.d0*q+u)
               f5=15.d0*up*(7.d0*p2-3.d0*q-u)

;Bates has an error!
;modified u*p to u*q
;    f6=105.d0*u*p2*(-9.d0*p2+6.d0*q+2.d0*u)-u*(45.d0*q2+24.d0*u*q+u2)    
;    f7=315.d0*u*p3*(33.d0*p2-30.d0*q+5.d0*u)+63.d0*up*(25.d0*q2+14.d0*u*q+u2)
;Sconzo
               f6=-945.d0*p^4*u+p^2*(630.d0*q*u+210.d0*u^2)$
                 -24.d0*q*u^2-45.d0*q^2*u-u^3
               f7=10395.d0*p^5*u-p^3*(9450.d0*q*u+3150.d0*u^2)+$
                 p*(882.d0*q*u^2+1575.d0*q^2*u+63.d0*u^3)
                           
               g0=0.d0
               g1=1.d0
               g2=0.d0
               g3=-u
               g4=6.d0*up
               g5=u*(-45.d0*p2+9.d0*q+u)
;Bates has an error!
;    g6=30.d0*up*(14.d0*p2-6.d0*q-u)
;    g7=315.d0*u*p2*(-15.d0*p2+10.d0*q+2.d0*u)-u*(225.d0*q2+54.d0*u*q+u2)    
;sconzo
               g6=420.d0*p^3*u-p*(180.d0*q*u+30.d0*u^2)
               g7=-4725.d0*p^4*u+p^2*(3150.d0*q*u+630.d0*u^2)-$
                 54.d0*q*u^2-225.d0*q^2*u-u^3

               if(nt eq 1) then begin
                   fr=f0*tapu0+f1*tapu1
                   gr=g0*tapu0+g1*tapu1
                   fv=f1*tapu0+f2*tapu1
                   gv=g1*tapu0+g2*tapu1
               endif
               if(nt eq 2) then begin
                   fr=f0*tapu0+f1*tapu1+f2*tapu2
                   gr=g0*tapu0+g1*tapu1+g2*tapu2
                   fv=f1*tapu0+f2*tapu1+f3*tapu2
                   gv=g1*tapu0+g2*tapu1+g3*tapu2
               endif
               if(nt eq 3) then begin
                   fr=f0*tapu0+f1*tapu1+f2*tapu2+f3*tapu3
                   gr=g0*tapu0+g1*tapu1+g2*tapu2+g3*tapu3
                   fv=f1*tapu0+f2*tapu1+f3*tapu2+f4*tapu3
                   gv=g1*tapu0+g2*tapu1+g3*tapu2+g4*tapu3
               endif
               if(nt eq 4) then begin
                   fr=f0*tapu0+f1*tapu1+f2*tapu2+f3*tapu3+f4*tapu4
                   gr=g0*tapu0+g1*tapu1+g2*tapu2+g3*tapu3+g4*tapu4
                   fv=f1*tapu0+f2*tapu1+f3*tapu2+f4*tapu3+f5*tapu4
                   gv=g1*tapu0+g2*tapu1+g3*tapu2+g4*tapu3+g5*tapu4
               endif
               if(nt eq 5) then begin
                   fr=f0*tapu0+f1*tapu1+f2*tapu2+f3*tapu3+f4*tapu4+f5*tapu5
                   gr=g0*tapu0+g1*tapu1+g2*tapu2+g3*tapu3+g4*tapu4+g5*tapu5
                   fv=f1*tapu0+f2*tapu1+f3*tapu2+f4*tapu3+f5*tapu4+f6*tapu5
                   gv=g1*tapu0+g2*tapu1+g3*tapu2+g4*tapu3+g5*tapu4+g6*tapu5
               endif
               if(nt eq 6) then begin
                   fr=f0*tapu0+f1*tapu1+f2*tapu2+f3*tapu3+f4*tapu4+f5*tapu5+f6*tapu6
                   gr=g0*tapu0+g1*tapu1+g2*tapu2+g3*tapu3+g4*tapu4+g5*tapu5+g6*tapu6
                   fv=f1*tapu0+f2*tapu1+f3*tapu2+f4*tapu3+f5*tapu4+f6*tapu5+f7*tapu6
                   gv=g1*tapu0+g2*tapu1+g3*tapu2+g4*tapu3+g5*tapu4+g6*tapu5+g7*tapu6
               endif
               
               xa=fr*x+gr*vx
               ya=fr*y+gr*vy
               za=fr*z+gr*vz
               vx=fv*x+gv*vx
               vy=fv*y+gv*vy
               vz=fv*z+gv*vz
               x=xa
               y=ya
               z=za
               
               time=time+dt
               rad=[x,y,z]
               vel=[vx,vy,vz]
           endif
       endif

;-----------------------------------------------------
;  PLOT?
;-----------------------------------------------------
       if(istep ne 0) then begin
           if(i mod istep eq 0) then begin
               plots,rad(0),rad(1),psym=3,col=col
;connect to previous point?
               if(keyword_set(connect)) then begin
                   oplot,[xold,rad(0)],[yold,rad(1)],psym=0,col=col
                   xold=rad(0)
                   yold=rad(1)
               endif
;overplot analytical?
               if(keyword_set(cplot)) then begin
                   elem_to_rv,elem,time,radc,velc
                   plots,radc(0),radc(1),psym=4,col=1,syms=.5
               endif
           endif 	
       endif
       
;-----------------------------------------------------
;  OUTPUT?
;rv_to_elem calculates orbital elements from R and V
;-----------------------------------------------------
       if(i mod abs(output) eq 0) then begin
           rv_to_elem,time,rad,vel,elem2,imp=imp,ene=ene
           dimp=(imp-imp0)/imp0
           dene=(ene-ene0)/ene0
           dl=dimp/(time/per)   ;change/orbit
           de=dene/(time/per)   ;change/orbit
           elem2(5)=elem2(5) mod per ;tau
           if(elem2(5) ge 0.5*per) then elem2(5)=elem2(5)-per
           if(not keyword_set(silent)) then begin
               if(output gt 0 or i eq nsteps) then print,time/per,elem2,dimp,dene,f=ff
           endif
           t_out(iout)=time/per
           e_out(iout)=dene
           l_out(iout)=dimp
           iout=iout+1
       endif
   endfor
   t_out=t_out(0:iout-1)
   e_out=e_out(0:iout-1)
   l_out=l_out(0:iout-1)

   rv_to_elem,time,rad,vel,elem2,imp=imp,ene=ene
   dimp=(imp-imp0)/imp0
   dene=(ene-ene0)/ene0
   dl=dimp/(time/per)           ;change/orbit
   de=dene/(time/per)           ;change/orbit   
   if(not keyword_set(silent)) then begin
       print,'time,dL/L, dE/E  (/per orbit)'
       print,time/per,dl,de,f='(f30.16,2g16.6)'
   endif
end


