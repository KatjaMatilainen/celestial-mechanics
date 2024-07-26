;*****************************************************
;rk_inte1_eks_taylor2.pro
;*****************************************************

;check how the integration error depends on eccentricity,
;when using II degree taylor
 
 program='rk_inte1_eks_taylor2'
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
 


 
end
