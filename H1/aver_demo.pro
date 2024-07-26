;**********************************************
;aver_demo.pro
;study elliptic orbit
;HS 05.11.02/01.11.2006
;**********************************************

program='aver_demo'
ps=0
psdirect,program,ps,/color


;*********************************************
;calculate time-averages of <r>, <1/r> , <v^2>
;also <1/r^2>,<1/r^3>,<r^2>
;*************************************
;with eccentricity 0.1,0.2,...,0.8
;choose a=1. semimajor axis
;myy=1   G*(m1+m2)
;*************************************
   a=1.
   myy=1.

;eccentricity values
   eks_tab=findgen(21)/20.*.8

;store averages to
   r_tab   = eks_tab*0.
   r2_tab  = eks_tab*0.
   rm1_tab = eks_tab*0.
   rm2_tab = eks_tab*0.
   rm3_tab = eks_tab*0.
   v2_tab  = eks_tab*0.
   vm1_tab  = eks_tab*0.
   
;evaluate with npoints values of time (or M)
   npoints=200
   M=findgen(npoints)*2.*!dpi/npoints
   
;requires solution of eccentric anomaly from Kepler's equation
;M = E - eks*sin(E)
   
   for i=0,n_elements(eks_tab)-1 do begin       
       eks=eks_tab(i)
       b=sqrt(1.-eks^2)*a
       e=m*0
       for j=0,n_elements(m)-1 do begin
           kepler,m(j),eks,eano
           e(j)=eano
       endfor
       
       sine=sin(e)
       cose=cos(e)
       xx=a*(cose-eks)
       yy=b*sine
       dedt=sqrt(myy/a^3)/(1.d0-eks*cos(e))
       vxx=-a*sine*dedt
       vyy=b*cose*dedt
       
       r=sqrt(xx^2+yy^2)
       v=sqrt(vxx^2+vyy^2)
; or v=sqrt(myy/a)*sqrt((1.+eks*cose)/(1.-eks*cose))
       
       r_tab(i)=mean(r)
       r2_tab(i)=mean(r^2)
       rm1_tab(i)=mean(1./r)
       rm2_tab(i)=mean(1./r^2)
       rm3_tab(i)=mean(1./r^3)
       v2_tab(i)=mean(v^2)
       vm1_tab(i)=mean(1./v)
   endfor
   

   
   nwin
   !p.multi=[0,3,2]
   !p.charsize=1.2
   
   
   plot,eks_tab,r2_tab,xtitle='eks',ytitle='<r^2>/a',$
     title='npoints='+string(npoints,'(i6)')
   oplot,eks_tab,(1.+3*eks_tab^2/2),psym=6,col=2
   
   plot,eks_tab,r_tab,xtitle='eks',ytitle='<r>/a',title='symbol=analytical'
   oplot,eks_tab,(1.+eks_tab^2/2),psym=6,col=2
   
   plot,eks_tab,rm1_tab,xtitle='eks',ytitle='<1/r>/a',yr=[0,1.2]
   oplot,eks_tab,1.+eks_tab*0,psym=6,col=2
   
   plot,eks_tab,rm2_tab,xtitle='eks',ytitle='<1/r^2>/a'
   oplot,eks_tab,(1.-eks_tab^2)^(-0.5),psym=6,col=2
   
   plot,eks_tab,rm3_tab,xtitle='eks',ytitle='<1/r^3>/a'
   oplot,eks_tab,(1.-eks_tab^2)^(-1.5),psym=6,col=2

   plot,eks_tab,v2_tab,xtitle='eks',ytitle='<v^2>/(myy/a)',yr=[0,1.2]
   oplot,eks_tab,1.+eks_tab*0,psym=6,col=2
   
   xyouts,0.01,0.01,/normal,'aver_demo.pro',chars=.75
   charsize,1
   !p.multi=0


psdirect,program,ps,/color,/stop,pic='.'

end







