;-------------------------------------------------------------------------;
;Vertaillaan numeerisesti m‰‰ritettyj‰ aikakeskiarvoja <r>, <r^2> jne
;analyyttisesti saatuihin arvoihin.
;-------------------------------------------------------------------------;

;Printtaus:
;ps=0
;psdirect,'aver_oma',ps,/color

;K‰ytetyt eksentrisyyden yms arvot:
myy=1.
a=1.d0
M=dindgen(2000)/2000*2*!dpi
ecc_tab=dindgen(20)/20

;Tyhj‰t taulukot keskiarvoja varten:
rmean_tab=ecc_tab*0
r2mean_tab=ecc_tab*0
invrmean_tab=ecc_tab*0
invr2mean_tab=ecc_tab*0
invr3mean_tab=ecc_tab*0
v2mean_tab=ecc_tab*0

;Ratkotaan kepler_oma -ohjelmalla eksentrinen anomalia 
;annetuista M:n arvoista

for i=0,n_elements(ecc_tab)-1 do begin
ecc=ecc_tab(i)
b=a*sqrt(1-ecc^2)
kepler_oma,M,ecc,E,acc0=1d-10

;Lasketaan <r>
r=a*(1-ecc*cos(E))
rmean_tab(i)=mean(r)

;Lasketaan <r^2>
r2=r^2
r2mean_tab(i)=mean(r2)

;Lasketaan <1/r>:
invr=1/r
invrmean_tab(i)=mean(invr)

;Lasketaan <1/r^2>:
invr2=1/r^2
invr2mean_tab(i)=mean(invr2)

;Lasketaan <1/r^3>:
invr3=1/r^3
invr3mean_tab(i)=mean(invr3)

;Lasketaan <v^2>:
dE=sqrt(myy/a^3)/(1-ecc*cos(E))
v2=dE^2*(a^2*(sin(E))^2+b^2*(cos(E))^2)
v2mean_tab(i)=mean(v2)

endfor

;Analyyttiset keskiarvot:
r_ana=a*(1+ecc_tab^2/2)
r2_ana=a^2*(1+3*ecc_tab^2/2)
invr_ana=ecc_tab*0+1/a
invr2_ana=1/(a^2*sqrt(1-ecc_tab^2))
invr3_ana=1/(a^3*(sqrt(1-ecc_tab^2))^3)
v2_ana=ecc_tab*0+myy/a

;Plotataan analyyttinen ja numeerinen <r>:
nwin
plot,ecc_tab,rmean_tab, nodata=1, xtitle='eccentricity',ytitle='<r>'
oplot,ecc_tab,rmean_tab,col=2
oplot,ecc_tab,r_ana,col=3,psym=1

;Plotataan analyyttinen ja numeerinen <r≤>:
nwin
plot,ecc_tab,r2mean_tab,nodata=1,xtitle='eccentricity',ytitle='<r≤>'
oplot,ecc_tab,r2mean_tab,col=2
oplot,ecc_tab,r2_ana,col=3,psym=1

;Plotataan analyyttinen ja numeerinen <1/r>:
nwin
plot,ecc_tab,invrmean_tab,nodata=1, xtitle='eccentricity',ytitle='<1/r>', $
yrange=[0,2]
oplot,ecc_tab,invrmean_tab,col=2
oplot,ecc_tab,invr_ana,col=3,psym=1

;Plotataan analyyttinen ja numeerinen <1/r≤>:
nwin
plot,ecc_tab,invr2mean_tab,nodata=1, xtitle='eccentricity',ytitle='<1/r^2>'
oplot,ecc_tab,invr2mean_tab,col=2
oplot,ecc_tab,invr2_ana,col=3,psym=1

;Plotataan analyyttinen ja numeerinen <1/r≥>:
nwin
plot,ecc_tab,invr3mean_tab,nodata=1, xtitle='eccentricity',ytitle='<1/r≥>'
oplot,ecc_tab,invr3mean_tab,col=2
oplot,ecc_tab,invr3_ana,col=3,psym=1

;Plotataan analyyttinen ja numeerinen <v^2>:
nwin
plot,ecc_tab,v2mean_tab,nodata=1,xtitle='eccentricity',ytitle='<v^2>', $
yrange=[0,2], ys=1
oplot,ecc_tab,v2mean_tab,col=2
oplot,ecc_tab,v2_ana,col=3,psym=1

;psdirect,'aver_oma',ps,/color,/stop
end
