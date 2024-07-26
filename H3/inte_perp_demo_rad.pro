;*****************************
;inte_perp_demo_rad.pro
;apply radial perturbation at different parts of the orbit
;Heikki Salo 2002/05.11.2006
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
  
;use large perturbation to illustrate the 
;effect of perturbation on the orbit (fac=1.*cforce)
   fac=1.*cforce

;different perturbation in each case   
   for icase=1,4 do begin
      if(icase eq 1) then begin
          e1=80.   & e2=e1+20. & alfamui=0.25*fac
          comment='!7D!3a,!7De!3 > 0'
      endif
      if(icase eq 2) then begin
          e1=260. & e2=e1+20. & alfamui=0.25*fac
          comment='!7D!3a,!7De!3 < 0'
      endif
      if(icase eq 3) then begin
          e1=0.1     & e2=e1+20. & alfamui=0.5*fac
          comment='!7Dx<0!3'
      endif
      if(icase eq 4) then begin
          e1=170.    & e2=e1+20. & alfamui=0.25*fac
          comment='!7Dx>0!3'
      endif

      st=string(alfamui,'(e8.2)')+string(e1,'(f6.0)')+string(e2,'(f6.0)')
      title='alfa,e1,e2= '+st
      
;for plotting: interval where perturbation is used
      index=where(e gt e1 and e lt e2)      
      plot,r0(*,0),r0(*,1),thick=2,title=title,/iso,lines=2,chars=1.
      oplot,r0(index,0),r0(index,1),thick=2,col=2,lines=0,psym=6,syms=.3
      oplot,[-2,2],[0,0],lines=1
      oplot,[0,0],[-2,2],lines=1
      xyouts,-1.8,1.6,comment,chars=1.5
      
      inte_perp,elem,0.,2.5,.0005,/orb,t=t1,r=r1,alfa=alfamui,$
        e1=e1,e2=e2,final_elem=final_elem,sil=1
      oplot,r1(*,0),r1(*,1),psym=3,col=2
      
  endfor

  close,1
  xyouts,0.01,0.01,'inte_perp_demo_rad.pro',chars=1,/normal
  
  print,' to plot same to psfile: '
  print," psopen,'inte_perp_demo_rad.ps',/vfont"
  print," .run inte_perp_demo_rad"
  print," psclose "
  print," $lpr inte_perp_demo_rad.ps"
end
