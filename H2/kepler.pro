;****************************************************************************
;	RATKAISTAAN KEPLERIN YHTALOSTA EKSENTRINEN ANOMALIA E
;	ITEROIMALLA KESKIANOMALIASTA M
;	RADAN EKSENTRISYYS = EKS
;****************************************************************************

	pro kepler,m,eks,e,itul=itul,itemax=itemax,check=check,tole0=tole0

;****************************************************************************
 if(n_params() le 0) then begin
   print,'---------------------------------------------'
   print,' kepler,M,eks,E'
   print,'---------------------------------------------'
   print,' SOLVES KEPLER-EQUATION M = E - eks*sin(E)' 
   print,' USING SUBSTITUTION ITERATION'
   print,' input:   M = mean anomaly (radians), eks=eccentricity '
   print,' output:  E = eccentric anomaly (radians)'
   print,' keywords: '
   print,'   /itul  -> output iteration values (E)'
   print,'   /check -> check accuracy of solution'
   print,'   itemax =  max number of iterations (def=500)'
   print,'   tole   =  desired accuracy  (def=1d-10)'
   print,' example:  eks=0.5, M= 45 degrees, output iteration values'
   print,"   kepler,45./!radeg,0.5,e,/itul & print,'E=',e*!radeg,' deg'"
   print,' HS 04.10.02 '
   print,'---------------------------------------------'
   return
 endif

;****************************************************************************
; solve eccentric anomaly E from mean anomaly M, for eccentricity EKS
; using substitution iteration
;  M= E - eks*sin(E)  -> E = M + eks*sin(E)
; iteration: 
;  E_OLD = M + eks * sin(M)/(1-eks*cos(M))  first guess
;  E_NEW = M + eks * sin(E_OLD)             until abs(E_NEW-E_OLD) < tole
;****************************************************************************
	nstep=500
	if(keyword_set(itemax)) then nstep=itemax

        tole=1d-10
	if(keyword_set(tole0)) then tole=tole0

	i=0
	e=m+eks*sin(m)/(1.d0-eks*cos(m))

	if(keyword_set(itul)) then begin
	  print,' M   = ',m*!radeg,' degrees'
	  print,' EKS = ',eks
          print,'      step      E (rad)         E(deg)         dE(deg) '
	endif
	if(keyword_set(itul)) then print,i,e,e*!radeg

	for i=1,nstep do begin
	  e_new=m+eks*sin(e)
          de=e_new-e
	  e=e_new
	  if(keyword_set(itul)) then print,i,e,e*!radeg,de*!radeg
	  if(abs(de) lt tole) then goto,end_ite
	endfor

	end_ite: 

        if(keyword_set(check)) then $
           print,'M - (E-eks*sin(E)) =',m-(e-eks*sin(e))
	return
	end
















