;*****************************************************
;rk_inte1_dttest.pro
;*****************************************************

;check how the integration error depends on eccentricity,
;when using II degree taylor
 
 program='rk_inte1_dttest'
 ps=0 
 psdirect,program,ps,/color

 dtorb=[100]
 dt_tab=1.d0/dtorb
 dl_tab=dt_tab
 de_tab=dt_tab
 dejump_tab=dt_tab
 t1=0.d0
 t2=10.d0

;----------------------------------------------------------------

 elem=[1.,0.5,0.,0.,0.,0.]*1.d0
 rk_inte1,elem,t1,t2,dt_tab(0),plot=0,oplot=i,dl=dl,de=de,$
   out=-1,taylor=2,/sile,t_out=t_out,e_out=e_out
 nwin
 plot,t_out,e_out,yr=[-0.15,0.05],ys=1,xr=[0,10],$
   xtitle='T/PERIOD',ytitle='dE/E',$
   title='II Taylor, dt/per=0.01, EKS=0.1, 0.3, 0.5'
 
 
 elem=[1.,0.3,0.,0.,0.,0.]*1.d0
 rk_inte1,elem,t1,t2,dt_tab(0),plot=0,oplot=i,dl=dl,de=de,$
   out=-1,taylor=2,/sile,t_out=t_out,e_out=e_out
 oplot,t_out,e_out,col=2
 

 elem=[1.,0.1,0.,0.,0.,0.]*1.d0
 rk_inte1,elem,t1,t2,dt_tab(0),plot=0,oplot=i,dl=dl,de=de,$
   out=-1,taylor=2,/sile,t_out=t_out,e_out=e_out
 oplot,t_out,e_out,col=3
 psdirect,program,ps,/color,/stop
 

;----------------------------------------------------------------
;check how the integration error depends on timestep
;when using Rk4
;ecc=0.5 and 0.9
;store separately secular and periodic errors



 for iround=0,1 do begin
     
     if(iround eq 0) then begin
         elem=[1.,0.5,0.,0.,0.,0.]*1.d0
         program='rk_inte1_dttest_eks05'
         ps=0.
     endif
     
     if(iround eq 1) then begin
         elem=[1.,0.9,0.,0.,0.,0.]*1.d0
         program='rk_inte1_dttest_eks09'
         ps=0.
     endif
     
     psdirect,program,ps,/color
     
;*****************************************************

     dt_tab=[.03d0,.01d0,.003d0,.001d0,.0003d0,.0001d0,.00003d0]*1.d0
     t1=0.d0
     t2=2.d0
     dtorb=[30.d0,100.d0,300.d0,1000.d0,3000.d0,10000.d0,30000.d0]




     dt_tab=1.d0/dtorb
     dl_tab=dt_tab
     de_tab=dt_tab
     dejump_tab=dt_tab


     !p.multi=[0,3,2]
     nwin
     
     for idegree=1,6 do begin
         
         if(idegree eq 1) then begin
             taylor=1
             staylor='Taylor I'
         endif
         
         if(idegree eq 2) then begin
             taylor=2
             staylor='Taylor II'
         endif
         
         if(idegree eq 3) then begin
             taylor=-3
             staylor='Taylor III'
         endif
         
         if(idegree eq 4) then begin
             taylor=-4
             staylor='Taylor IV'
         endif
         
         if(idegree eq 5) then begin
             taylor=-5
             staylor='Taylor  V'
         endif
         
         if(idegree eq 6) then begin
             taylor=-6
             staylor='Taylor VI'
         endif


         for i=0,n_elements(dt_tab)-1 do begin
             rk_inte1,elem,t1,t2,dt_tab(i),plot=0,oplot=i,dl=dl,de=de,$
               out=-1,taylor=taylor,dt=dtorb(i),/sile,t_out=t_out,e_out=e_out
             
             
;kasautuva virhe dE/E (kierrosta kohti). vastaavasti dL/L
             dl_tab(i)=dl 
             de_tab(i)=de 

;virhe perisentrin ohituksen yhteydessa
             apu=abs(t_out-0.5)
             ind_per05=where(apu eq min(apu))
             ind_per05=ind_per05(0)
             dejump_tab(i)=abs(e_out(ind_per05))
             
             
         endfor
         
         plot,dt_tab,abs(dl_tab),psym=-4,/xlog,/ylog,yr=[1d-16,100],ys=1,$
           xtit='DT',ytit='dE/E (/ORBIT)',xr=[1d-5,1d-1],xs=1,$
           title=staylor+'  EKS='+string(elem(1),'(f6.2)'),col=2,/nod,chars=1.2
         
;cumulative
         oplot,dt_tab,abs(de_tab),psym=-6,col=2,syms=.8
;jump
         oplot,dt_tab,abs(dejump_tab),psym=-2,col=5,syms=.8,lines=2


;RK4
         goto,nork
         if(idegree eq 4) then begin
             for i=0,n_elements(dt_tab)-1 do begin
                 rk_inte1,elem,t1,t2,dt_tab(i),plot=0,oplot=i,dl=dl,de=de,$
                   out=-1,/sile,t_out=t_out,e_out=e_out 
                 dl_tab(i)=dl 
                 de_tab(i)=de 
                 
;virhe perisentrin ohituksen yhteydessa
                 apu=abs(t_out-0.5)
                 ind_per05=where(apu eq min(apu))
                 ind_per05=ind_per05(0)
                 dejump_tab(i)=abs(e_out(ind_per05))


             endfor
             oplot,dt_tab,abs(de_tab),psym=-4,col=9,syms=1.2        
             oplot,dt_tab,abs(dejump_tab),psym=-2,col=4,syms=1.2,lines=-2        
         endif
nork:



if(idegree eq 1) then begin
label_data,0.1,0.5,[' secular',' periodic'],lines=[0,2],col=[2,5],psym=[6,2]
endif
         
;------------------------------------------------------
;different slopes for comparison
;------------------------------------------------------

         x=10.^(dindgen(5)*.4-3)
         oplot,x,(x/0.001d0)*1d-15,lines=2,col=3
         oplot,x,(x/0.001d0)^2*1d-15,lines=2,col=3
         oplot,x,(x/0.001d0)^3*1d-15,lines=2,col=3
         oplot,x,(x/0.001d0)^4*1d-15,lines=2,col=3
         oplot,x,(x/0.001d0)^5*1d-15,lines=2,col=3
         oplot,x,(x/0.001d0)^6*1d-15,lines=2,col=3
         
         !p.charsize=0.7
         xyouts,0.05,1d-5,'6',col=3
         xyouts,0.05,1d-7,'5',col=3
         xyouts,0.05,0.5d-8,'4',col=3
         xyouts,0.05,1d-10,'3',col=3
         xyouts,0.05,2d-12,'2',col=3
         xyouts,0.05,0.7d-13,'1',col=3
         !p.charsize=1
     endfor
     
     !p.multi=0
     psdirect,program,ps,/color,/stop
     
 endfor
 
end
