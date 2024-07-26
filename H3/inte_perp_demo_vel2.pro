;*******************************************************
;inte_perp_demo_vel2.pro
;apply continuous  perturbation in the direction of velocity vector
;compare numerical integration and analytical results
;hs 13.11.2006
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
  betamui=0.0005*cforce

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
  inte_perp,elem,t0,t1,dt,/orb,beta=betamui,r=r,t=t,$
    save='inte_perp_demo_vel2.save'
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
;restore results and compare to analytical
;ttable(*) and elemtable(*,6) contain T and ELEM
  restore,"inte_perp_demo_vel2.save"

;*********************************************************
;analytical formulas:
;1-order integration of p, eks, w with respect to E
;p,eks,w treated constants in calculation of derivatives
;*********************************************************
  etable=dindgen(10000)/1000.*max(ttable)/per*2.d0*!dpi
  atable=etable*0.
  ekstable=etable*0.
  wtable=etable*0.
  
  a0=elem(0)
  eks0=elem(1)
  w0=elem(4) 
  p0=a0*(1.d0-eks0^2)
  delta_e=etable(1)-etable(0)
  eks_num=eks0
  p_num=p0
  w_num=w0
  e_num=etable(0)
  cose=cos(etable)
  sine=sin(etable)
  v=sqrt((1.d0/a0)*(1.d0+eks0*cose)/(1.d0-eks_num*cose))
  b=a0*sqrt(1.d0-eks0^2)
  dtde=sqrt(a0^3/myy)*(1.d0-eks0*cose)
  
  for i=0,9999 do begin
      deks=2.*betamui/v(i)*sqrt(p0/myy)*b*cose(i)*delta_e
      dp=2.*betamui*p0/v(i)*dtde(i)*delta_e
      dw=2.*betamui/v(i)*a0/eks0*sqrt(p0/myy)*sine(i)*delta_e      
      eks_num=eks_num+deks
      p_num=p_num+dp
      w_num=w_num+dw*!radeg
      ekstable(i)=eks_num
      wtable(i)=w_num
      atable(i)=p_num/(1.-eks_num^2)
  endfor

  da=atable-a0
  de=ekstable-eks0 
  dw=(wtable-w0) mod 360.
  di=da*0.
  dome=da*0.
  M=etable-eks0*sin(etable)
  pertable=m/2./!pi
  index=lindgen(n_elements(pertable)/50)*50 ; plot every 5

;**************************************************************
  plot,ttable/per,elemtable(*,0)-elem(0),xtitle='T/orb',ytitle='da'
  oplot,pertable(index),da(index),col=2,psym=6,syms=.3
  index=lindgen(n_elements(pertable)/10)*10 ; plot every 10 
  plot,ttable/per,elemtable(*,1)-elem(1),xtitle='T/orb',ytitle='de',$
    title='beta= '+string(betamui)
  oplot,pertable(index),de(index),col=2,psym=6,syms=.3
  
;small eks approximation
  oplot,pertable,-betamui*eks*pertable*2*!pi,col=3
  
  plot,ttable/per,elemtable(*,2)-elem(2),yr=[-10,10],xtitle='T/orb',ytitle='di'
  oplot,pertable(index),di(index),col=2,psym=6,syms=.3

  plot,ttable/per,elemtable(*,3)-elem(3),yr=[-10,10],$
    xtitle='T/orb',ytitle='dome'
  oplot,pertable(index),dome(index),col=2,psym=6,syms=.3
    
  plot,ttable/per,elemtable(*,4)-elem(4),xtitle='T/orb',ytitle='dw',psym=3
  oplot,pertable(index),dw(index),col=2,psym=6,syms=.5
  
  plot,ttable/per,elemtable(*,5)-elem(5),xtitle='T/orb',ytitle='dtau',psym=3
  oplot,ttable/per,elemtable(*,5)-elem(5)+2.*!pi*sqrt(elemtable(*,0)^3/myy),$
       psym=3

;************************************************************
  charsize,1
  xyouts,0.01,0.01,'inte_perp_demo_vel2.pro',chars=.75,/normal
;************************************************************
  print,' to plot same to psfile: '
  print," psopen,'inte_perp_demo_vel2.ps',/vfont"
  print," .run inte_perp_demo_vel2"
  print," psclose "
  print," $lpr inte_perp_demo_vel2.ps"
end
