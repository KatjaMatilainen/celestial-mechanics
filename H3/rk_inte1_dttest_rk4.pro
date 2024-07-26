;*****************************************************
;rk_inte1_dttest_rk4.pro
;*****************************************************
;kaytetty luentokuvien tekemiseen
;13.2.2005


elem=[1.,0.5,0.,0.,0.,0.]*1.d0
program='rk_inte1_dttest_rk4'
ps=0.

psdirect,program,ps,/color
   dt_tab=[.03d0,.01d0,.003d0,.001d0,.0003d0,.0001d0,.00003d0]*1.d0
   t1=0.d0
   t2=10.d0
   dtorb=[30.d0,100.d0,300.d0,1000.d0,3000.d0,10000.d0,30000.d0]
;   dtorb=[30.d0,100.d0,300.d0,1000.d0,3000.d0,10000.d0]
   dt_tab=1.d0/dtorb


   dt_tab=[0.01,0.001]
   dl_tab=dt_tab
   de_tab=dt_tab


!p.multi=0

    for i=0,n_elements(dt_tab)-1 do begin
        rk_inte1,elem,t1,t2,dt_tab(i),plot=0,oplot=i,dl=dl,de=de,$
          out=-1,t_out=t_out,e_out=e_out
        dl_tab(i)=dl 
        de_tab(i)=de
        
        if(i eq 0) then begin
            plot,t_out,e_out,/ylog,yr=[1.d-15,1d0],$
              title='rk4, Dt=0.01, 0.001',xtitle='TIME/PERIOD',ytitle='DE/E'
           
        endif

        if(i ne 0) then begin
            oplot,t_out,e_out,col=i+1
        endif

        
 
    endfor



psdirect,program,ps,/stop

end
