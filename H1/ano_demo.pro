;**********************************************
;ano_demo.pro
;study elliptic orbit
;HS 2002/1.11.2006
;**********************************************

program='ano_demo'
ps=0
psdirect,program,ps,/color

!p.multi=[0,2,2]
!p.charsize=0.7
col1=1
if(!d.name eq 'PS') then col1=0
;*************************************
;compare 
; mean anomaly M
; eccentric anomaly E
; true anomaly f
;*************************************

  a=1.
  eks=.5         ;try different values !!
  
;evaluate M with npoints values
  npoints=50
  M=findgen(npoints)*2.*!dpi/npoints

;solve E from Kepler's equation
  e=m*0
  for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
  endfor
  
;solve f from E

  sine=sin(e)
  cose=cos(e)
  cosf=(cose-eks)/(1.-eks*cose)
  sinf=sqrt(1.-eks^2)*sine/(1.-eks*cose)
  
  f=atan(sinf,cosf)
  index=where(f lt 0,count)
  if(count ge 1) then f(index)=f(index)+2.*!pi

;************************
;plot M,E,F
;************************
 nwin
  plot,m*!radeg,m*!radeg,lines=2,xr=[0,360],xs=1,yr=[0,360],ys=1,$
    xtitle='M Mean anomaly',ytitle='E, f',$
    title='eccentricity='+string(eks,'(f8.3)'),col=col1

  oplot,m*!radeg,f*!radeg,col=2,lines=1
  oplot,m*!radeg,e*!radeg,col=3

  plots,[15,40],[320,320],col=3
  plots,[15,40],[290,290],col=2,lines=1
  plots,[15,40],[260,260],col=col1,lines=2
  xyouts,50,320,'eccentric anomaly E',col=3
  xyouts,50,290,'true anomaly f',col=2
  xyouts,50,260,'mean anomaly M',col=col1

;************************
;plot f-M, E-M
;************************
nwin
  plot,m*!radeg,(f-M)*!radeg,xr=[0,360],yr=[-1,1]*eks*3*!radeg,xs=1,$
       xtitle='M Mean anomaly',ytitle='f-M and E-M',$
       title='eccentricity='+string(eks,'(f8.3)'),col=2,lines=1
  oplot,m*!radeg,(E-M)*!radeg,col=3

;************************
;f-M series
;************************
nwin

  plot,m*!radeg,(f-M)*!radeg,psym=6,xr=[0,360],yr=[-1,1]*eks*3*!radeg,xs=1,$
       xtitle='M Mean anomaly',ytitle='f-M',$
       title='eccentricity='+string(eks,'(f8.3)'),col=col1,syms=.25

 term1=2*eks*sin(m)
 term2=5./4.*eks^2*sin(2*m)
 term3=(13./12.*sin(3*m)-0.25*sin(m))*eks^3

       oplot,m*!radeg,term1*!radeg,lines=1,col=2
       oplot,m*!radeg,(term1+term2)*!radeg,lines=2,col=3
       oplot,m*!radeg,(term1+term2+term3)*!radeg,lines=0,col=5

dy=   3*eks*!radeg*.3
      xyouts,10,-1*dy,'  2*eks*sin(m)',col=2,chars=0.7
      xyouts,10,-2*dy,'+ 5/4*eks^2*sin(2*m)',col=3,chars=0.7
      xyouts,10,-3*dy,'+ (13./12.*sin(3*m)-0.25*sin(m))*eks^3',$
             col=5,chars=0.7

;************************
;e-M series
;************************
nwin
  plot,m*!radeg,(e-M)*!radeg,psym=6,xr=[0,360],yr=[-1,1]*eks*2*!radeg,xs=1,$
       xtitle='M Mean anomaly',ytitle='e-M',$
       title='eccentricity='+string(eks,'(f8.3)'),col=col1,syms=.25

 term1=eks*sin(m)
 term2=1./2.*eks^2*sin(2*m)
 term3=(3./8.*sin(3*m)-1./8*sin(m))*eks^3

       oplot,m*!radeg,term1*!radeg,lines=1,col=2
       oplot,m*!radeg,(term1+term2)*!radeg,lines=2,col=3
       oplot,m*!radeg,(term1+term2+term3)*!radeg,lines=0,col=5

dy=   3*eks*!radeg*.2
       xyouts,10,-1*dy,'  eks*sin(m)',col=2,chars=0.7
       xyouts,10,-2*dy,'+ 1/2*eks^2*sin(2*m)',col=3,chars=0.7
       xyouts,10,-3*dy,'+ (3./8.*sin(3*m)-1./8*sin(m))*eks^3',col=5,$
              chars=0.7

xyouts,0.01,0.01,'ano_demo.pro',chars=0.75,/normal
!p.multi=0
psdirect,program,ps,/stop,pic='.'
end





