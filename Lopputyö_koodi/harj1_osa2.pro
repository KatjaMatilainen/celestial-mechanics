;------------------------------------------------------------------------;
; Celestial mechanics: Computer exercises I, part 2
;------------------------------------------------------------------------;
;What to do:
; a) Plot elliptic orbits with eccentricity e=[0.0,0.1,...,0.8].
;    Use a=1 for the semimajor axis and use 200 uniformly chosen E
;    values from 0 to 2pi to calculate (x,y)-points
; b) Do the same for true anomaly f=[0,2pi]
; c) Do the same for mean anomaly M=[0,2pi]
; d) Make a plot with fewer points (50) for e=0.0 and e=0.8
; e) Make plots of the length of the radius vector as a function of time

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

;------------------------------------------------------------------------;
;  MAIN PROGRAM starts here
;------------------------------------------------------------------------;
pro harj1_osa2

;------------------------------------------------------------------------;
; Part 2a)
;------------------------------------------------------------------------;
;Eccentricities
ecc=[0.0d,0.1d,0.2d,0.3d,0.4d,0.5d,0.6d,0.7d,0.8d]
;Semimajor axis
aa=1.d0
;Semiminor axis
bb=ecc*0.d0
i=0
while i lt n_elements(bb) do begin
bb[i]=sqrt(1-ecc[i]^2)
i=i+1
endwhile

;Eccentric anomaly
E=dindgen(201)/100.d0*!dpi
;print,E

;Calculate x- and y-coordinates
;Make tables for x and y
xtab=!NULL
ytab=!NULL
k=0
while k lt 9 do begin
   xtab=[[xtab],[aa*(cos(E)-ecc[k])]]
   ytab=[[ytab],[bb[k]*sin(E)]]
k=k+1
endwhile

;--------------------------------------------------------------------;
; Plot the orbits (parameter E)
;--------------------------------------------------------------------;
plot,xtab[*,0],ytab[*,0],xtitle='x',ytitle='y',title='Elliptic orbits, E as a free parameter',/iso,xrange=[-2,2],yrange=[-2,2]
oplot,xtab[*,1],ytab[*,1];,col=3
oplot,xtab[*,2],ytab[*,2];,col=130
oplot,xtab[*,3],ytab[*,3];,col=400
oplot,xtab[*,4],ytab[*,4];,col=500
oplot,xtab[*,5],ytab[*,5];,col=6
oplot,xtab[*,6],ytab[*,6];,col=7
oplot,xtab[*,7],ytab[*,7];,col=8
oplot,xtab[*,8],ytab[*,8];,col=9

;--------------------------------------------------------------------;
; Plot the orbits (parameter f)
;--------------------------------------------------------------------;
f=E

r2=aa*(1-ecc^2)/(1.d0+ecc*cos(f))

end

;--------------------------------------------------------------------;
; Save the results to a PostScript file using PsPlot
;--------------------------------------------------------------------;
pro Plot_everything
PsPlot, 'harj1_osa2', 'harj1_osa2.ps'
end
