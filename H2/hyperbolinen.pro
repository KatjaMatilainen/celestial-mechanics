;Annetaan nopeus- ja paikkavektorit, laske rata

r_peri=[1.,0,0]
v_peri=[0,2,0]
time=(-5.+findgen(100)/10)*2*!pi

rv_to_elem,0,r_peri,v_peri,elem,/print
elem_orbit_oma,elem,time

;ONGELMA: en saanut onnistumaan samaan kuvaan plottausta siitä, missä
;kohti komeetta on hetkellä T=-1(vuotta)

end
