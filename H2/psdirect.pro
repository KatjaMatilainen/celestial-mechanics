pro psdirect,file,ps0,stop=stop,vfont0=vfont0,color0=color0,$
             xsize0=xsize0,ysize0=ysize0,open=open,defps=defps,$
             background=background,scale=scale,true0=true0,$
             pic=pic

 if(n_params() le 0 and not keyword_set(defps)) then begin
     print,'psdirect,file,ps'
     print,'ps = 0 -> plot to screen'
     print,'ps = 1 -> plot file.eps  -1 -> also plot_stamp'
     print,'ps = 2 -> plot file.ps   -2 -> also plot_stamp'
     print,'if !psforce exists it overrides ps'
     print,'KEYWORDS:'
     print,'  /vfont, /color'
     print,'  /stop -> psclose and print info-message'
     print,'   xsize (def=16), ysize(def=12)'
     print,'  defps = value -> define !psforce and exit
     print,'          if value <-2 or >2 then defps is ignored'
     print,'EXAMPLE:'
     print,"; print to fig1.eps"
     print,"    psdirect,'fig1',1"
     print,"    plot,findgen(10),title='psdirect.pro example'"
     print,"    psdirect,'fig1',1,/stop"
     print,"; force subsequant plots to screen, regardless"
     print,"; of what values of ps is given via call"
     print,"    psdirect,def=0.1
     print,"    psdirect,'fig1',1"
     print,"    plot,findgen(10),title='psdirect.pro example'"
     print,"    psdirect,'fig1',1,/stop"
     print,"; cancel the effect of !psforce"
     print,"    psdirect,def=999"

     return
 endif

 if(keyword_set(defps)) then begin
     defsysv,'!psforce',0.0
     !psforce=defps
     return
 endif

 vfont=0
 if(keyword_set(vfont0)) then vfont=1
 if(keyword_set(color0)) then color=color0
 back=0
 if(keyword_set(background)) then back=background
xsize=16
ysize=12
if(keyword_set(xsize0)) then xsize=xsize0
if(keyword_set(ysize0)) then ysize=ysize0

eps=[1,xsize,ysize,0,0]



ps=ps0
defsysv,'!psforce',exists=i
if(i eq 1) then begin
    if(!psforce lt 1 and !psforce ge 0) then ps=0
    if(!psforce eq 1) then ps=1
    if(!psforce eq 2) then ps=2
    if(!psforce eq -1) then ps=-1
    if(!psforce eq -2) then ps=-2
;print,'ps=',ps
endif


    if(ps eq -1 and keyword_set(stop)) then plot_stamp,file,sca=.7
    if(ps eq -2and  keyword_set(stop)) then plot_stamp,file,sca=.7

 if(not keyword_set(stop)) then begin
     if(abs(ps) eq 1) then begin
         psopen,file+'.eps',vfont=vfont,eps=eps,color=color,back=back
     endif
     if(abs(ps) eq 2) then begin
         psopen,file+'.ps',vfont=vfont,color=color,back=back
         if(keyword_set(scale)) then !p.charsize=scale
     endif
 endif

 if(keyword_set(stop)) then begin
     psclose
     if(abs(ps) eq 1) then begin
         print,'$ghostview '+file+'.eps'+' &'
     endif
     if(abs(ps) eq 2) then begin
         if(keyword_set(scale)) then !p.charsize=1.
         print,'$ghostview '+file+'.ps'+' -swap -mag -2 &'
     endif

     if(keyword_set(open)) then begin
         cmd='ghostview '+file+'.eps'+' &'
         spawn,cmd
     endif



     if(abs(ps) eq 1 and keyword_set(pic)) then begin
         cmd='ps2pdf '+file+'.eps'
         spawn,cmd
         cmd='mv '+file+'.pdf '+pic
         spawn,cmd
     endif

endif

     

 
end

