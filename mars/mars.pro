;----------------------------------------------------------------------;
; TAIVAANMEKANIIKAN KOTITEHTÄVÄT (vm 2012)
;----------------------------------------------------------------------;
; Osa 1) Marsin rata taivaalla vuosina 2000-2020
; (In english because why not?)
;------------------------------------------------------------------------;
; Use the subroutine PsPlot to save results in a postscript plot 
; (written by Heikki Salo)
;------------------------------------------------------------------------;
pro PsPlot,routine,filename
	thisdir=getenv('PWD')+'/'
	psopen,/color,dir=thisdir,filename
	call_procedure,routine
	psclose		
end

;------------------------------------------------------------------------;
;  MAIN PROGRAM starts here
;------------------------------------------------------------------------;
pro mars

;------------------------------------------------------------------------;
; TIME between 2000-2020 (21 years)
;------------------------------------------------------------------------;
; In years (0.01yr interval)
timet=dindgen(2100)/100.d0
; In days
tday=timet*365.25d0
; In centuries (functions as Julian centuries, technically should
; substract t=J-2451545.0 though)
tcen=tday/36525.d0

;------------------------------------------------------------------------;
; Elements in eplictic and equatorial systems
;------------------------------------------------------------------------;
;Declination
deltat=timet
;Rectascension
alphat=timet

;Latitude
lattab=timet
;Longitude
lontab=timet

;------------------------------------------------------------------------;
; Loop for solving the orbit starts here
;------------------------------------------------------------------------;
;NOTE: use 'long' type for index i so that the loop won't end
;prematurely

for i=0l,n_elements(timet)-1 do begin

;Time in julian centuries
T=tcen(i)

;------------------------------------------------------------------------;
; Orbital elements of Mars (from Karttunen: Johdatus taivaanmekaniikkaan)
; (time-dependent)
;------------------------------------------------------------------------;
; Semimajor axis (in AU)
a=1.52366231d0-0.0000722d0*T
; Eccentricity
eks=0.09341233d0+0.00011902d0*T
; Inclination (in degrees)
ink=1.85061d0-25.47d0/3600.d0*T
; Longitude of ascending node (in degrees)
ome=49.57854d0-1020.19d0/3600.d0*T
; Longitude of perihelion (in degrees)
wp=336.04084d0+1560.78d0/3600.d0*T
; Longitude (in degrees)
L=355.45332d0+0.52403304d0*tday(i)

; Argument of pericenter
w=wp-ome
; Mean anomaly
M=L-wp

; Time of pericenter (not really needed here since M is given directly,
; but the program input wants it)
tau=0.d0
; All the elements combined
elem_mars=[a,eks,ink,ome,w,tau]

; Corrected mean anomaly (use modulo to loop every 360deg)
M_mars=(M mod 360.d0)/360.d0*2.d0*!dpi

;------------------------------------------------------------------------;
; Orbital elements of Earth (from Karttunen: Johdatus taivaanmekaniikkaan)
;------------------------------------------------------------------------;
; Semimajor axis
a_m=1.00000011d0-0.00000005*T
; Eccentricity
eks_m=0.01671022d0-0.00003804*T
; Inclination
ink_m=0.00005d0-46.94/3600.*T
; Longitude of ascending node (in degrees)
ome_m=-11.26064d0-18228.25/3600.*T
; Longitude of perihelion (in degrees)
wp_m=102.94719d0+1198.28/3600*T
; Longitude (in degrees)
L_m=100.46435d0+0.98560910*tday(i)

; Argument of pericenter
w_m=wp_m-ome_m
; Mean anomaly
M_m=L_m-wp_m

; Elements combined (can use same tau as Mars)
elem_m=[a_m,eks_m,ink_m,ome_m,w_m,tau]

; Corrected mean anomaly (again use modulo)
M_maa=(M_m mod 360.d0)/360.d0*2.d0*!dpi

;--------------------------------------------------------------------------;
; Use the subprogram 'elem_to_rv.pro' to get the radius vector
;--------------------------------------------------------------------------;
; For Mars
time=0.d0
elem_to_rv,elem_mars,time,rad,vel,M0=M_mars
rad_mars=rad

; For Earth
elem_to_rv,elem_m,time,rad_m,vel_m,M0=M_maa
rad_maa=rad_m

;--------------------------------------------------------------------------;
; Get place coordinates in ecliptic system
;--------------------------------------------------------------------------;
; (x,y,z) from substracting (x_mars-x_maa,y_mars-y_maa,z_mars-z_maa)
x=rad_mars(0)-rad_maa(0)
y=rad_mars(1)-rad_maa(1)
z=rad_mars(2)-rad_maa(2)

; Change from (x,y,z) to (r,lat,long)
r=sqrt(x^2+y^2+z^2)
lattab(i)=asin(z/r)*!radeg
lontab(i)=atan(y,x)*!radeg

;---------------------------------------------------------------------------;
; Rotate ~23deg with respect to x axis to get coord. in equator system
;---------------------------------------------------------------------------;
; Angle of Earth's rotational axis (in radians)
ekli=23.43928d0;/!radeg
; Slightly faster to define cos(ekli) and sin(ekli) beforehand
sine=sin(ekli/!radeg)
cose=cos(ekli/!radeg)

; (x',y',z') solved from rotational matrix
; actually 'ekli' should be negative, but the same result is achieved
; by setting sin(ekli) -> -sin(ekli) and cos(ekli) -> cos(ekli) in the
; rotation matrix
xe=x
ye=y*cose-z*sine
ze=y*sine+z*cose

; Change from (x',y',z') to (r,delta,alpha)
re=sqrt(xe^2+ye^2+ze^2)
delta=asin(ze/re)*!radeg
alpha=atan(ye,xe)*!radeg

; Make sure that the rectascension is not negative
if (alpha le 0) then alpha=alpha+360.d0

; Add current values to the tables defined in the beginning of program
deltat(i)=delta
alphat(i)=alpha

; END THE LOOP finally
endfor

;--------------------------------------------------------------------;
; Draw the orbit (ecliptic)
;--------------------------------------------------------------------;
nwin
plot,lontab,lattab,xtitle='Longitudi pitkin ekliptikaa',$
title='Marsin rata 2000-2020',ytitle='Latitudi',psym=3

;--------------------------------------------------------------------;
; Check results by using 'planet_coords' procedure in ASTRO-library
;--------------------------------------------------------------------;
; Use julian date
juldate,[2000.,1.,1],jd0 ;gives reduced JD-2400000.0
jd0=jd0+2400000.d0       ;get JD for our starting time
jd=jd0+tday              ;transform used timetable into JD

; From ASTRO-library (two options)
planet_coords,jd,/jd,ra_astro,dec_astro,planet='mars'
;JPL ephemerids did not work?
planet_coords,jd,/jd,ra_jpl,dec_jpl,planet='mars',/jpl

;--------------------------------------------------------------------;
; Declination
;--------------------------------------------------------------------;
nwin
;!p.multi=[0,2,2]
;!p.charsize=0.7

plot,timet+2000,deltat,xr=[0,20]+2000,$
ytitle='Marsin deklinaatio',xtitle='Vuosi',psym=3

;Plot only one in every 20 points
index=lindgen(n_elements(timet)/20)*20

oplot,2000+timet(index),dec_astro(index),psym=6,syms=0.5
oplot,2000+timet(index),dec_astro(index),psym=1,syms=0.5

;--------------------------------------------------------------------;
; Rectascension
;--------------------------------------------------------------------;
nwin
plot,2000+timet,alphat,xr=[0,20]+2000,$
     xtitle='Vuosi',ytitle='Marsin rektaskensio',psym=3
  
oplot,2000+timet(index),ra_astro(index),psym=6,syms=0.5
oplot,2000+timet(index),ra_astro(index),psym=1,syms=0.5

;--------------------------------------------------------------------;
; Errors (compare to JPL)
;--------------------------------------------------------------------;
; For declination
nwin
plot,timet+2000,(deltat-dec_jpl)*60.,xr=[0,20]+2000,$
       xtitle='Vuosi',ytitle='Deklinaation virhe (arcmin)',psym=3
; For rectascension (neglect full round difference)
d_alpha=atan(tan((alphat-ra_jpl)/!radeg))*!radeg
nwin
plot,2000+timet,d_alpha*60,xr=[0,20]+2000,$
       xtitle='Vuosi',ytitle='Rektaskension virhe (arcmin)',psym=3
end

;--------------------------------------------------------------------;
; Save the results to a PostScript file using PsPlot
;--------------------------------------------------------------------;
pro Plot_everything
PsPlot, 'mars', 'mars.ps'
end
