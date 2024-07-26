;*******************************************
  function inte_simple_func,t,yy
;*******************************************
;non-perturbed 2-body integration 
;in cartesian coordinates
;called by inte_simple

  common any_name,myy

  x=yy(0)
  y=yy(1)
  vx=yy(2)
  vy=yy(3)
  dydx=yy*0.

  r2=x^2+y^2
  r3=r2^1.5
  fx=-myy*x/r3
  fy=-myy*y/r3
  
  dydx(0)=vx
  dydx(1)=vy
  dydx(2)=fx
  dydx(3)=fy
  return,dydx
end


