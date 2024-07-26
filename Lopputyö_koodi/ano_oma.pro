;--------------------------------------------------------------;
;Vertaillaan eri anomalioita: E, f ja M
;--------------------------------------------------------------;

myy=1
a=1
ecc=0.2
M=findgen(101)/100. *2. *!dpi
!p.multi=[0,2,2]

;Eccentric anomaly:
   b=a*sqrt(1.-ecc^2)
   kepler_oma,M,ecc,E

;True anomaly:
   cosf=(cos(E)-ecc)/(1.-ecc*cos(E))
   sinf=(sqrt(1-ecc^2)*sin(E))/(1.-ecc*cos(E))
   f=atan(sinf,cosf)
   index=where(f lt 0, count)
   if(count ge 1) then f(index)=f(index)+2.*!pi


;--------------------------------------------------------------;
;Plotataan E ja f M:n funktiona
;--------------------------------------------------------------;
   plot,M,E,xtitle='M (rad)',ytitle='f , E (rad)',xrange=[0,2*!pi],$
           yrange=[0,2*!pi],xs=1,ys=1,title='eccentricity=0.5'
   oplot,M,E,col=2,lines=0
   oplot,M,f,col=3,lines=1
   oplot,M,M,col=4,lines=2
st=['E','f','M']
cols=lindgen(3)+2
lines=lindgen(3)
label_data,0.1,0.9,st,color=cols,lines=lines,y_inc=0.1


;--------------------------------------------------------------;
;Plotataan E-M ja f-M M:n funktiona
;--------------------------------------------------------------;
plot,M,M*0,xtitle='M (rad)',ytitle='f-M , E-M (rad)',xrange=[0,2*!pi],$
           yrange=[-2,2],xs=1,ys=1,title='eccentricity=0.5'
oplot,M,E-M,col=2,lines=0
oplot,M,f-M,col=3,lines=0
st=['E-M','f-M']
label_data,0.1,0.9,st,color=[2,3],lines=[0,0],y_inc=0.1

;--------------------------------------------------------------;
;Vertaillaan laskennallista E-M:הה ja f-M:הה 
;sarjakehitelmiin E-M ja f-M
;--------------------------------------------------------------;

;plotataan E-M
E_ser1=ecc*sin(M)
E_ser2=ecc*sin(M)+ecc^2*(0.5*sin(2*M))
E_ser3=ecc*sin(M)+ecc^2*(0.5*sin(2*M))+ecc^3*(3*sin(3*M)-sin(M))/8

plot,M,E-M,xtitle='M (rad)',ytitle='E , E-M (rad)',xrange=[0,2*!pi],$
           yrange=[-1,1],xs=1,ys=1,title='eccentricity=0.5'
oplot,M,E-M,col=2
oplot,M,E_ser1,col=3,lines=1
oplot,M,E_ser2,col=4,lines=2
oplot,M,E_ser3,col=5,lines=3

;plotataan f-M
f_ser1=2*ecc*sin(M)
f_ser2=2*ecc*sin(M)+ecc^2*(5*sin(2*M)/4)
f_ser3=2*ecc*sin(M)+ecc^2*(5*sin(2*M)/4)+ecc^3*(13*sin(3*M)/12-sin(M)/4)
plot,M,f-M,xtitle='M (rad)',ytitle='E , E-M (rad)',xrange=[0,2*!pi],$
           yrange=[-2,2],xs=1,ys=1,title='eccentricity=0.5'
oplot,M,f-M,col=2
oplot,M,f_ser1,col=3,lines=1
oplot,M,f_ser2,col=4,lines=2
oplot,M,f_ser3,col=5,lines=3

end
