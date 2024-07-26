;---------------------------------------------------------------;
;Subroutine for saving results in postscript format
pro PsPlot,routine,filename
	thisdir=getenv('PWD')+'/'
	psopen,/color,dir=thisdir,filename
	call_procedure,routine
	psclose		
end
;---------------------------------------------------------------;
;***************************************************************;
; main program:     ANGULAR MOMENTUM                            ;
;***************************************************************;
pro numorb_angmom
;plot energy for ecc={0,0.5,0.9} and dt={0.01P,0.001P,0.0001P}
        dt=0.01d0
        ;dt=0.001d0
        ;dt=0.0001d0
        eks=0.d0
        ;eks=0.5d0
        ;eks=0.9d0
        inte_angmom,eks0=eks,dt0=dt,choice0=3 ;Analytical
        inte_angmom,eks0=eks,dt0=dt,choice0=1 ;Taylor I
        inte_angmom,eks0=eks,dt0=dt,choice0=2 ;Taylor II
        inte_angmom,eks0=eks,dt0=dt,choice0=0 ;RK4
end
;---------------------------------------------------------------;
;Use PsPlot to save results
pro Plot_everything
PsPlot, 'numorb_angmom', 'numorb_angmom.ps'
end
;---------------------------------------------------------------;
