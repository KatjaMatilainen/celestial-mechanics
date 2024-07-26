;*******************************************
; inte_perp.pro
;*******************************************
;Integrate 2-body equations with Runge-Kutta 4 method
;add perturbations F = alfa * R/r + beta * V/v + gamma * N
;  at the directions of R/r, V/v, N
;  at the specific E-intervals
;For the course of celestial mechanics, Fall 2002/2006 (HS)

pro inte_perp,elem,t1,t2,dt,output0=output0,myy0=myy0,example=example,$
              e10=e10,e20=e20,alfa0=alfa0,beta0=beta0,gamma0=gamma0,fimp=fimp,$
              save0=save0,outsave0=outsave0,fric=fric,final_elem=final_elem,$
              orb=orb,rtable=rtable,ttable=ttable,silent=silent

  if(n_params() le 0) then begin
      print,'pro inte_perp,elem,t1,t2,dt,output=output,myy=myy,orb=orb'
      print,' '
      print,'Cartesian integration of perturbed 2-body orbit'
      print,'elem=[a,e,i,ome,w,tau]   initial orbital elements'
      print,'t1,t2                    integration time interval'
      print,'dt                       time step'
      print,'KEYWORDS:'
      print,'final_elem               returns final table of orbital elements'
      print,'ttable,rtable            returns,t(*),r(*,3)' 
      print,'output                   output interval in steps (def=nsteps/10)'
      print,'myy                      G * (m1+m2)   def=1.'
      print,'/orb                     -> t1,t2,dt given in orbital periods'
      print,'/example                 example of integration:'
      print,'                            a=1,ecc=0.5,i=10,ome=90,w=0,tau=0'
      print,'                            t1=0, t2=10*PER, dt=0.01*PER,'
      print,'                            (inserted to elem)'
      print,'inte_perp,elem,t1,t2,dt,/example'
      print,' '
      print,'save=filename ->         save ttable,rtable,vtable,elemtable'
      print,"                         default='inte_perp.save'"
      print,'outsave ->               store every outsave steps (def=10)'
      print,' '
      print,'PERTURBATION PARAMETERS'
      print,'alfa,beta,gamma: F = alfa * R/r + beta * V/v + gamma * N'
      print,'E1,E2: perturbation affects on the ecc anom  interval:'
      print,'                                     E1 - E2 (degrees)'
      print,'/fimp -> scale perturbation with 1/DE (impulsive perturbation)'
      print,' '
      print,'-----------------------------------------------------------'
      return
  endif

;**********************************************************************
   common inte_perp_com,myy,alfa,beta,gamma
   ra=180.d0/!dpi
   ar=!dpi/180.d0
   
;IDL save-file to store the integration results
   savefile='inte_perp.save'
   if(keyword_set(save0)) then savefile=save0

;storing interval
   outsave=10
   if(keyword_set(outsave0)) then outsave=outsave0

   myy=1.d0
   if(keyword_set(myy0)) then myy=myy0

   if(keyword_set(example)) then begin
       t1=0.d0
       t2=10*2.d0*!dpi
       dt=0.01d0*2.*!dpi
       elem=[1.0, 0.5, 10., 90., 0., 0.]*1.d0
   endif
  
   t1=t1*1.d0
   t2=t2*1.d0
   dt=dt*1.d0  
   torb=2.d0*!dpi*sqrt(elem(0)^3/myy)
   per=torb
   eks=elem(1)
   tau=elem(5)
   if(keyword_set(orb)) then begin
       t1=t1*torb
       t2=t2*torb
       dt=dt*torb
   endif
   
;********************************************************
; perturbation: normalized to central force at r=a0 orbit
; E-interval from E1,E2: alfa=alfa1, otherwise zero 
; (same with beta,gamma)
; e1,e2 in degrees
; alfa1,beta1,gamma1 = input values
; alfa ,beta ,gamma = current values
;********************************************************

   fac=myy/elem(0)^2
   e1=-1.d6
   e2= 1.d6
   alfa1=0.d0
   beta1=0.d0
   gamma1=0.d0
   if(keyword_set(alfa0)) then alfa1=alfa0*1.d0*fac
   if(keyword_set(beta0)) then beta1=beta0*1.d0*fac
   if(keyword_set(gamma0)) then gamma1=gamma0*1.d0*fac  
   alfa=alfa1
   beta=beta1
   gamma=gamma1   
   if(keyword_set(e10)) then e1=e10*1.d0
   if(keyword_set(e20)) then e2=e20*1.d0
   if(keyword_set(fimp)) then fac=fac/(e2-e1)*360.
   
;eflag = 1 if eccentric anomaly needs to be calculated:
; this is the case if E-interval defined 
; AND perturbation is added
   eflag=0
   if(keyword_set(e10) or keyword_set(e20)) then begin
       if(alfa1  ne 0) then eflag=1
       if(beta1  ne 0) then eflag=1
       if(gamma1 ne 0) then eflag=1
   endif
   
;*******************************************************
; original R,V
;*******************************************************
   elem_to_rv,elem,t1,rad,vel
   rv_to_elem,t1,rad,vel,elem2,kvec=kvec,evec=evec,ene=ene0,imp=imp0

   nsteps=long((t2-t1)/dt)
   time=t1
   output=long(nsteps/10.)
   if(keyword_set(output0)) then output=output0
  
   if(not keyword_set(silent)) then begin      
       print,'--------------------------------------------------------'
       print,'CARTESIAN RK4 INTEGRATION OF PERTURBED 2-BODY MOTION'
       print,'--------------------------------------------------------'      
       print,'MYY= G* (m1+m2) = ',myy
       print,'PERIOD = ',per
       print,'T1,T2,DT (in periods) = ',t1/per,t2/per,dt/per
       print,'NSTEPS, OUTPUT = ',nsteps,output
       print,'ALFA, BETA, GAMMA = ',alfa1,beta1,gamma1
       print,'E1,E2 (degrees)',e1,e2      
       print,' '
       ff='(f10.4,6f12.6,2e12.2)'
       otsi='     T/PER      AMAJ        ECC         INC         OME         W'
       otsi=otsi+'         TAU          dL/L         dE/E'      
       print,otsi
       print,time,elem,imp0,ene0,f=ff
   endif
   elem0=elem

;****************************
; for saving results   
   nsave=nsteps/outsave+2
   ttable=dblarr(nsave)
   rtable=dblarr(nsave,3)
   vtable=dblarr(nsave,3)
   elemtable=dblarr(nsave,6)
   enetable=dblarr(nsave,2)  
   ttable(0)=t1
   rtable(0,0:2)=rad
   vtable(0,0:2)=vel
   elemtable(0,0:5)=elem
   isave=0

;***********************************************
;integration
;***********************************************
  
   for i=0l,nsteps do begin

; check if perturbation is in effect
       if(eflag eq 1) then begin
           elem_to_rv,elem,time,rad0,vel0,eano=e
           alfa=0.d0
           beta=0.d0
           gamma=0.d0
           if(e ge e1 and e le e2) then begin
               alfa=alfa1*fac
               beta=beta1*fac
               gamma=gamma1*fac
           endif
       endif      
       yy=[rad,vel]
       dydx=inte_perp_func(time,yy)
       res=rk4(yy,dydx,time,dt,'inte_perp_func',/double)
       rad=res(0:2)
       vel=res(3:5)
       time=time+dt
      
;output?
       if(not keyword_set(silent)) then begin
           if(i+1 eq ((i+1)/output)*output) then begin
               rv_to_elem,time,rad,vel,elem2,imp=imp,ene=ene
               dimp=(imp-imp0)/imp0
               dene=(ene-ene0)/ene0
               print,time/per,elem2,dimp,dene,f=ff
           endif
       endif
       
;save?      
       if(i+1 eq ((i+1)/outsave)*outsave) then begin
           rv_to_elem,time,rad,vel,elem2,imp=imp,ene=ene
           isave=isave+1
           ttable(isave)=time
           rtable(isave,0:2)=rad
           vtable(isave,0:2)=vel
           elemtable(isave,0:5)=elem2
           enetable(isave,0:1)=[imp,ene]
       endif       
   endfor
  
   rv_to_elem,time,rad,vel,final_elem,imp=imp,ene=ene
  
   ttable=ttable(0:isave)
   elemtable=elemtable(0:isave,*)
   rtable=rtable(0:isave,*)
   vtable=vtable(0:isave,*)
   fiitable=atan(rtable(*,1),rtable(*,0))*ra
   radtable=sqrt(rtable(*,0)^2+rtable(*,1)^2)
  
   save,file=savefile,t1,t2,dt,myy,per,nsteps,output,$
     alfa1,beta1,gamma1,e1,e2,elem,final_elem,$
     ttable,rtable,elemtable,vtable,enetable,fiitable,radtable
   
   if(not keyword_set(silent)) then begin
       print,'to restore saved data:'
       print,'restore,"'+savefile+'"'
   endif  
end
