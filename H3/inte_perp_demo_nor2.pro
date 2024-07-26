;*******************************************************
;inte_perp_demo_nor2.pro
;apply continuous radial perturbation
;compare numerical integration and analytical results
;hs 13.11.2006
;********************************************************
  defplot
  !p.multi=[0,3,3]
  charsize,2.5
  nwin
;elem=[a,e,i,ome,w,tau]
  elem=[1.,.05,20.,30.,40.,0.]
  myy=1.
  cforce=myy/elem(0)^2
  eks=elem(1)
  gammamui=0.001*cforce*.01

;***************************************************
;frame 1: non-perturbed orbit
;***************************************************
  t0=0.d0
  t1=5.d0
  dt=0.0005d0
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
  inte_perp,elem,t0,t1,dt,/orb,gamma=gammamui,$
    save='inte_perp_demo_nor2.save',t=t,r=r
  plot,r(*,0),r(*,1),psym=3,xtitle='x',ytitle='y',title='perturbed',/iso
  plots,0,0,psym=1
  xylim,0
  
;***************************************************
;frame 3: plot info of elements
;***************************************************
  plot,lindgen(11),/nod,xs=15,ys=15 ; dummy plot defined for printing
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
;restore results and compare to analyticaly
;ttable(*) and elemtable(*,6) contain T and ELEM
  restore,"inte_perp_demo_nor2.save"

;*********************************************************
;analytical formula:
;solve eccentric anomaly
  m=2*!pi/per*ttable
  eks=elem(1)
  kepler_array,m,eks,e
  e=e*!radeg
  e1=e(0)
  cose1=cos(e1/!radeg)
  cose2=cos(e/!radeg)
  sine1=sin(e1/!radeg)
  sine2=sin(e/!radeg)
  sini=sin(elem(2)/!radeg)
  cosi=cos(elem(2)/!radeg)
  sinw=sin(elem(4)/!radeg)
  cosw=cos(elem(4)/!radeg)

  apu1=(1.+eks^2)*(sine2-sine1)-eks*(e-e1)/!radeg-$
    eks*(0.25*(sin(2.*e/!radeg)-sin(2.*e1/!radeg))+0.5*(e-e1)/!radeg)
  apu1=(1.+eks^2)*(sine2-sine1)-eks*(0.25*(sin(2.*e/!radeg)-sin(2.*e1/!radeg))+1.5*(e-e1)/!radeg)
  
  apu2=-(cose2-cose1)-eks*(sin(e/!radeg)^2-sin(e1/!radeg)^2)
  apu2=-(cose2-cose1)+.25*eks*(cos(2*e/!radeg)-cos(2*e1/!radeg))

  dome=gammamui/sqrt(1.-eks^2)/sini*(sinw*apu1+cosw*sqrt(1.-eks^2)*apu2)*!radeg
  di=gammamui/sqrt(1.-eks^2)*(cosw*apu1-sinw*sqrt(1.-eks^2)*apu2)*!radeg
  da=di*0.
  dw=-cosi*dome
  de=di*0.

  di_sec=gammamui/sqrt(1.-eks^2)*cosw*(-1.5)*eks*e
  dome_sec=gammamui/sqrt(1.-eks^2)/sini*sinw*(-1.5)*eks*e
  dw_sec=-cosi*dome_sec

;*********************************************************  

  index=lindgen(n_elements(ttable)/10)*10 ; plot every 10
  
  plot,ttable/per,elemtable(*,0)-elem(0),xtitle='T/orb',ytitle='da',$
    yr=[-1,1]*1d-8
  oplot,ttable(index)/per,da(index),col=2,psym=6,syms=.3
  
  plot,ttable/per,elemtable(*,1)-elem(1),xtitle='T/orb',ytitle='de',$
    title='gamma= '+string(gammamui),yr=[-1,1]*1d-8
  
  oplot,ttable(index)/per,de(index),col=2,psym=6,syms=.3
  
  plot,ttable/per,elemtable(*,2)-elem(2),xtitle='T/orb',ytitle='di',psym=3
  oplot,ttable(index)/per,di(index),col=2,psym=6,syms=.3
  oplot,ttable(index)/per,di_sec(index),col=3,lines=2
  
  
  plot,ttable/per,elemtable(*,3)-elem(3),xtitle='T/orb',ytitle='dome',psym=3
  oplot,ttable(index)/per,dome(index),col=2,psym=6,syms=.3
  oplot,ttable(index)/per,dome_sec(index),col=3,lines=2
  
  plot,ttable/per,elemtable(*,4)-elem(4),xtitle='T/orb',ytitle='dw',psym=3
  oplot,ttable(index)/per,dw(index),col=2,psym=6,syms=.5
  oplot,ttable(index)/per,dw_sec(index),col=3,lines=2
  
  plot,ttable/per,elemtable(*,5)-elem(5),xtitle='T/orb',ytitle='dtau',psym=3
  oplot,ttable/per,elemtable(*,5)-elem(5)+per,psym=3

;*********************************************************
  charsize,1
  xyouts,0.01,0.01,'inte_perp_demo_nor2.pro',chars=.75,/normal
;*********************************************************
  print,' to plot same to psfile: '
  print," psopen,'inte_perp_demo_nor2.ps',/vfont"
  print," .run inte_perp_demo_nor2
  print," psclose "
  print," $lpr inte_perp_demo_nor2.ps"
end
