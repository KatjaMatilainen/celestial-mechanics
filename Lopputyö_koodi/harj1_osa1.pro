;------------------------------------------------------------------------;
; Celestial mechanics: Computer exercises I, part 1
;------------------------------------------------------------------------;
; What to do: 
; a) Write an IDL-procedure that solves the eccentric anomaly 'E' for a 
;    given natural anomaly 'M' and eccentricity 'ecc'.
;----> This is done in the separate function 'kepler.pro'
; b) Solve E  corresponding to M=45degrees for different values of 
;    eccentricity (ecc=[0.01,0.05,0.5,0.9,099]).
;    How many iteration steps are required to reach an accuracy of
;    0.01deg in each case?
;    Try also what happens for M=359deg.

;------------------------------------------------------------------------;
; Use the subroutine PsPlot to save results in a postscript plot 
; (written by Heikki Salo)
;------------------------------------------------------------------------;
pro PsPlot,routine,filename
	thisdir=getenv('PWD')+'/'
	psopen,/color,dir=thisdir,filename
	call_procedure,routine
	psclose		
     end
;------------------------------------------------------------------------;

;------------------------------------------------------------------------;
;  MAIN PROGRAM starts here
;------------------------------------------------------------------------;
pro harj1_osa1

;Natural anomalies

;M=45deg (change to radians)
M1=45.d0/360*2*!dpi

;M=359deg (change to radians)
M2=359.d0/360*2*!dpi

;Eccentricities:
ecc1=0.01d0
ecc2=0.05d0
ecc3=0.5d0
ecc4=0.9d0
ecc5=0.99d0

;Use the function 'kepler', input=[M,ecc]

print,' '
print,' '
print,'---------------------------------'
print,'E for M=45deg, ecc=0.01'
print,'---------------------------------'
;E for M=45deg, ecc=0.01
input1=[M1,ecc1]
E1=kepler(input1)
print,'Eccentric anomaly E'
print,E1
print,'---------------------------------'

print,' '
print,' '
print,'---------------------------------'
print,'E for M=45deg, ecc=0.05'
print,'---------------------------------'
;E for M=45deg, ecc=0.05
input2=[M1,ecc2]
E2=kepler(input2)
print,'Eccentric anomaly E'
print,E2
print,'---------------------------------'

print,' '
print,' '
print,'---------------------------------'
print,'E for M=45deg, ecc=0.5'
print,'---------------------------------'
;E for M=45deg, ecc=0.5
input3=[M1,ecc3]
E3=kepler(input3)
print,'Eccentric anomaly E'
print,E3
print,'---------------------------------'

print,' '
print,' '
print,'---------------------------------'
print,'E for M=45deg, ecc=0.9'
print,'---------------------------------'
;E for M=45deg, ecc=0.9
input4=[M1,ecc4]
E4=kepler(input4)
print,'Eccentric anomaly E'
print,E4
print,'---------------------------------'

print,' '
print,' '
print,'---------------------------------'
print,'E for M=45deg, ecc=0.99'
print,'---------------------------------'
;E for M=45deg, ecc=0.99
input5=[M1,ecc5]
E5=kepler(input5)
print,'Eccentric anomaly E'
print,E5
print,'---------------------------------'

print,' '
print,' '
print,'---------------------------------'
print,'E for M=45deg, ecc=0.99'
print,'---------------------------------'
;E for M=45deg, ecc=0.99
input5=[M1,ecc5]
E5=kepler(input5)
print,'Eccentric anomaly E'
print,E5
print,'---------------------------------'

;Test the program for M>2pi
print,' '
print,' '
print,'---------------------------------'
print,'E for M=359deg, ecc=0.01'
print,'---------------------------------'
;E for M=45deg, ecc=0.01
input6=[M2,ecc1]
E6=kepler(input6)
print,'Eccentric anomaly E'
print,E6
print,'---------------------------------'
;Result: the iteration blows up

end

;--------------------------------------------------------------------;
; Save the results to a PostScript file using PsPlot
;--------------------------------------------------------------------;
pro Plot_everything
PsPlot, 'harj1_osa1', 'harj1_osa1.ps'
end
