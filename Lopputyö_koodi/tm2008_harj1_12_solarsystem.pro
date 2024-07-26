print,'inner solar system'
print,'example of using helio, juldate,daycnv from ASTRO'

;juldate palauttaa redusoidun Julian Date
; = JD-2400000.0
juldate,[2000.,1.,1],jd0
jd0=jd0+2400000.d0

timet=dindgen(2100)/100.*2*!pi   ; 21 vuotta, 0.01 valein
jd=timet*365.25636/2.d0/!dpi+jd0  

nwin

xylim,10  ;just up to saturn
;xylim,50  ;show also outer Solar System


plot,lindgen(2),lindgen(2),/nod,/iso
plots,0,0,psym=1
for i=0,n_elements(timet)-1 do begin


  if(i ne 0) then begin

;piirretaan edelliset sijainnit mustalla 
      oplot,hrad*cos(hlong),hrad*sin(hlong),psym=1,col=0

;JD -> kalenteripaiva  
      daycnv,jd(i-1),yr, mn, day   
      
;liitetaan yr,mn,day sopivasti formatoituna yhteen merkkimuuttujaan 
      timestring=string(yr,'(I4)')+'-'+string(mn,'(I2)')+'-'+string(day,'(I2)')

;kirjoitetaan mustalla
      xyouts,0.5,0.9,/normal,timestring,align=0.5,col=0,chars=2
   endif
   
;astro-kirjasto
   helio,jd(i),lindgen(9)+1,hrad,hlong,hlat,/rad

;piirretaan uudet sijainnit valkoisella
   oplot,hrad*cos(hlong),hrad*sin(hlong),psym=1
      daycnv,jd(i),yr, mn, day
      timestring=string(yr,'(I4)')+'-'+string(mn,'(I2)')+'-'+string(day,'(I2)')
      xyouts,0.5,0.9,/normal,timestring,align=0.5,col=255,chars=2

;odotetaan
   wait,.02
endfor


defplot
end

