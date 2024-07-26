;Muuttujana M. Kutsutaan aliohjelmaa kepler_oma.pro, joka ratkaisee
;E:n annetuilla M:n arvoilla.

a=1
ecc_tab=[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]
M=findgen(201)/200. *2. *!dpi
nwin

for i=0,n_elements(ecc_tab)-1 do begin
   ecc=ecc_tab(i)
   kepler_oma,M,ecc,E

   cose=cos(E)
   sine=sin(E)
   b=a*sqrt(1-ecc^2)
   xx=a*(cose-ecc)
   yy=b*sine

   if (i eq 0) then begin
      plot,xx,yy,/iso,xrange=[-2,2],yrange=[-2,3],xs=1,ys=1,/nod
   endif
   oplot,xx,yy,col=i+2
endfor
st='ecc='+['0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8']
cols=lindgen(8)+2
lines=lindgen(8)*0
label_data,0.1,0.9,st,color=cols,lines=lines,y_inc=0.03
end
