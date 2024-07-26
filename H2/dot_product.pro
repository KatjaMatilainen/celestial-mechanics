;***************************
;dot_product.pro
;scalar-product c = a . b
;***************************

pro dot_product,a,b,c

if(n_params(0) le 0) then begin
    print,'----------------------------------------------'
    print,' pro dot_product,A,B,c'
    print,' scalar product c = A . B'
    print,'----------------------------------------------'
    print,' case 1: A and B are 3-element vectors:'
    print,'   A=[ax,ay,az], B=[bx,by,bz]] -> c =ax*bx+ay*by+az*bz'
    print,'----------------------------------------------'
    print,' case 2: A and B contain an array of 3-element vectors'
    print,'   A=array(n,3) B=array(n,3) -> c=array(n)'
    print,'----------------------------------------------'
    print,'HS ca 2000'
    return
endif
if(n_elements(a) eq 3) then begin
    c=a(0)*b(0)+a(1)*b(1)+a(2)*b(2)
endif
if(n_elements(a) gt 3) then begin
    n=n_elements(a)/3
    c=a(*,0)
    c=a(*,0)*b(*,0)+a(*,1)*b(*,1)+a(*,2)*b(*,2)
endif

return
end
