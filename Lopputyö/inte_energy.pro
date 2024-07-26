pro inte_energy,eks0=eks0,dt0=dt0,choice0=choice0,yrange0=yrange0

   common any_name,myy

;choice of units
   myy=1.

;initial values
   M=0./!radeg                     ;mean anomaly 
   a=1.                               
   P=2.d0*!dpi*sqrt(a^3/myy)
   eks=eks0

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
   dt=0.01d0
   if(keyword_set(dt0)) then dt=dt0
   dt=dt*period
   tmax=10.*period
   nsteps=tmax/dt
;print,'nsteps'
;print,nsteps
   ntul=fix(nsteps/10)            ;output every ntul steps (once per round)
;print,'ntul'
;print,ntul
   choice=choice0
   time=0.
   h=h0
   deh=0.d0

;draw window and define plot region
;plot range depends on method, timestep and eccentricity (let user define)
   if(keyword_set(yrange0)) then yrange0=yrange0 ;else yrange0=[-0.6,0.6]
   nwin
   plot,time/P*[1,1],deh*[1,1],xrange=[0,tmax/P],yrange=yrange0,$
   psym=2,xtitle='Time (in orbital rounds)',ytitle='|dh/h0|',title='Conservation of energy (cumulative error)'

;integration loop
   for i=0l,nsteps-1 do begin

       if(choice eq 3) then begin
           M=2.d0*!dpi/P*(time)
           kepler,M,eks,E
           sine=sin(E)
           cose=cos(E)
           x=a*(cose-eks)
           y=b*sine
           vx=-a*sine*2.d0*!dpi/P/(1-eks*cose)
           vy=b*cose*2.d0*!dpi/P/(1-eks*cose)

           if(i  mod ntul eq 0) then begin
               hold=h
               h=0.5*(vx^2+vy^2)-myy/sqrt(x^2+y^2)
               deh=deh+abs((h-hold)/h0)
               k=x*vy-y*vx
           endif
           time=time+dt
       endif

       if(choice eq 1) then begin
           r=sqrt(x^2+y^2)
           ax=-myy/r^3*x
           ay=-myy/r^3*y
           x=x+vx*dt
           y=y+vy*dt
           vx=vx+ax*dt
           vy=vy+ay*dt

           if(i  mod ntul eq 0) then begin
               hold=h
               h=0.5*(vx^2+vy^2)-myy/r
               deh=deh+abs((h-hold)/h0)
               k=x*vy-y*vx
           endif
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

           if(i  mod ntul eq 0) then begin
               hold=h
               h=0.5*(vx^2+vy^2)-myy/r
               deh=deh+abs((h-hold)/h0)
               k=x*vy-y*vx
           endif
           time=time+dt
       endif

       if(choice eq 0) then begin
           yy=[x,y,vx,vy]
           dydx=inte_simple_func(time,yy)
           res=rk4(yy,dydx,time,dt,'inte_simple_func',/double)
           time=time+dt
           x=res(0) & y=res(1)  & vx=res(2)  & vy=res(3)
           if(i  mod ntul eq 0) then begin
               hold=h
               h=0.5*(vx^2+vy^2)-myy/sqrt(x^2+y^2)
               deh=deh+abs((h-hold)/h0)
               k=x*vy-y*vx
           endif
       endif

;plot?
       if(i  mod ntul eq 0) then oplot,time/P*[1,1],deh*[1,1],psym=2
   endfor

;final energy and angular momentum
   r=sqrt(x^2+y^2)
   h1=0.5*(vx^2+vy^2)-myy/r
   k1=x*vy-y*vx

   if(choice eq 1) then method='Taylor I '
   if(choice eq 2) then method='Taylor II'
   if(choice eq 0) then method='RK4      '
   if(choice eq 3) then method='Kepler   '

   xyouts,0.5,0.9,/normal,ali=0.5,'method='+string(method)+'  dt/PER='+string(dt/period)
   xyouts,0.57,0.85,/normal,ali=0.55,'eccentricity='+string(eks)+'
   print,'method=',method,'  dt/PER=',dt/period
   print,'initial h and k:',h0,k0
   print,'final   h and k:',h1,k1



   nper=tmax/period
   dh=(h1-h0)/abs(h0)/nper
   dk=(k1-k0)/abs(k0)/nper
   print,'dh/|h| and dk/|k| per orbit',dh,dk

end
