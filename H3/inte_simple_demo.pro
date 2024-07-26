program='inte_simple_demo'
ps=0

psdirect,program+'_1',ps,/color
inte_simple_f,eks=0.5,dt=0.01,choice=1
psdirect,program+'_1',ps,/color,/stop

psdirect,program+'_2',ps,/color
inte_simple_f,eks=0.5,dt=0.01,choice=2
psdirect,program+'_2',ps,/color,/stop

psdirect,program+'_3',ps,/color
inte_simple_f,eks=0.5,dt=0.01
psdirect,program+'_3',ps,/color,/stop

end
