;Summataan tarkasteltavan planeetan ja maan heliosentriset
;radiusvektorit yhteen.

print,'Jupiter'

;Tarkasteltavan planeetan heliosentrinen radiusvektori:
elem1=[5.20336301,0.04839266,1.30530,100.55616,274.19769,19.6505]
r_heliosentr,elem1,Rh1,tulosta=2

print,'Maa'

;Maan heliosentrinen radiusvektori:
elem2=[1.00000011,0.01671022,0.00005,-11.26064,114.20781, -2.48284]
r_heliosentr,elem2,Rh2,tulosta=2

;V‰hennet‰‰n vektorit toisistaan
Rh=Rh1-Rh2

;Siirryt‰‰n ekliptikakoordinaatistosta ekvaattorij‰rjestelm‰‰n
ekl=23.4393/!radeg
R_ekl=[Rh(0),(cos(ekl)*Rh(1)-sin(ekl)*Rh(2)),(sin(ekl)*Rh(1)+cos(ekl)*Rh(2))]
;print,R_ekl

;Selvitet‰‰n rektaskensio, deklinaatio ja et‰isyys:
rek=atan((R_ekl(1))/R_ekl(0))
delt=sqrt((R_ekl(0))^2+(R_ekl(1))^2+(R_ekl(2))^2)
dek=asin((R_ekl(2))/delt)


print,rek*!radeg
print,dek*!radeg
print,delt

end
