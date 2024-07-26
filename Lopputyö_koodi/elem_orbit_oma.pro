;Tehd‰‰n ohjelma, joka laskee ja plottaa radan aikav‰lill‰ [t1,t2] kun
;sille annetaan rataelementit

pro elem_orbit_oma,elem,time

if n_params() eq 0 then begin
print, 'pro elem_orbit_oma,elem,time'
print, 'elem=[a,eks,ink,ome,w,tau]'
print, 'time=[t1,t2]'
return
endif

time_tab=time

;t1=time(0)
;t2=time(1)
;time_tab=findgen(101)*0.01*2*!pi*(t2-t1)+t1
n_times=n_elements(time_tab)
rad_tab=fltarr(n_times,3)
vel_tab=fltarr(n_times,3)

for i=0,n_elements(time_tab)-1 do begin

elem_to_rv,elem,time_tab(i),rad,vel,myy=myy0,m0=m0
rad_tab(i,*)=rad
vel_tab(i,*)=vel

endfor

nwin
plot,rad_tab(*,0),rad_tab(*,1),xrange=[-40,40],xs=1,yrange=[-30,30],ys=1

elem_to_rv,elem,-1,rad2,vel2,myy=myy0,m0=m0
oplot,rad2(0),rad2(1),psym=1,col=2

end

;elem=[1,0.01671022,0.00005,-11.26064,114.20783,0]
