pro kepler_oma,M,ecc,E,tulosta=tulosta,acc0=acc0

  if n_params() eq 0 then begin
     print, 'pro kepler_oma,M,ecc,E,tulosta=tulosta,acc0=acc0'
     print, 'M ja E radiaaneina'
     print, 'M voi olla skalaari tai taulukko.'
     print, 'ecc on skalaari'
     return
  endif

;M=1/!radeg
;ecc=0.50

  
  E=M
  acc=0.001/!radeg

  if keyword_set(acc0) then acc=acc0

  for i=0,1000 do begin
     Eold=E
     x=ecc*sin(E)
     E=M+x

     if keyword_set(tulosta) then print,i,E

     if max(abs(E-Eold)) LT acc then goto,skip
  endfor
skip:

  if keyword_set(tulosta) then print,E*!radeg

end
