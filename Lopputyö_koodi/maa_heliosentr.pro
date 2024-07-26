;Selvitet‰‰n Maan heliosentrinen paikka sen rataelementtien avulla:

pro maa_heliosentr, Rh_maa, tulosta=tulosta

;Maan rataelementit:
  am=1.
  eccm=0.0167
  inkm=0/!radeg
  w_m=102.94719/!radeg
  Mm=357.51716/!radeg
;  Mm=-2.56756/!radeg


;Ratkaistaan eksentrinen anomalia E:
kepler_oma,Mm,eccm,E

;Ratkaistaan E:n avulla luonnollinen anomalia f:
cosf=(cos(E)-eccm)/(1.-eccm*cos(E))
sinf=sqrt(1.-eccm^2)*sin(E)/(1.-eccm*cos(E))
f=atan(sinf,cosf)
;if keyword_set(tulosta) then print,f
;index=where(f lt 0, count)
;if (count ge 1) then f(index)=f(index)+2.*!dpi

;Maan radiusvektorin pituus:
rm=am*(1.-eccm*cos(E))

;Maan heliosentriset ekliptikakoordinaatit:
xm=rm*cos(w_m+f)
ym=rm*sin(w_m+f)
zm=0

;Maan heliosentrinen radiusvektori:
Rh_maa=[xm,ym,zm]

if keyword_set(tulosta) then print,Rh_maa

end
