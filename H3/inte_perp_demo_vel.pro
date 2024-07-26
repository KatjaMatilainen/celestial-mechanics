;*****************************
;inte_perp_demo_vel.pro
;apply  perturbation at direction of velocity
;different parts of the orbit
;TM2006 HS
;*****************************

;elem=[a,e,i,ome,w,tau]
  elem=[1.,.5,1.,0.,0.,0.]
  myy=1.
  cforce=myy/elem(0)^2
  eks=elem(1)

;no perturbation
  inte_perp,elem,0.,1.,.0005,/orb,t=t0,r=r0,/sil,fin=efin0,outsave=1

;solve eccentric anomaly
  per=2.*!pi*sqrt(elem(0)^3/myy)
  m=2*!pi/per*(t0-elem(5))
  kepler_array,m,elem(1),e
  e=e*!radeg

  xylim,2
  !p.multi=[0,2,2]
  charsize,1.5
  nwin,xs=600,ys=600
  fac=1.*cforce

;different perturbation in each case
  for icase=1,4 do begin
      if(icase eq 1) then begin
          e1=80.   & e2=e1+20. & betamui=0.2*fac
          comment='!7Dx>0!3'
      endif
      if(icase eq 2) then begin
          e1=260. & e2=e1+20. & betamui=0.2*fac
          comment='!7Dx<0!3'          
      endif
      if(icase eq 3) then begin
          e1=0.1     & e2=e1+20. & betamui=0.5*fac
          comment='!7De!3 > 0'          
      endif
      if(icase eq 4) then begin
          e1=180.    & e2=e1+20. & betamui=0.25*fac
          comment='!7De!3 < 0'
      endif
      
      cose1=cos(e1/!radeg)
      cose2=cos(e2/!radeg)
      sine1=sin(e1/!radeg)
      sine2=sin(e2/!radeg)
      
      st=string(betamui,'(e8.2)')+string(e1,'(f5.0)')+string(e2,'(f5.0)')
      title='beta,e1,e2= '+st

;for plotting: interval where perturbation is used
      index=where(e gt e1 and e lt e2)
      
      plot,r0(*,0),r0(*,1),thick=2,title=title,/iso,lines=2,chars=1.
      oplot,r0(index,0),r0(index,1),thick=2,col=2,lines=0,psym=6,syms=.3
      oplot,[-2,2],[0,0],lines=1
      oplot,[0,0],[-2,2],lines=1
      xyouts,-1.8,1.6,comment,chars=1.5
      
      inte_perp,elem,.0,2.5,.0005,/orb,t=t1,r=r1,beta=betamui,$
        e1=e1,e2=e2,final_elem=final_elem,sil=1
      oplot,r1(*,0),r1(*,1),psym=3,col=2
      
;------------------

  endfor
  
  xyouts,0.01,0.01,'inte_perp_demo_vel.pro',chars=1,/normal
  
  print,' to plot same to psfile: '
  print," psopen,'inte_perp_demo_vel.ps',/vfont"
  print," .run inte_perp_demo_vel
  print," psclose "
  print," $lpr inte_perp_demo_vel.ps"
end
