;***************************************
; kepler_demo.pro (HS 2002/1.11.2006,/17.11.2008)
;***************************************

;use kepler.pro for solving E for M=45 degrees
;with accuracy of 0.001 degrees

;for eccentricities 0.01, 0.05, 0.50, 0.90, 0.99
;kepler.pro: use without arguments -> prints info


 M=45./!radeg         ; !radeg = system variable 180/pi
;M=359./!radeg        ; try also this

 tole=0.01/!radeg

 print,'----------------------------------------'
 kepler,M,0.01,e,/itul,tole=tole
 
 print,'----------------------------------------'
 kepler,M,0.05,e,/itul,tole=tole
 
 print,'----------------------------------------'
 kepler,M,0.50,e,/itul,tole=tole
 
 print,'----------------------------------------'
 kepler,M,0.90,e,/itul,tole=tole ;7 steps 
 
 print,'----------------------------------------'
 kepler,M,0.99,e,/itul,tole=tole ;9 steps
 
 print,'----------------------------------------'

end
