;**********************************************
;elliptic_demo.pro
;study elliptic orbit
;HS 05.11.02/01.11.2006
;**********************************************

;A plot elliptic orbit using E
;B plot elliptic orbit using f
;C plot elliptic orbit using M
;D plot elliptic orbit using M,
;       plotting points with equal spacing in time
;E plot V, V_r, V_t
;F plot EKIN, EPOT, ETOT, AMOM

;*************************************
;plot elliptic orbits
;with eccentricity 0.1,0.2,...,0.8
;choose a=1. semimajor axis
;*************************************

  a=1.

;eccentricity values
  eks_tab=[0., 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]

;make 4 plots on the same page
  !p.multi=[0,2,2]

;output will be to screen,
;or to files  elliptic_demo_1.ps etc.
;default is screen

  program='elliptic_demo'
  ps=0

  psdirect,program+'_1',ps,/color

;----------------------------------------------
; A)  use eccentric anomaly E as a free parameter
;----------------------------------------------


;open new window
  nwin

  e=findgen(201)/200.*2.*!dpi
  sine=sin(e)
  cose=cos(e)

;loop over eccentricity values
  for i=0,n_elements(eks_tab)-1 do begin

    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    xx=a*(cos(e)-eks)
    yy=b*sin(e)

;i=0 plot, otherwise oplot
    if(i eq 0) then begin
      plot,xx,yy,xtitle='x',ytitle='y',xrange=[-2,2],yrange=[-2,2],$
           xs=1,ys=1,/iso,title='E as free parameter'
      plots,0,0,psym=1
    endif
    oplot,xx,yy,col=i+2

  endfor

  xyouts,-1.8,1.7,'eks=0.0, 0.1, ..., 0.8'

;----------------------------------------------
; B) use true anomaly f as a parameter
;----------------------------------------------

  nwin

  f=findgen(201)/200.*2.*!dpi
  sinf=sin(f)
  cosf=cos(f)

  for i=0,n_elements(eks_tab)-1 do begin

    eks=eks_tab(i)
    p=(1.-eks^2)*a
    r=p/(1.+eks*cosf)
    xx=r*cosf
    yy=r*sinf

    if(i eq 0) then begin
      plot,xx,yy,xtitle='x',ytitle='y',xrange=[-2,2],yrange=[-2,2],$
           xs=1,ys=1,/iso,title='f as free parameter'
      plots,0,0,psym=1
    endif
    oplot,xx,yy,col=i+2
  endfor


;----------------------------------------------
; C) use mean anomaly M as a parameter
;----------------------------------------------
; requires solution of eccentric anomaly from Kepler's equation
; M = E - eks*sin(E)

  nwin

  M=findgen(201)/200.*2.*!dpi

  for i=0,n_elements(eks_tab)-1 do begin

    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a

;solve kepler's equation for each M
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor

    xx=a*(cos(e)-eks)
    yy=b*sin(e)

    if(i eq 0) then begin
       plot,xx,yy,xtitle='x',ytitle='y',xrange=[-2,2],yrange=[-2,2],$
            xs=1,ys=1,/iso,title='M as free parameter'
       plots,0,0,psym=1
    endif
    oplot,xx,yy,col=i+2
  endfor


;----------------------------------------------
; D) use mean anomaly M as a parameter
;    plot each point by symbol, otherwise as C)
;    to show how speed varies
;----------------------------------------------

;eccentricity values
  eks_tab=[0., 0.8]

  nwin
  M=findgen(101)/100.*2.*!dpi

  for i=0,n_elements(eks_tab)-1 do begin

    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a

    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor

    xx=a*(cos(e)-eks)
    yy=b*sin(e)

    if(i eq 0) then begin
      plot,xx,yy,xtitle='x',ytitle='y',xrange=[-2,2],yrange=[-2,2],$
           xs=1,ys=1,/iso,title='M as free parameter, eks=0.0 and 0.8',psym=3
      plots,0,0,psym=1
    endif
    oplot,xx,yy,col=i+2,psym=3
  endfor

;**********************************************************
 xyouts,0.01,0.01,'elliptic_demo.pro: page 1: a)-d)',/normal,chars=.75

 psdirect,program+'_1',ps,/color,/stop,pic='.'
 !p.multi=0
;**********************************************************


psdirect,program+'_2',ps,/color
;----------------------------------------------
; e) PLOT r, 1/r^2, 1/r^3 vs. TIME
;----------------------------------------------


!p.multi=[0,1,3]
nwin
charsize,1.75
;!p.charsize=1.75


;eccentricity values
  eks_tab=[0., 0.4, 0.8]
  M=findgen(801)/400.*2.*!dpi


;---------- 
; r(t)
;---------- 

  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor
    rr=a*(1-eks*cos(e))

    if(i eq 0) then begin
      plot,m/2/!pi,rr,xtitle='T/PER',ytitle='r',xrange=[0,2],yrange=[0,2],$
           xs=1,ys=1,title='r vs time, eks=0.0, 0.4, 0.8',psym=3
    endif
    oplot,m/2/!pi,rr,col=i+2,psym=3
  endfor

;---------- 
; r(t)^(-2)
;---------- 

  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor
    rr=a*(1-eks*cos(e))

    if(i eq 0) then begin
      plot,m/2/!pi,1/rr^2,xtitle='T/PER',ytitle='1/r^2',$
           xrange=[0,2],yrange=[0,20],$
           xs=1,ys=1,title='r vs time, eks=0.0, 0.4, 0.8',psym=3
    endif
    oplot,m/2/!pi,1/rr^2,col=i+2,psym=3
  endfor

;---------- 
; r(t)^(-2)
;---------- 

  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor
    rr=a*(1-eks*cos(e))

    if(i eq 0) then begin
      plot,m/2/!pi,1/rr^3,xtitle='T/PER',ytitle='1/r^3',$
           xrange=[0,2],yrange=[0,200],$
           xs=1,ys=1,title='r vs time, eks=0.0, 0.4, 0.8',psym=3
    endif
    oplot,m/2/!pi,1/rr^3,col=i+2,psym=3
  endfor

;**********************************************************
  xyouts,0.01,0.01,'elliptic_demo.pro: page 2: e)',/normal,chars=.75
  !p.multi=0
  !p.charsize=1.
  charsize,1
  psdirect,program+'_2',ps,/color,/stop,pic='.'

;**********************************************************


psdirect,program+'_3',ps,/color

;skippi:
;----------------------------------------------
; e) PLOT vr,vt,v vs. TIME
;----------------------------------------------
;choose \mu=G(m1+m2) = 1 -> orbital period = 2\pi

myy=1.
a=1.
vcirc=sqrt(myy/a)


!p.multi=[0,1,3]
nwin
!p.charsize=2.
charsize,2

;eccentricity values
  eks_tab=[0., 0.4, 0.8]
  M=findgen(201)/100.*2.*!dpi


;---------- 
; plot v(t)
;---------- 


  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor

    xx=a*(cos(e)-eks)
    yy=b*sin(e)

    ep=sqrt(myy/a^3)/(1-eks*cos(e))
    vx=-a*sin(e)*ep
    vy= b*cos(e)*ep

;numerical velocity components

    vr=(vx*xx+vy*yy)/sqrt(xx^2+yy^2)
    vtx=vx-vr*xx/sqrt(xx^2+yy^2)
    vty=vy-vr*yy/sqrt(xx^2+yy^2)
    vt=sqrt(vtx^2+vty^2)	
    v=sqrt(vx^2+vy^2)

;analytic velocity components

    rr=a*(1-eks*cos(e))    
    vr_ana=vcirc*a/rr*eks*sin(e)
    vt_ana=vcirc*b/rr
    v_ana =vcirc*sqrt((1+eks*cos(e))/(1-eks*cos(e)))
	
    if(i eq 0) then begin
      plot,m/2/!pi,v,xtitle='T/PER',ytitle='v',$
           xrange=[0,2],yrange=[0,4],$
           xs=1,ys=1,title='eks=0.0, 0.4, 0.8: symbol=numerical',psym=6,syms=.4
      oplot,m/2/!pi,v_ana,lines=0        
    endif
    oplot,m/2/!pi,v,col=i+2,psym=6,syms=.4
      oplot,m/2/!pi,v_ana,lines=0,col=i+2        
  endfor


;---------- 
; plot v_r(t)
;---------- 

  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor

    xx=a*(cos(e)-eks)
    yy=b*sin(e)

    ep=sqrt(myy/a^3)/(1-eks*cos(e))
    vx=-a*sin(e)*ep
    vy= b*cos(e)*ep

;numerical velocity components

    vr=(vx*xx+vy*yy)/sqrt(xx^2+yy^2)
    vtx=vx-vr*xx/sqrt(xx^2+yy^2)
    vty=vy-vr*yy/sqrt(xx^2+yy^2)
    vt=sqrt(vtx^2+vty^2)	
    v=sqrt(vx^2+vy^2)

;analytic velocity components

    rr=a*(1-eks*cos(e))    
    vr_ana=vcirc*a/rr*eks*sin(e)
    vt_ana=vcirc*b/rr
    v_ana =vcirc*sqrt((1+eks*cos(e))/(1-eks*cos(e)))
	
    if(i eq 0) then begin
      plot,m/2/!pi,vr,xtitle='T/PER',ytitle='v_r',$
           xrange=[0,2],yrange=[-2,2],$
           xs=1,ys=1,title='eks=0.0, 0.4, 0.8: symbol=numerical',psym=6,syms=.4
      oplot,m/2/!pi,vr_ana,lines=0        
    endif
    oplot,m/2/!pi,vr,col=i+2,psym=6,syms=.4
      oplot,m/2/!pi,vr_ana,lines=0,col=i+2        
  endfor


;---------- 
; plot v_t(t)
;---------- 

  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor

    xx=a*(cos(e)-eks)
    yy=b*sin(e)

    ep=sqrt(myy/a^3)/(1-eks*cos(e))
    vx=-a*sin(e)*ep
    vy= b*cos(e)*ep

;numerical velocity components

    vr=(vx*xx+vy*yy)/sqrt(xx^2+yy^2)
    vtx=vx-vr*xx/sqrt(xx^2+yy^2)
    vty=vy-vr*yy/sqrt(xx^2+yy^2)
    vt=sqrt(vtx^2+vty^2)	
    v=sqrt(vx^2+vy^2)

;analytic velocity components

    rr=a*(1-eks*cos(e))    
    vr_ana=vcirc*a/rr*eks*sin(e)
    vt_ana=vcirc*b/rr
    v_ana =vcirc*sqrt((1+eks*cos(e))/(1-eks*cos(e)))
	
    if(i eq 0) then begin
      plot,m/2/!pi,vt,xtitle='T/PER',ytitle='v_t',$
           xrange=[0,2],yrange=[0,4],$
           xs=1,ys=1,title='eks=0.0, 0.4, 0.8: symbol=numerical',psym=6,syms=.4
      oplot,m/2/!pi,vt_ana,lines=0        
    endif
    oplot,m/2/!pi,vt,col=i+2,psym=6,syms=.4
      oplot,m/2/!pi,vt_ana,lines=0,col=i+2        
  endfor

;**********************************************************
 xyouts,0.01,0.01,'elliptic_demo.pro: page 3: f)',/normal,chars=.75
 !p.multi=0
 !p.charsize=1.
 charsize,1
;**********************************************************
psdirect,program+'_3',ps,/color,/stop,pic='.'

psdirect,program+'_4',ps,/color

;----------------------------------------------
; f) PLOT EKIN, EPOT, H vs TIME
;----------------------------------------------
;choose \mu=G(m1+m2) = 1 -> orbital period = 2\pi

myy=1.
a=1.
vcirc=sqrt(myy/a)


!p.multi=0
nwin
!p.charsize=1.
charsize,1

;eccentricity values
  eks_tab=[0., 0.4, 0.8]
  M=findgen(201)/100.*2.*!dpi

  for i=0,n_elements(eks_tab)-1 do begin
    eks=eks_tab(i)
    b=sqrt(1.-eks^2)*a
    e=m*0
    for j=0,n_elements(m)-1 do begin
      kepler,m(j),eks,eano
      e(j)=eano
    endfor

    rr=a*(1-eks*cos(e))    
    vr_ana=vcirc*a/rr*eks*sin(e)
    vt_ana=vcirc*b/rr
    v_ana =vcirc*sqrt((1+eks*cos(e))/(1-eks*cos(e)))	
    ekin=0.5*v_ana^2
    epot=-myy/rr   	
    amom=rr*vt_ana
 
    print,'ECCENTRICITY, ANGULAR MOMENTUM',eks,mean(amom)

    if(i eq 0) then begin
      plot,m/2/!pi,EKIN,xtitle='T/PER',ytitle='EKIN, EPOT, H, A_MOM',$
           xrange=[0,2],yrange=[-2,2],$
           xs=1,ys=1,title='eks=0.0, 0.4, 0.8'
      oplot,m/2/!pi,EPOT
      xyouts,0.75,-1.5,'EPOT'
      xyouts,0.75, 1.5,'EKIN'
      xyouts,1.,-.4,'ETOT=-0.5'
    endif
    oplot,m/2/!pi,EKIN,col=i+2
      oplot,m/2/!pi,EPOT,lines=0,col=i+2
      oplot,m/2/!pi,epot+ekin,col=i+2,lines=2        
      oplot,m/2/!pi,amom,col=i+2,lines=1
      ff='(f6.3)'
      xyouts,1.15,mean(amom)+.01,col=i+2,string(eks,ff)+' -> AMOM='+string(mean(amom),ff)
  endfor

;**********************************************************
 xyouts,0.01,0.01,'elliptic_demo.pro: page 4: g)',/normal,chars=.75
 !p.multi=0
 !p.charsize=1.
 charsize,1
;**********************************************************
psdirect,program+'_4',ps,/color,/stop,pic='.'
end




