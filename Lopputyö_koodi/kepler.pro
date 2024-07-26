;------------------------------------------------------------------------;
; Function for solving Kepler's equation
;------------------------------------------------------------------------;
function kepler,input

;--------------------------------------------------------------------;
;Input=[M,ecc]
;--------------------------------------------------------------------;
;Natural anomaly
M=input(0)
;Eccentricity
ecc=input(1)
;Max number of iterations
n=10000

;--------------------------------------------------------------------;
;Starting values
;--------------------------------------------------------------------;
;Index i
i=0
;Eccentric anomaly
E=M
;Desired accuracy
acc=0.0001

;--------------------------------------------------------------------;
;Loop for solving eccentric anomaly from Kepler's equation
;M=E-ecc*sin(E) -> E=M+ecc*sin(E)
;--------------------------------------------------------------------;
while i lt n do begin
;The previous value of E
    Eold=E
;New value of E
    E=Eold+ecc*sin(Eold)

;--------------------------------------------------------------------;
;Compare the difference to the desired accuracy 'acc',
;stop the loop if accuracy is better/the same as 'acc'
;--------------------------------------------------------------------;
;Current accuracy:
    acc_now=abs(E-Eold)/E
;Compare to desired accuracy
if acc_now le acc then break

;Increase index i
i=i+1
endwhile

;print the final accuracy
print,'Accuracy (%)'
print,acc_now*100.d0

;print the number of steps needed
print,'Number of steps'
print,i

;--------------------------------------------------------------------;
;Return the final result
;--------------------------------------------------------------------;
result=E
return,result
end
