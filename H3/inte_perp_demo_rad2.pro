;*******************************************************
;inte_perp_demo_rad2.pro
;apply continuous radial perturbation
;compare numerical integration and analytical results
;********************************************************

defplot
!p.multi=[0,3,3]
charsize,2.5
nwin

;elem=[a,e,i,ome,w,tau]
 elem=[1.,.5,1.,0.,0.,0.]
 myy=1.
 cforce=myy/elem(0)^2
 eks=elem(1)
 
 alfamui=0.001*cforce
 alfamui=0.005*cforce

 t0=0.d0
 t1=5.d0
 dt=0.0005d0

;***************************************************
;frame 1: non-perturbed orbit
;***************************************************

 inte_perp,elem,t0,t1,dt,/orb,/sil,r=r0,t=t0

 xylim,2
 plot,r0(*,0),r0(*,1),psym=3,xtitle='x',ytitle='y',title='non-perturbed',/iso
 plots,0,0,psym=1


;***************************************************
;frame 2: perturbed
;***************************************************
 t0=0.d0
 t1=5.d0
 dt=0.0005d0


 inte_perp,elem,t0,t1,dt,/orb,alfa=alfamui,$
           save='inte_perp_demo_rad2.save',r=r,t=t

 plot,r(*,0),r(*,1),psym=3,xtitle='x',ytitle='y',title='perturbed',/iso
 plots,0,0,psym=1
 xylim,0

;***************************************************
;frame 3: plot info of elements
;***************************************************
 
 plot,lindgen(11),/nod,xs=15,ys=15  ; dummy plot defined for printing
 ff='(g10.6)'
 xyouts,1,9,'a   ='+string(elem(0),ff),chars=1.
 xyouts,1,8,'eks ='+string(elem(1),ff),chars=1.
 xyouts,1,7,'ink ='+string(elem(2),ff),chars=1.
 xyouts,1,6,'ome ='+string(elem(3),ff),chars=1.
 xyouts,1,5,'w   ='+string(elem(4),ff),chars=1.
 xyouts,1,4,'tau ='+string(elem(5),ff),chars=1.
 xyouts,1,3,'dt  ='+string(dt,ff),chars=1

;*********************************************************
; frames 4-9
;*********************************************************
;restore results and compare to analytical
;ttable(*) and elemtable(*,6) contain T and ELEM

 restore,"inte_perp_demo_rad2.save"

;analytical formula:
;solve eccentric anomaly
 m=2*!pi/per*ttable
 kepler_array,m,elem(1),e
 e=e*!radeg

 e1=e(0)
 cose1=cos(e1/!radeg)
 cose2=cos(e/!radeg)
 sine1=sin(e1/!radeg)
 sine2=sin(e/!radeg)

   da=-alfamui/cforce*2.*eks*(cose2-cose1)
   de=-alfamui/cforce*(1.-eks^2)*(cose2-cose1)
   dw= alfamui/cforce*sqrt(1.-eks^2)*$
       ((e-e1)/!radeg -1./eks*(sine2-sine1))*!radeg

   di=da*0.
   dome=da*0.


 index=lindgen(n_elements(ttable)/5)*5 ; plot every 5

 plot,ttable/per,elemtable(*,0)-elem(0),xtitle='T/orb',ytitle='da'
 oplot,ttable(index)/per,da(index),col=2,psym=6,syms=.3

 plot,ttable/per,elemtable(*,1)-elem(1),xtitle='T/orb',ytitle='de',$
      title='alfa= '+string(alfamui)
 oplot,ttable(index)/per,de(index),col=2,psym=6,syms=.3

 plot,ttable/per,elemtable(*,2)-elem(2),yr=[-10,10],xtitle='T/orb',ytitle='di'
 oplot,ttable(index)/per,di(index),col=2,psym=6,syms=.3

 plot,ttable/per,elemtable(*,3)-elem(3),yr=[-10,10],xtitle='T/orb',$
      ytitle='dome'
 oplot,ttable(index)/per,dome(index),col=2,psym=6,syms=.3

 index=lindgen(n_elements(ttable)/10)*10 ; plot every 10
 plot,ttable/per,elemtable(*,4)-elem(4),xtitle='T/orb',ytitle='dw'
 oplot,ttable(index)/per,dw(index),col=2,psym=6,syms=.5

 plot,ttable/per,elemtable(*,5)-elem(5),xtitle='T/orb',ytitle='dtau'


;************************************************************
charsize,1
xyouts,0.01,0.01,'inte_perp_demo_rad2.pro',chars=.75,/normal
;************************************************************

 print,' to plot same to psfile: '
 print," psopen,'inte_perp_demo_rad2.ps',/vfont"
 print," .run inte_perp_demo_rad2
 print," psclose "
 print," $lpr inte_perp_demo_rad2.ps"
end
