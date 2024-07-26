;*********************************************************
; rv_to_elem.pro
; solves orbital elements from radius and velocity vectors
; HS 6.5.1997 -> 05.11.02 -> 01.11.06
;*********************************************************

pro rv_to_elem,time,rad,vel,elem,$
               print=print,myy0=myy0,kvec=kvec,evec=evec,$
               ene=ene,imp=imp,eano=eano,mano=mano

if(n_params() le 0) then begin
 print,'------------------------------------------------'
 print,'pro rv_to_elem,time,rad,vel,elem'
 print,'    calculates orbital elements from radius and velocity vectors'
 print,'    at a given time'
 print,'------------------------------------------------'
 print,' INPUT:'
 print,'  time = time of observation'
 print,'  rad = [ x, y, z] radius vector'
 print,'  vel = [vx,vy,vz] velocity vector'
 print,' INPUT VIA KEYWORDS:'
 print,'  myy = value   - def: G*(m1+m2) = 1.'
 print,' '
 print,' OUTPUT:'
 print,'  elem=[a,eks,ink,ome,w,tau]'
 print,'       a   = semimajor-axis'
 print,'       eks = eccentricity (>1 -> hyperbolic)'
 print,'       ink = inclination'
 print,'       ome = longitude of ascending node'
 print,'       w   = argument of pericenter'
 print,'       tau = time of pericenter passage' 
 print,' OUTPUT VIA KEYWORDS:'
 print,'  kvec=kvector =[kx,ky,kz]'
 print,'  evec=evector =[ex,ey,ez]'
 print,'  imp=angular momentum/unit mass = |kvec|'
 print,'  ene=energy /unit mass'
 print,'  eano=eccentric anomaly (degrees)'
 print,'  mano=mean anomaly (degrees)'
 print,' '
 print,' ADDITIONAL KEYWORDS:'
 print,'  /print -> some intermediate output'
 print,' HS 6.5.1997 / 22.10.2002 /01.11.2006'
 print,'  '
 return
endif

;defines units
 myy=1.d0
 if(keyword_set(myy0)) then myy=myy0

 pii=atan(1.d0)*4.d0
 ra=180.d0/pii
 ar=pii/180.d0
 
;*************************************************
; inklinaatio ja nousevan solmun pituus
; inclination and the longitude of ascending node
;*************************************************
; cross_product,A,B,C    --> C = A x B    
; dot_product,A,B,c      --> c = A . B   
; here A,B,C denote 3-element vectors, c denotes a scalar
; angle=atan(y,x) returns angle for which y=sin(angle), x=cos(angle)

 cross_product,rad,vel,kvec
 dot_product,kvec,kvec,kk
 n=kvec/sqrt(kk)
 nx=n(0)
 ny=n(1)
 nz=n(2)
 ink=acos(nz)
 ome=atan(nx,-ny)
 imp=sqrt(kk)

;*************************************************
; eksentrisyys ja perihelin argumentti: e-VEKTORI
; eccentricity and the argument of pericenter
;*************************************************

 cross_product,kvec,vel,apu1
 dot_product,rad,rad,r2
 apu2=rad/sqrt(r2)
 evec=-apu1/myy-apu2

;transform evec to the coordinate system aligned
;with the orbital plane

 coso=cos(ome)
 sino=sin(ome)
 cosi=cos(ink)
 sini=sin(ink)

 ex=coso*evec(0)+sino*evec(1)
 ey=-sino*cosi*evec(0)+coso*cosi*evec(1)+sini*evec(2)

 eks=sqrt(ex^2+ey^2)
 w=atan(ey,ex)

;************************************************
;isoakseli 
;semimajor axis
;************************************************

 dot_product,vel,vel,v2
 dist=sqrt(r2)
 h=0.5d0*v2-myy/sqrt(r2)
 ene=h
 a=abs(myy/2.d0/h)
 per=2.0d0*!dpi*sqrt(a^3/myy)

;************************************************
; periheliaika
; time of pericenter passage
;************************************************
;via cos(E) 
;to solve the right sign:

;0   <E < 180 -> r is increasing
;180 <E < 360 -> r is decreasing

 sign=1.
 dot_product,rad,vel,rv
 if(rv lt 0.) then sign=-1.

;******************************************
;elliptic orbit
;just to avoid numerical problems:
 if(eks le 0.) then begin
   e=0.
   m=e
   tau=time
 endif
 if(eks lt 1. and eks gt 0.) then begin
   cose=(1.-dist/a)/eks<1.d0>(-1.d0)
   e=acos(cose)*sign
   m=e-eks*sin(e)
   tau=(time-m*per/2./!dpi) mod per
 endif


;******************************************
;hyperbolic orbit
;acosh-function returns the inverse of hyperbolic cosine
;(in acosh.pro)

 if(eks ge 1.) then begin
   coshe=(1.d0+dist/a)/eks>1.
   e=acosh(coshe)*sign
   m=eks*sinh(e)-e
   tau=time-m*per/2./!pi
 endif

 eano=e*!radeg
 mano=m*!radeg
 elem=[a,eks,ink*!radeg,ome*!radeg,w*!radeg,tau]

 if(keyword_set(print)) then begin
   st=' at T='+string(time)
   print,'-------------------------------------------------'
   if(eks lt 1) then print,'CALCULATED ELEMENTS OF ELLIPTIC ORBIT:'+st
   if(eks gt 1) then print,'CALCULATED ELEMENTS OF HYPERBOLIC ORBIT:'+st
   print,'a   = ',elem(0)
   print,'eks = ',elem(1)
   print,'ink = ',elem(2)
   print,'ome = ',elem(3)
   print,'w   = ',elem(4)
   print,'tau = ',elem(5)
   print,' '
   print,'per = ',per,m*ra
   print,'q   = ',elem(0)*abs(1.-elem(1))
   print,' '
   print,'-------------------------------------------------'
endif

end










