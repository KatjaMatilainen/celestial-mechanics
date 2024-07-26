;*****************************************************
; elem_orbit.pro
; use elem_to_rv to calculate orbit
; elem = orbital elements [a,eks,ink,ome,w,tau]
; HS 05.11.02 /01.11.2006
;*****************************************************

pro elem_orbit,elem,timet,rr,vv,myy0=myy0,plot=plot

  if(n_params() le 0) then begin
      print,'elem_orbit,elem,timet,rr,vv,myy0=myy0'
      print,'elem = orbital elements [a,eks,ink,ome,w,tau]'
      print,'timet -> calculate RR(*,3)  VV(*,3) for these times'
      print,'myy   -> scaling (def=1.)'
      print,'plot=1 ->  plot x,y orbit'
      print,'plot>1 -> oplot x,y orbit with col=plot'
      print,'----------------------------'
      print,'Example:'
      print,'timet=findgen(101)/100.*2*!pi & !x.range=[-2,2] & !y.range=[-2,2]'
      print,'elem_orbit,[1.,.0,0.,0.,0.,0.],timet,/plot'
      print,'elem_orbit,[1.,.5,0.,0.,0.,0.],timet, plot=2'
      print,'elem_orbit,[1.,.9,0.,0.,0.,0.],timet, plot=3'
      return
  endif

;*****************************************************
;choose scaling
  myy=1
  if(keyword_set(myy0)) then myy=myy0
 
;*****************************************************
;orbital position vector R and velocity vector R are calculated
;for times defined in call
;rr and vv contain position and velocity components

  ntimet=n_elements(timet)
  rr=findgen(ntimet,3)
  vv=findgen(ntimet,3)

  for i=0,ntimet-1 do begin
    time=timet(i)
    elem_to_rv,elem,time,rad,vel,myy=myy
    rr(i,0)=rad(0)
    rr(i,1)=rad(1)
    rr(i,2)=rad(2)
    vv(i,0)=vel(0)
    vv(i,1)=vel(1)
    vv(i,2)=vel(2)
  endfor


if(keyword_set(plot)) then begin
    if(plot eq 1) then begin  
        nwin
        plot,rr(*,0),rr(*,1),xtitle='x',ytitle='y',/iso,psym=6,syms=0.2
        plots,0,0,psym=1
    endif

    if(plot gt 1) then begin          
        oplot,rr(*,0),rr(*,1),col=plot,psym=6,syms=0.2
    endif
endif



return
end
