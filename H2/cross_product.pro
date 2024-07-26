;***************************
;cross_product.pro 
;***************************
pro cross_product,a,b,c

if(n_params(0) le 0) then begin
    print,'----------------------------------------------'
    print,' pro cross_product,A,B,C'
    print,' C=A x B'
    print,'----------------------------------------------'
    print,' case 1: A and B are 3-element vectors:'
    print,'   A=[ax,ay,az], B=[bx,by,bz]] -> C=[cx,cy,cz]'
    print,'----------------------------------------------'
    print,' case 2: A and B contain an array of 3-element vectors'
    print,'   A=array(n,3) B=array(n,3) -> C=array(n,3)'
    print,'----------------------------------------------'
    print,'HS ca 2000'
    return
endif

if(n_elements(a) eq 3) then begin
    c=a
    c(0)=a(1)*b(2)-b(1)*a(2)
    c(1)=a(2)*b(0)-b(2)*a(0)
    c(2)=a(0)*b(1)-b(0)*a(1)
endif

if(n_elements(a) gt 3) then begin
    n=n_elements(a)/3
    c=a
    c(*,0)=a(*,1)*b(*,2)-b(*,1)*a(*,2)
    c(*,1)=a(*,2)*b(*,0)-b(*,2)*a(*,0)
    c(*,2)=a(*,0)*b(*,1)-b(*,0)*a(*,1)
endif

return
end
