program='tm2008_harj1_12_rata'
ps=0

;jatkoa ohjelmalle tm2008_har1_12.pro
;lasketaan 1.1.2000 sijainnin sijasta Jupiterin
;naennainen rata vuosina 2000-2020

;Kaytetaan Tahtitieteen perusteet Taulukon D.12 rataelementteja
;eli v. 2000.0 rataelementteihin lisataan aikaan verrannolliset
;korjaukset
;huom: tehdaan kaikki laskenta kaksoistarkkuudella

;----------------------------------------------------------
;lasketaan rata 2000-2020  (21 vuoden ajalle)

  timet=dindgen(2100)/100.       ; aika vuosina 21 vuotta, 0.01 vuoden valein
  tday=timet*365.25d0              ; aika vuorokausina 1.1.2000 lahtien
  tcen=tday/36525.d0                  ; aika vuosisatoina

;tallennetaan taulukoihin

;declinaatio, rektaskensio
  deltat=timet
  alphat=timet

;latitudi, longitudi ekliptika systeemissa
  lattab=timet
  lontab=timet

  for i=0l,n_elements(timet)-1 do begin

     T=tcen(i)                  ;aika juliaanisina vuosisatoina

;------------------------------------------------------
;Jupiterin rataelementit : lisataan korjaukset (HUOM yksikot!)
;------------------------------------------------------

     a   =  5.20336301     + 0.00060737*T
     eks =  0.04839266     - 0.00012880*T
     ink =  1.30530        - 4.15/3600.*T          
     ome =100.55616        + 1217.17/3600.*T       
     wp  = 14.75385        + 839.93/3600.*T  ;perihelin pituus (solmuviivasta)
     L   = 34.40438        + 0.08308676*tday(i) ;keskipituus   (solmuviivasta) 
  
     w=wp-ome                   ;perisentrin argumenttti 
     M=L-wp                     ;keskianomalia 

     tau=0.d0   ;dummy, silla annateaan M suoraan
     elem_jup=[a,eks,ink,ome,w,tau]
     M_jup=(M mod 360.d0)/360.d0*2.*!dpi

;------------------------------------------------------
;Maan ratalementit
;------------------------------------------------------

     a   =  1.00000011    - 0.00000005*T
     eks =  0.0167102     - 0.00003804*T
     ink =  0.00005       - 46.94/3600.*T
     ome =-11.26064       - 18228.25/3600.*T
     wp = 102.94719       + 1198.28/3600*T
     L  = 100.46435       + 0.98560910*tday(i)
     
     w=wp-ome                   ;perisentrin argumenttti 
     M=L-wp                     ;keskianomalia 
     
     elem_maa=[a,eks,ink,ome,w,tau]
     M_maa=(M mod 360.d0)/360.d0*2.*!dpi
     

     time=0.d0           ;dummy koska kaytetaan M
     elem_to_rv,elem_jup,time,rad,vel,M0=M_JUP
     rad_jup=rad
     
     elem_to_rv,elem_maa,time,rad,vel,M0=M_maa
     rad_maa=rad
  

;erotus:  ekliptika-systeemi
     x=rad_jup(0)-rad_maa(0)
     y=rad_jup(1)-rad_maa(1)
     z=rad_jup(2)-rad_maa(2)
     r=sqrt(x^2+y^2+z^2)
     
     lattab(i)=asin(z/r)*!radeg
     lontab(i)=atan(y,x)*!radeg
     
;erotus: ekvaattori-systeemi
;kierretaan ekliptikan kaltevuuden verran

     ekli=23.43928d0
     sine=sin(ekli/!radeg)
     cose=cos(ekli/!radeg)
     
     xe=x
     ye=y*cose-z*sine
     ze=y*sine+z*cose
     
     re=sqrt(xe^2+ye^2+ze^2)
     delta=asin(ze/re)*!radeg
     alpha=atan(ye,xe)*!radeg

     if(alpha le 0) then alpha=alpha+360.
     
     deltat(i)=delta
     alphat(i)=alpha

  endfor


;--------------------------------------------------------------
;piirretaan rata ekliptika-systeemissa

;psdirect,program+'_a',ps,/color

  nwin
  plot,lontab,lattab,xtitle='longitudi pitkin elliptikaa',$
       title='Jupiterin rata 2000 -2020', ytitle='latitudi',psym=3

;psdirect,program+'_a',ps,/color,/stop



;----------------------------------------
;tarkistuksen vuoksi lasketaan kayttaen 
;ASTRO-kirjaston planet_coords proseduuria
  
;juldate palauttaa redusoidun Julian Date
; = JD-2400000.0

;alkuhetkelle
  juldate,[2000.,1.,1],jd0
  jd0=jd0+2400000.d0

  jd=jd0+tday                   ;ylla maaritellyt ajanhetket -> JD

  planet_coords,jd,/jd,ra_astro,dec_astro,planet='jupiter'

;tarkempi, kayttaen JPL ephemerideja
  planet_coords,jd,/jd,ra_jpl,dec_jpl,planet='jupiter',/jpl

;---------------------------------------------------
;  psdirect,program+'_b',ps,/color
  nwin
  !p.multi=[0,2,2]
  !p.charsize=0.7

  plot,2000+timet,deltat,xr=[0,20]+2000,$
       xtitle='Vuosi',ytitle='Jupiterin deklinaatio',psym=3

;plotaan vain joka 20 piste
  index=lindgen(n_elements(timet)/20)*20

  oplot,2000+timet(index),dec_astro(index),col=2,psym=6,syms=0.5
  oplot,2000+timet(index),dec_astro(index),col=3,psym=1,syms=0.5
  
  
  plot,2000+timet,alphat,xr=[0,20]+2000,$
       xtitle='Vuosi',ytitle='Jupiterin rektaskensio',psym=3
  
  oplot,2000+timet(index),ra_astro(index),col=2,psym=6,syms=0.5
  oplot,2000+timet(index),ra_astro(index),col=3,psym=1,syms=0.5
  
  
  plot,2000+timet,(deltat-dec_jpl)*60.,xr=[0,20]+2000,$
       xtitle='Vuosi',ytitle='deklinaation virhe (arcmin)',psym=3
  
;alkuperaiset alpha ja ra_jpl voivat poiketa 360 verran 
  d_alpha=atan(tan((alphat-ra_jpl)/!radeg))*!radeg


  plot,2000+timet,d_alpha*60,xr=[0,20]+2000,$
       xtitle='Vuosi',ytitle='rektaskension virhe (arcmin)',psym=3

;  !p.charsize=1  
;  !p.multi=0
;  psdirect,program+'_b',ps,/color,/stop
  



end
