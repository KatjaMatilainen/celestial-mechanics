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
; main program:           ENERGY                                ;
;***************************************************************;
pro numorb_energy
;plot energy for ecc={0,0.5,0.9} and dt={0.01P,0.001P,0.0001P}
        ;dt=0.01d0
        dt=0.001d0
        ;dt=0.0001d0
        ;eks=0.d0
        ;eks=0.5d0
        eks=0.9d0
if dt eq 0.01d0 then begin       ;PLOT RANGES FOR dt=0.01P
   if eks eq 0.d0 then begin     ;for ecc=0.0
      yrange0=[-0.00000000000001,0.00000000000001]   ;Analytical
      yrange1=[-0.0001,1]        ;Taylor I
      yrange2=[-0.0001,0.01]     ;Taylor II
      yrange3=[-0.00000001,0.000002]   ;RK4
   endif
   if eks eq 0.5d0 then begin    ;for ecc=0.5
      yrange0=[-0.00000000000001,0.00000000000001]   ;Analytical
      yrange1=[-0.01,2]          ;Taylor I
      yrange2=[0.01,1]           ;Taylor II
      yrange3=[-0.00001,0.0005]        ;RK4
   endif
   if eks eq 0.9d0 then begin    ;for ecc=0.9
      yrange0=[-0.00000000000001,0.00000000000001]   ;Analytical
      yrange1=[-1,80]            ;Taylor I
      yrange2=[-1,80]           ;Taylor II
      yrange3=[-1,5]            ;RK4
   endif
endif

if dt eq 0.001d0 then begin      ;PLOT RANGES FOR dt=0.001P
   if eks eq 0.d0 then begin     ;for ecc=0.0
      yrange0=[-0.00000000000000001,0.0000000000000001]     ;Analytical
      yrange1=[-0.0001,0.5]                       ;Taylor I
      yrange2=[-0.000001,0.00001]                 ;Taylor II
      yrange3=[-0.0000000000001,0.00000000003]     ;RK4
   endif
   if eks eq 0.5d0 then begin    ;for ecc=0.5
      yrange0=[-0.00000000000000001,0.00000000000000001]     ;Analytical
      yrange1=[-0.0001,0.7]                ;Taylor I
      yrange2=[-0.0001,0.005]              ;Taylor II
      yrange3=[-0.000000001,0.000000004]      ;RK4
   endif
   if eks eq 0.9d0 then begin    ;for ecc=0.9
      yrange0=[-0.00000000000001,0.00000000000001]   ;Analytical
      yrange1=[-1,5]            ;Taylor I
      yrange2=[-0.1,2]           ;Taylor II
      yrange3=[-0.0001,0.006]            ;RK4
   endif
endif

if dt eq 0.0001d0 then begin     ;PLOT RANGES FOR dt=0.0001P
   if eks eq 0.d0 then begin     ;for ecc=0.0
      yrange0=[-0.0001,0.0001]   ;Analytical
      yrange1=[-0.0001,1]        ;Taylor I
      yrange2=[-0.0001,0.01]     ;Taylor II
      yrange3=[-0.0001,0.0001]   ;RK4
   endif
   if eks eq 0.5d0 then begin    ;for ecc=0.5
      yrange0=[-0.0001,0.0001]   ;Analytical
      yrange1=[-0.01,2]          ;Taylor I
      yrange2=[0.01,1]           ;Taylor II
      yrange3=[0.02,0.05]        ;RK4
   endif
   if eks eq 0.9d0 then begin    ;for ecc=0.9
      yrange0=[-0.0001,0.0001]   ;Analytical
      yrange1=[-1,80]            ;Taylor I
      yrange2=[-1,100]           ;Taylor II
      yrange3=[-1,50]            ;RK4
   endif
endif

   inte_energy,eks0=eks,dt0=dt,choice0=3,yrange0=yrange0      ;Analytical
   inte_energy,eks0=eks,dt0=dt,choice0=1,yrange0=yrange1      ;Taylor I
   inte_energy,eks0=eks,dt0=dt,choice0=2,yrange0=yrange2      ;Taylor II
   inte_energy,eks0=eks,dt0=dt,choice0=0,yrange0=yrange3      ;RK4
end
;---------------------------------------------------------------;
;Use PsPlot to save results
pro Plot_everything
PsPlot, 'numorb_energy', 'numorb_energy.ps'
end
;---------------------------------------------------------------;
