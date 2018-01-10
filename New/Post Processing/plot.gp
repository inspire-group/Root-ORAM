################ Sameer's GNU plot file ####################

reset
############## Output Control ##############
#set terminal qt size 800,600 enhanced font 'Helvetica,24' persist
#png
set terminal pngcairo enhanced font "Verdana" size 800, 600
#set terminal pngcairo enhanced font "Helvetica,24" size 800, 600
#set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
# eps
#set terminal postscript eps size 8,6 enhanced color font "Helvetica,24" linewidth 2
#set output "plot.eps"
# epslatex
#set terminal epslatex size 8,6 standalone color colortext 10
#set output "plot.tex"



# use for epslatex
#set format '$%g$'
set border linewidth 4
# set style line 1 lc rgb '#0060ad' linetype 1 linewidth 2 pointtype 7 pointinterval -1 pointsize 1.5 # --- blue
# set style line 2 lc rgb '#dd181f' linetype 1 linewidth 2 pointtype 7 pointinterval -1 pointsize 1.5 # --- red
set style line 1 lc rgb '#0060ad' linetype 1 linewidth 2 pointtype 7 pointsize 1.5 # --- blue circle 
set style line 2 lc rgb '#dd181f' linetype 1 linewidth 2 pointtype 7 pointsize 1.5 # --- red circle 
set style line 3 lc rgb '#09ad00' linetype 1 linewidth 2 pointtype 7 pointsize 1.5 # --- green circle 
set style line 4 lc rgb '#0060ad' linetype 1 linewidth 2 pointtype 3 pointsize 1.5 # --- blue star 
set style line 5 lc rgb '#dd181f' linetype 1 linewidth 2 pointtype 3 pointsize 1.5 # --- red star 
set style line 6 lc rgb '#09ad00' linetype 1 linewidth 2 pointtype 3 pointsize 1.5 # --- green star 
set tics scale 1.25
# set pointintervalbox 1
# view is 60 rot_x, 30 rot_z, 1 scale, 1 scale_z
set view 120,60


################# Mean Stash Plot #################
set output "Results/mean_stash_delta.png"
#set pointsize 5
set hidden3d
set ticslevel 0.0
set key center top box 5
set cblabel "colour gradient" 
set colorbox bdefault

set xlabel "k" font "Verdana" offset -1, -1
set ylabel "Epsilon" font "Verdana" offset 0, 0
set zlabel "Mean Stash" font "Verdana" offset 1, 1
set dgrid3d 30,30
#set dgrid3d 100,100 qnorm 2
#set isosample 40
splot 'path_12_4_delta.txt' using 1:2:3 title "Mean Stash vs k, epsilon"
# splot 'path_12_4_main.txt' using 1:2:3 with lines title 'Bandwidth vs k, epsilon'



################# Mean Stash Plot #################
set output "Results/max_stash_delta.png"
#set pointsize 5
set hidden3d
set ticslevel 0.0
set key center top box 5
set cblabel "colour gradient" 
set colorbox bdefault

set xlabel "k" font "Verdana" offset -1, -1
set ylabel "Epsilon" font "Verdana" offset 0, 0
set zlabel "Max Stash" font "Verdana" offset 1, 1
set dgrid3d 50,50 qnorm 2
splot 'path_12_4_delta.txt' using 1:2:4 with pm3d title "Max Stash vs k, epsilon"
# splot 'path_12_4_main.txt' using 1:2:3 with lines title 'Bandwidth vs k, epsilon'


################# Stash Reduction Plot #################
set output "Results/stash_reduction_delta.png"
#set pointsize 5
set hidden3d
set ticslevel 0.0
set key center top box 5
set cblabel "colour gradient" 
set colorbox bdefault
# set zrange [0:5]

set xlabel "k" font "Verdana" offset -1, -1
set ylabel "Epsilon" font "Verdana" offset 0, 0
set zlabel "Stash Reduction" font "Verdana" offset 1, 1
set dgrid3d 50,50 qnorm 2
# splot 'path_12_4_delta.txt' using 1:2:5 with pm3d title "Stash Reduction vs k, epsilon"
splot 'path_12_4_delta.txt' using 1:2:5 with pm3d title "Stash Reduction vs k, epsilon"