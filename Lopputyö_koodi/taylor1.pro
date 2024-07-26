;Numeerinen integrointi: ensimmäisen kertaluvun Taylor-sarja

ecc=0.5
a=1.
b=a*sqrt(1-ecc^2)
myy=1.
P=2*!dpi*sqrt(a^3/myy)

;Alkuarvot:
time=0
E=0
x=a*(cos(E)-ecc)
y=b*sin(E)
z=0
vx=-a*sin(E)*sqrt(myy/a^3)/(1-ecc*cos(E))
vy=b*cos(E)*sqrt(myy/a^3)/(1-ecc*cos(E))
vz=0

dt=0.001*P
n=long(10*P/dt)

timet=findgen(n)*dt
!x.range=[-2,2]
!y.range=[-2,2]

!p.multi=[0,2,2]
elem_orbit,[a,ecc,0,0,0,0],timet,rr,vv,myy0=myy,plot=1
;stop

h_tab=timet*0
k_tab=timet*0
h2_tab=timet*0
k2_tab=timet*0

for i=0,n-1 do begin
time=time+dt
r=sqrt(x^2+y^2+z^2)
v=sqrt(vx^2+vy^2+vz^2)

xp=vx
yp=vy
zp=vz

vxp=-myy*x/r^3
vyp=-myy*y/r^3
vzp=-myy*z/r^3

x=x+xp*dt
y=y+yp*dt
z=z+zp*dt

vx=vx+vxp*dt
vy=vy+vyp*dt
vz=vz+vzp*dt

m=100
if i mod m eq 0 then plots,x,y,psym=3,col=2

h=0.5*v^2-myy/r
;if i mod m eq 0 then print,'h=',h
h_tab(i)=h

k=x*vy-y*vx
;if i mod m eq 0 then print,'k=',k
k_tab(i)=k

endfor

!x.range=[0,0]
!y.range=[0,0]
plot,timet/P,h_tab,ytitle='h'
plot,timet/P,k_tab,ytitle='k'

;Toisen kertaluvun Taylor-sarja

!p.multi=[0,2,2]
!x.range=[-2,2]
!y.range=[-2,2]
elem_orbit,[a,ecc,0,0,0,0],timet,rr,vv,myy0=myy,plot=1

for i=0,n-1 do begin
time=time+dt
r=sqrt(x^2+y^2+z^2)
v=sqrt(vx^2+vy^2+vz^2)

xp=vx
yp=vy
zp=vz

vxp=-myy*x/r^3
vyp=-myy*y/r^3
vzp=-myy*z/r^3

xpp=vxp
ypp=vyp
zpp=vzp

vxpp=-myy/r^3*(vx-3*(x*vx+y*vy+z*vz))*x/(r^2)
vypp=-myy/r^3*(vy-3*(x*vx+y*vy+z*vz))*y/(r^2)
vzpp=-myy/r^3*(vz-3*(x*vx+y*vy+z*vz))*z/(r^2)

x=x+xp*dt+0.5*xpp*dt^2
y=y+yp*dt+0.5*ypp*dt^2
z=z+zp*dt+0.5*zpp*dt^2

vx=vx+vxp*dt+0.5*vxpp*dt^2
vy=vy+vyp*dt+0.5*vypp*dt^2
vz=vz+vzp*dt+0.5*vzpp*dt^2

m=100
if i mod m eq 0 then plots,x,y,psym=3,col=2

h2=0.5*v^2-myy/r
;if i mod m eq 0 then print,'h=',h
h2_tab(i)=h2

k2=x*vy-y*vx
;if i mod m eq 0 then print,'k=',k
k2_tab(i)=k
endfor

!x.range=[0,0]
!y.range=[0,0]
nwin
plot,timet/P,h_tab,ytitle='h'
plot,timet/P,k_tab,ytitle='k'
end
