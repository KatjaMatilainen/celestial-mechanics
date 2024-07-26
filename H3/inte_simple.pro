;*******************************************************************
; inte_simple.pro
; simple example of numerical integration of 2body orbit
; HS 13.11.2006
;*******************************************************************
; use common to transfer the value of myy into the function 
; which evaluates the forces for RK4-procedure

   common any_name,myy

;choice of units
   myy=1.

;initial values
   M=0./!radeg                     ;mean anomaly 
   a=1.                               
   eks=0.5

;solve eccentric anomaly from Kepler's equation  (M and E in radians)
   kepler,M,eks,E

;use orbital coordinate system (x-axis points to pericenter)
   b=a*sqrt(1.-eks^2)
   x=a*(cos(E)-eks)
   y=b*sin(E)
   vx=-a*sin(E)*sqrt(myy/a^3)/(1-eks*cos(E))
   vy= b*cos(E)*sqrt(myy/a^3)/(1-eks*cos(E))

;initial energy and angular momentum
   r=sqrt(x^2+y^2)
   h0=0.5*(vx^2+vy^2)-myy/r
   k0=x*vy-y*vx

;integration parameters 
   period=2.*!dpi*sqrt(myy/a^3)
   dt=0.01d0*period
   tmax=10.*period
   nsteps=tmax/dt
   ntul=1            ;output every ntul steps

;choice of the integration method
   choice=1        ;Taylor I
   choice=2        ;Taylor2
;   choice=0        ;RK4

;draw window and define plot region
   nwin
   plot,x*[1,1],y*[1,1],/iso,xrange=[-3,3],yrange=[-3,3]

;integration loop
   time=0.
   for i=0l,nsteps-1 do begin

       if(choice eq 1) then begin
           r=sqrt(x^2+y^2)
           ax=-myy/r^3*x
           ay=-myy/r^3*y
           x=x+vx*dt
           y=y+vy*dt
           vx=vx+ax*dt
           vy=vy+ay*dt
           time=time+dt
       endif

       if(choice eq 2) then begin
           r=sqrt(x^2+y^2)
           r2=r^2
           r3=r^3
           r_dot_v=x*vx+y*vy
           apu=3.*r_dot_v/r2
           dt2=0.5*dt^2
           ax=-myy/r3*x
           ay=-myy/r3*y
           aax=-myy/r3*(vx-apu*x)
           aay=-myy/r3*(vy-apu*y)
           x=x+vx*dt+ax*dt2
           y=y+vy*dt+ay*dt2
           vx=vx+ax*dt+aax*dt2
           vy=vy+ay*dt+aay*dt2
           time=time+dt
       endif

       if(choice eq 0) then begin
           yy=[x,y,vx,vy]
           dydx=inte_simple_func(time,yy)
           res=rk4(yy,dydx,time,dt,'inte_simple_func',/double)
           time=time+dt
           x=res(0) & y=res(1)  & vx=res(2)  & vy=res(3)
       endif

;plot?
       if(i  mod ntul eq 0) then oplot,x*[1,1],y*[1,1],psym=3

   endfor

;final energy and angular momentum
   r=sqrt(x^2+y^2)
   h1=0.5*(vx^2+vy^2)-myy/r
   k1=x*vy-y*vx

   if(choice eq 1) then method='Taylor I '
   if(choice eq 2) then method='Taylor II'
   if(choice eq 0) then method='RK4      '

   xyouts,0.5,0.9,/normal,ali=0.5,'method='+string(method)+'  dt/PER='+string(dt/period)
   print,'method=',method,'  dt/PER=',dt/period
   print,'initial h and k:',h0,k0
   print,'final   h and k:',h1,k1



   nper=tmax/period
   dh=(h1-h0)/abs(h0)/nper
   dk=(k1-k0)/abs(k0)/nper
   print,'dh/|h| and dk/|k| per orbit',dh,dk
end
