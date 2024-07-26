;acosh.pro
;hyperbolisen cosinin kaanteisfunktio
;y=cosh(x)=0.5*(exp(x)+exp(-x))
;--> x=acosh(y)
;HS circa 1997

function acosh,y
  x=alog(y+sqrt(y^2-1))
return,x
end
