;Aliohjelma, joka selvittää planeetan heliosentrisen paikkavektorin.
;Ohjelmaan syötetään planeetan radan rataelementit.

pro r_heliosentr,elem,Rh_planet,tulosta=tulosta

  if n_params() eq 0 then begin
     print, 'Rataelementit syötetään vektorina:'
     print, 'elem = [a,ecc,ink,ome,w,M]'
     print, 'a = isoakselin puolikas'
     print, 'ecc = eksentrisyys'
     print, 'ink = inklinaatio'
     print, 'ome = nousevan solmun pituus'
     print, 'w = perisentrin argumentti'
     print, 'M = keskianomalia'
     print, 'Kulmat annetaan asteina.'
     return
  endif

;Rataelementit (poimitaan syötetystä vektorista):
  a=elem(0)
  ecc=elem(1)
  ink=elem(2)/!radeg
  ome=elem(3)/!radeg
  w=elem(4)/!radeg
  M=elem(5)/!radeg

;Ratkaistaan E annetusta keskianomaliasta M:
  b=a*sqrt(1-ecc^2)
  kepler_oma,M,ecc,E

;Lasketaan x- ja y-koordinaatit planeetan ratatasossa:
  x=a*(cos(E)-ecc)
  y=b*sin(E)
  z=0

;Lausutaan planeetan ratatasokoordinaatiston kantavektorit Maan
;ratatasokoordinaatistossa:

I=[(cos(w)*cos(ome)-sin(w)*sin(ome)*cos(ink)),$
   (cos(w)*sin(ome)+sin(w)*cos(ome)*cos(ink)),$
   (sin(w)*sin(ink))]

J=[(-sin(w)*cos(ome)-cos(w)*sin(ome)*cos(ink)),$
   (-sin(w)*sin(ome)+cos(w)*cos(ome)*cos(ink)),$
   (cos(w)*sin(ink))]

K=[(sin(ome)*sin(ink)),$
    (-cos(ome)*sin(ink)),$
    (cos(ink))]

;Lopputuloksena saadaan heliosentrinen radiusvektori:
Rh_planet=x*I+y*J+z*K

if keyword_set(tulosta) then begin
print,'radiusvektori:',Rh_planet
if tulosta eq 2 then begin
elem_to_rv,elem,0,rad,m0=M,vel
;print,'radiusvektori:',Rh_planet
print,'tarkistus:',rad
print,vel

rv_to_elem,0,rad,vel,elem2
print,'rataelementit',elem2

endif
endif
end
