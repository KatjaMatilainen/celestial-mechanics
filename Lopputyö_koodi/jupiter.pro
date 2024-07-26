;Aliohjelma, jolla määritetään Jupiterin paikka Maan
;ratatasokoordinaatistossa.
;Ohjelmaan syötetään Jupiterin radan rataelementit.

pro jupiter,elem,I,J,K,tulosta=tulosta

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

;  if keyword_set(tulosta) then print,x,y

;Lausutaan Jupiterin ratatasokoordinaatiston kantavektorit Maan
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

if keyword_set(tulosta) then print,I,J,K

end
