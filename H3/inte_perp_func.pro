;********************************************************
    function inte_perp_func,t,yy
;********************************************************
; perturbed 2-body integration using cartesian coordinates
; perturbing force: F = alfa * R/r + beta V/v  + gamma * N
; called by inte_perp.pro (HS 07.10.02/12.11.06)
;********************************************************
    common inte_perp_com,myy,alfa,beta,gamma

    x=yy(0) & y=yy(1) & z=yy(2) & vx=yy(3) & vy=yy(4)  & vz=yy(5)
    dydx=yy*0.
    r2=x^2+y^2+z^2
    r3=r2^1.5d0
    r=sqrt(r2)

;central force
    fx=-myy*x/r3
    fy=-myy*y/r3
    fz=-myy*z/r3

;perturbation ?
    if(alfa ne 0.) then begin
        fx=fx+alfa*x/r
        fy=fy+alfa*y/r
        fz=fz+alfa*z/r
    endif
    if(beta ne 0.) then begin
        v=sqrt(vx^2+vy^2+vz^2)
        fx=fx+beta*vx/v
        fy=fy+beta*vy/v
        fz=fz+beta*vz/v
    endif
    if(gamma ne 0.) then begin
        cross_product,[x,y,z],[vx,vy,vz],n
        nn=sqrt(n(0)^2+n(1)^2+n(2)^2)
        nx=n(0)/nn & ny=n(1)/nn & nz=n(2)/nn
        fx=fx+gamma*nx
        fy=fy+gamma*ny
        fz=fz+gamma*nz
    endif

    dydx(0)=vx & dydx(1)=vy & dydx(2)=vz & dydx(3)=fx & dydx(4)=fy & dydx(5)=fz    
    return,dydx
end










