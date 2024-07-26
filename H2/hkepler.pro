;***************************************************************
;	RATKAISTAAN HYBERPOLINEN EKSENTRINEN ANOMALIA E
;	ITEROIMALLA KESKIANOMALIASTA M
;	RADAN EKSENTRISYYS = EKS > 1
;***************************************************************

	pro hkepler,m,eks,e,itul=itul,itemax=itemax,check=check

;***************************************************************
   if(n_params() le 0) then begin
       print,'---------------------------------------------'
       print,' hkepler,M,eks,E'
       print,'---------------------------------------------'
       print,' SOLVES KEPLER-EQUATION for HYPERBOLIC ORBIT
       print,' M = eks*sinh(E) - E,    eks>1' 
       print,' USING NEWTON-ITERATION'
       print,' input:   M = mean anomaly (radians), eks=eccentricity '
       print,' output:  E = eccentric anomaly (radians)'
       print,' keywords: '
       print,'   /itul  -> output iteration values (E)'
       print,'   /check -> check accuracy of solution'
       print,'   itemax =  max number of iterations (def=500)'
       print,' example:  eks=3, M= 45 degrees, output iteration values'
       print,"   hkepler,45./!radeg,3.,e,/itul & print,'E=',e*!radeg,' deg'"
       print,' HS 04.10.02 /01.11.06'
       print,'---------------------------------------------'
   return
 endif
;***************************************************************
;Newton iteration for solving  f=eks*sinh(E)- E - M = 0
; E_NEW = E_OLD - f(E)/(df(E)/dE)
; until abs(E_NEW-E_OLD) < 1d-10

	nstep=5000
	if(keyword_set(itemax)) then nstep=itemax

;choose the intitial guess
	e=m
	if(abs(m) gt exp(1)) then e=m/abs(m)*alog(2.*abs(m)/eks)

	i=0
	if(keyword_set(itul)) then print,i,e
	for i=1,nstep do begin
            fe=eks*sinh(e)-e-m
            fep=eks*cosh(e)-1.d0
            eold=e
            e=eold-fe/fep
            if(abs(e-eold) lt 1d-10*abs(e)) then goto,jump11
            if(keyword_set(itul)) then print,i,e
        endfor
        jump11: 
        if(keyword_set(check)) then print,m-(eks*sinh(e)-e)
	return
	end






