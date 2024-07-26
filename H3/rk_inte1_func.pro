;*******************************************
function rk_inte1_func,t,yy
;*******************************************
;non-perturbed 2-body integration 
;in cartesian coordinates
;called by rk_inte1

common rk_inte1_com,myy

x=yy(0)
y=yy(1)
z=yy(2)
vx=yy(3)
vy=yy(4)
vz=yy(5)
dydx=yy*0.

r2=x^2+y^2+z^2
r3=r2^1.5
fx=-myy*x/r3
fy=-myy*y/r3
fz=-myy*z/r3

dydx(0)=vx
dydx(1)=vy
dydx(2)=vz
dydx(3)=fx
dydx(4)=fy
dydx(5)=fz

return,dydx
end


