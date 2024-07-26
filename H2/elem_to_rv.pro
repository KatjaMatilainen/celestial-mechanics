;************************************************************
; elem_to_rv.pro
; solves R and V from orbital elements
; HS 6.5.1997 -> 05.11.02 / 01.11.06
;************************************************************

pro elem_to_rv,elem,time,rad,vel,myy0=myy0,eano=eano,mano=mano,m0=m0

 if(n_params() le 0) then begin
	print,'------------------------------------------------'
        print,'elem_to_rv,elem,time,rad,vel,myy0=myy0,m0=m0'
        print,'     calculates radius- and velocity-vector at a given time'
        print,'     from the orbital elements'
	print,'------------------------------------------------'
	print,' INPUT:'
        print,'  elem = orbital elements [a,eks,ink,ome,w,tau]'
	print,'       a   = semimajor-axis'
        print,'       eks = eccentricity (>1 -> hyperbolic)'
        print,'       ink = inclination'
	print,'       ome = longitude of ascending node'
	print,'       w   = argument of pericenter'
	print,'       tau = time of pericenter passage' 
	print,'  time = instant of time'
        print,'         NOTE: angles in degrees'
	print,' INPUT VIA KEYWORDS:'
        print,'  myy = G (m1+m2)  : def=1'
        print,'  m = mean anomaly in radians, use instead of that calculated'
        print,'      from n*(time-tau)  (in this case time,tau have no effect)'
        print,''
        print,' OUTPUT:'
        print,'  rad,vel = radius and velocity vector'
        print,' OUTPUT VIA KEYWORDS:'
        print,'  /print -> print info'
        print,'   eano=eano eccentric anomaly (degrees)'
	print,'   mano=mano mean anomaly (degrees)'
        print,' HS 6.5.1997 / 22.10.2002 / 01.11.2006 /09.11/2008'
	print,'------------------------------------------------'
 	return
 endif

	pii=atan(1.d0)*4.d0
	ra=180.d0/pii
	ar=pii/180.d0
	myy=1.d0
	if(keyword_set(myy0)) then myy=myy0

;*************************************************
;	ap=isoakseli                  semimajor axis
;	eps=eksentrisyys              eccentricity
;	ink=inklinaatio               inclination  
;	ome=nousevan solmun pituus    longitude of node
;	w=perihelin argumentti        argument of pericenter
;	tau=periheliaika              pericenter time
;*************************************************
	
	ap=elem(0)
	eps=elem(1)
	ink=elem(2)
	ome=elem(3)
	w=elem(4)
	tau=elem(5)

	ink=ink*ar
	ome=ome*ar
	w=w*ar
	bp=ap*sqrt(abs(1.d0-1.d0*eps*eps))

;******************************************************************
;	Orbital vectors ii,jj,kk  
;******************************************************************
;       define orientation of orbit with respect to reference axis 
;       (idl-arrays start at zero: here zero-elements are dummies!)

	ii=dblarr(4) & jj=ii & kk=ii	
	sino=sin(ome)
	coso=cos(ome)
	sini=sin(ink)
	cosi=cos(ink)
	sinw=sin(w)
	cosw=cos(w)
	
	ii(1)=cosw*coso-sinw*sino*cosi
	ii(2)=cosw*sino+sinw*coso*cosi
	ii(3)=sinw*sini

	jj(1)=-sinw*coso-cosw*sino*cosi
	jj(2)=-sinw*sino+cosw*coso*cosi
	jj(3)=cosw*sini

	kk(1)=sino*sini
	kk(2)=-coso*sini
	kk(3)=cosi

;******************************************************************
;mean anomaly
;******************************************************************

	per=2.d0*pii*sqrt(ap*ap*ap/myy)
	m=2.d0*pii/per*(time-tau)

        if(keyword_set(m0)) then m=m0

;******************************************************************
;solve eccentric anomaly
;******************************************************************

;cheat a bit: parabolic orbit described by a highly elliptic orbit
 if(eps eq 1) then begin
        eps=.999999
        a=10000.
 endif

;elliptic orbit - Kepler's equation

 if(eps le 1) then begin
   	kepler,m,eps,e
	dedt=sqrt(myy/ap^3)/(1.d0-eps*cos(e))
	xx=ap*(cos(e)-eps)
	yy=bp*sin(e)
	vxx=-ap*sin(e)*dedt
	vyy=bp*cos(e)*dedt
	if(e lt 0.) then e=e+!pi*2.d0
 endif

;hyperbolic orbit - hyperbolic Kepler's equation

 if(eps gt 1) then begin
        hkepler,m,eps,e
        dedt=sqrt(myy/ap^3)/(eps*cosh(e)-1.d0)
	xx=ap*(eps-cosh(e))
	yy=bp*sinh(e)
	vxx=-ap*sinh(e)*dedt
	vyy=bp*cosh(e)*dedt
 endif

	mano=m*ra
	eano=e*ra

;******************************************************************
;       convert coordinates from orbit-coordinates
;       to the reference frame
;******************************************************************

	x=xx*ii(1)+yy*jj(1)
	y=xx*ii(2)+yy*jj(2)
	z=xx*ii(3)+yy*jj(3)

	vx=vxx*ii(1)+vyy*jj(1)
	vy=vxx*ii(2)+vyy*jj(2)
	vz=vxx*ii(3)+vyy*jj(3)

	rad=[x,y,z]
	vel=[vx,vy,vz]

    end









