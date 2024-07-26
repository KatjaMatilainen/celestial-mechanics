;kepler_oma,10/!radeg,0.5,E2,/tulo,acc0=1E-5    
;kepler_oma,10/!radeg,0.6,E2,/tulo,acc0=1E-5    
;kepler_oma,10/!radeg,0.7,E2,/tulo,acc0=1E-5    
;kepler_oma,10/!radeg,0.8,E2,/tulo,acc0=1E-5    
;kepler_oma,10/!radeg,0.9,E2,/tulo,acc0=1E-5    

ecc_tab=findgen(100)*0.01
e_tab=ecc_tab*0
for i=0,99 do begin
kepler_oma,10/!radeg,ecc_tab(i),E2,acc0=1E-5
e_tab(i)=E2
endfor
nwin
plot,ecc_tab,e_tab*!radeg, xtitle='eccentricity',ytitle='eccentric anomaly (degrees)'
oplot, ecc_tab,10+ecc_tab*0
end
