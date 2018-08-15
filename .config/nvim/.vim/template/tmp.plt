# setting {{{
reset
#set object 1 rectangle from graph 0, graph 0 to graph 1, graph 1 behind
#set object 1 rectangle fillcolor rgb "#eeece1" fillstyle solid 1.0
set grid # linewidth 0.2 linetype 1 linecolor 0
set terminal aqua font ",25"
set size ratio 2.0/(1.0 + sqrt(5.0)) # 黄金比
set yl "" offset 1.5,0
set border
set lt 1 lw 4 lc rgb "0x0" ps 1.5
set lt 2 lw 4 lc rgb "0x0" ps 1.5 dt(5,3)
set lt 3 lw 4 lc rgb "0x0" ps 1.5 dt(6,3,2,3)
set lt 4 lw 4 lc rgb "0x0" ps 1.5 dt(3,2)
set lt 5 lw 4 lc rgb "0x0" ps 1.5 dt(10,2)
set lt 6 lw 4 lc rgb "0x0" ps 1.5
set lt 7 lw 4 lc rgb "0x0" ps 1.5
# }}}
set term postscript eps enhanced color ",20"
set xl"x"
set yl"y"
set out file.".eps"
plot sin(x)

