;Numeerinen integrointi: toisen kertaluvun Taylor-sarja

ecc=0.1
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

dt=0.0001*P
n=long(10*P/dt)

timet=findgen(n)*dt
!x.range=[-2,2]
!y.range=[-2,2]

elem_orbit,[a,ecc,0,0,0,0],timet,rr,vv,myy0=myy,plot=1
;stop

h_tab=timet*0
k_tab=timet*0

for i=
