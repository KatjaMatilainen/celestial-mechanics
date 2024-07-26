;**********************************************************
;elem_rv_example.pro
;**********************************************************
;example of using the procedures
;   elem_to_rv  : orbital elements -> R,V  at given t
;   rv_to_elem  : R,V at given t -> orbital elements
;HS 22.10.2002/01.11.06
;**********************************************************

   print,'--------------------------------------------------'
   print,'CHECK THE PROCEDURES:'
   print,' elem_to_rv  : orbital elements -> R,V  at given t'
   print,' rv_to_elem  : R,V at given t -> orbital elements '
   print,'--------------------------------------------------'

;******************************************************
;ELLIPTIC ORBIT
;******************************************************
   a=1.7                        ;semimajor axis
   eks=0.1                      ;eccentricity
   ink=10.                      ;inclination
   ome=40.                      ;longitude of ascending node
   w=20.                        ;argument of pericenter
   tau=0.1                      ;time of pericenter passage 
   elem0=[a,eks,ink,ome,w,tau]

   time=0.7
   elem_to_rv,elem0,time,rad,vel
   rv_to_elem,time,rad,vel,elem1

   print,'original elements: elliptic orbit'
   print,'         a         eks        ink         ome          w         tau'
   print,elem0,f='(6f12.6)'
   print,'new elements'
   print,elem1,f='(6f12.6)'
      
;******************************************************
;HYPERBOLIC ORBIT
;******************************************************

   a=1.7                        ;semimajor axis
   eks=1.1                      ;eccentricity
   ink=10.                      ;inclination
   ome=40.                      ;longitude of ascending node
   w=20.                        ;argument of pericenter
   tau=0.1                      ;time of pericenter passage 
   elem0=[a,eks,ink,ome,w,tau]

   time=0.7
   elem_to_rv,elem0,time,rad,vel
   rv_to_elem,time,rad,vel,elem1

   print,'--------------------------------------------------'
   print,'original elements: hyperbolic orbit'
   print,'         a         eks        ink         ome          w         tau'
   print,elem0,f='(6f12.6)'
   print,'new elements'
   print,elem1,f='(6f12.6)'
   print,'--------------------------------------------------'
end
