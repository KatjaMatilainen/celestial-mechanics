;------------------------------------------------------
program='tm2008_harj1_12'
;------------------------------------------------------

;Taivaanmekaniikan laskuharjoitus 1, tehtava 12:
;Jupiterin paikka taivaalla 1.1.2000

;kaytetaan elem_to_rv ohjelmaa apuna: laskee rataelemetit ->
;heliosentrinen paikka ekliptika-systeemissa

;lasketaan Jupiterin ja Maan paikkojen erotus, muunnetaan
;ekvaattori-systeemiin -->  alpha,dec


;------------------------------------------------------
;Jupiterin rataelementit  
;(luennolla jaettu kopio tähtitieteen perusteet kirjasta)
;------------------------------------------------------

  a=5.20336301d0
  eks=0.04839266d0
  ink=1.30530d0
  ome=100.55616d0   
  wp=14.75385d0                 ;perihelin pituus (solmuviivasta)
  L=34.40438d0                  ;keskipituus   (solmuviivasta) 

;lasketaan naista:
  w=wp-ome                      ;perisentrin argumenttti 
  M=L-wp                        ;keskianomalia 


;Käytetään suoraan keskianomaliaa
  tau=0.                        ;dummy, silla kaytetaan suoraan keskianomaliaa
  time=0.                       ;-"-

;HUOM katso elem_to_rv ohjelman helppi!

  elem=[a,eks,ink,ome,w,tau]
  elem_to_rv,elem,time,rad,vel,m0=M/!radeg

  rad_jup=rad                   ;jupiterin paikka vektori

;------------------------------------------------------
;Maan ratalementit
;------------------------------------------------------

  a=1.00000011d0
  eks=0.01671022d0
  ink=0.00005d0
  ome=-11.26064d0
  wp=102.94719d0
  L=100.46435d0

  w=wp-ome                      ;perisentrin argumenttti 
  M=L-wp                        ;keskianomalia 

  tau=0.                        ;dummy, silla kaytetaan suoraan keskianomaliaa
  time=0.                       ;-"-

  elem=[a,eks,ink,ome,w,tau]
  elem_to_rv,elem,time,rad,vel,m0=M/!radeg

  rad_maa=rad

;erotus:  ekliptika-systeemi
  x=rad_jup(0)-rad_maa(0)
  y=rad_jup(1)-rad_maa(1)
  z=rad_jup(2)-rad_maa(2)
  
;erotus: ekvaattori-systeemi
  ekli=23.4393
  sine=sin(ekli/!radeg)
  cose=cos(ekli/!radeg)

  xe=x
  ye=y*cose-z*sine
  ze=y*sine+z*cose
  
  re=sqrt(xe^2+ye^2+ze^2)
  delta=asin(ze/re)*!radeg
  alpha=atan(ye,xe)*!radeg
  
  print,'Jupiter 1.1.2000:'
  print,'etaisyys',re
  print,'deklinaatio',delta
  print,'rektaskensio',alpha
  
  
;astro-kirjaston ADSTRING  muunnos
;asteet -> tunnit,minuutit sekunnit
  print,adstring(delta)
  print,adstring(alpha)


end
