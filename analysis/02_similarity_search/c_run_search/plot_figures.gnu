#set terminal pngcairo size 800,600 font 'Helvetica,18'
#set output "set5_1.png"
#set xlabel "Number of analog seqs"; set ylabel "E-value"; set yrange [0.001:100]; set xrange [-100:1500]; set logscale y; set key bottom; set grid ; p "semiselected_results_set5.dat" u 0:1 w lp lw 3 pt 2 ps 0.5 not, 2.4 lc 2 t "E=2.4", 1.0 lc 3 t "E=1.0"
#set output "set5_2.png"
#set xlabel "Number of analog seqs"; set ylabel "E-value"; set yrange [0.1:10]; set xrange [0:100]; set logscale y; set key bottom; set grid; p "semiselected_results_set5.dat" u 0:1 w lp  lw 3 pt 2 ps 0.8 not, 2.4 lc 2 t "E=2.4", 1.0 lc 3 t "E=1.0"
#set output "set5_3.png"
#set xlabel "Number of analog seqs"; set ylabel "E-value"; set yrange [0.001:100]; set xrange [1:1500]; set logscale xy; set key bottom; set grid; p "semiselected_results_set5.dat" u 0:1 w lp lw 3 pt 2 ps 0.5 not, 2.4 lc 2 t "E=2.4", 1.0 lc 3 t "E=1.0"


#set terminal pngcairo size 800,600 font 'Helvetica,18'
#set output "edss90_1.png"
#set xlabel "Number of analog seqs"; set ylabel "E-value"; set yrange [0.01:100]; set xrange [-100:1200]; set logscale y; set key bottom; set grid ;
#p "semiselected_results_edss90.dat" u 0:1 w lp lw 3 pt 2 ps 0.5 not, 2.4 lc 2 t "E=2.4", 1.0 lc 3 t "E=1.0"
#set output "edss90_2.png"
#set xlabel "Number of analog seqs"; set ylabel "E-value"; set yrange [0.1:10]; set xrange [0:100]; set logscale y; set key bottom; set grid;
#p "semiselected_results_edss90.dat" u 0:1 w lp  lw 3 pt 2 ps 0.8 not, 2.4 lc 2 t "E=2.4", 1.0 lc 3 t "E=1.0"
#set output "edss90_3.png"
#set xlabel "Number of analog seqs"; set ylabel "E-value"; set yrange [0.01:100]; set xrange [1:1200]; set logscale xy; set key bottom; set grid;
#p "semiselected_results_edss90.dat" u 0:1 w lp lw 3 pt 2 ps 0.5 not, 2.4 lc 2 t "E=2.4", 1.0 lc 3 t "E=1.0"


#set terminal pngcairo size 900,800 font 'Helvetica,20'
#set output "comparison.png"
#set size ratio 0.9; set grid;
#set yrange [0:300]; 
#set style fill solid; 
#set boxwidth 0.6;
#set ylabel "Number of peptides"
#set xlabel "Matrix variant"
#p "num_results_vs_mat.dat" u 0:2:xtic(1) w boxes lc rgb "#4F5B94" t "BLOSUM", "" u 0:2:2 w labels offset char 0,0.7 not, "" u ($0+0.15):3 w boxes lc 3 t "EDSSMat", "" u ($0+0.15):3:3 w labels offset char 0,0.7 textcolor rgb "white" not

#set terminal pngcairo size 900,800 font 'Helvetica,20'
#set output "comparison2.png"
#set size ratio 0.9; set grid;
#set yrange [0:300]; 
#set style fill solid; 
#set boxwidth 0.6;
#set ylabel "Number of peptides"
#set xlabel "Matrix variant"
#p "num_results_vs_mat.dat" u 0:4:xtic(1) w boxes lc rgb "#4F5B94" t "BLOSUM", "" u 0:4:4 w labels offset char 0,0.7 not, "" u ($0+0.15):5 w boxes lc 3 t "EDSSMat", "" u ($0+0.15):5:5 w labels offset char 0,0.7 textcolor rgb "white" not

#set terminal pngcairo size 700,700 font 'Helvetica,16'
#set output "results_1.png"
#load 'palette.gnu'
#set grid; set size ratio 1.75; set xrange [0:40]; set xtics autofreq 10; set yrange [0:70]; set ylabel "Agonist seq length"; set xlabel "Overlapping seq length";
#p "semiselected_rev_results_bsum80.dat" u 6:4:(log10($1)>1?1:log10($1)<-1?-1:log10($1)) w p pt 7 ps 1.4 palette not, x lc rgb "gray" not

#set terminal pngcairo size 700,600 font 'Helvetica,16'
#set output "results_2.png"
#load 'palette.gnu'
#set grid; set size ratio 1; set xrange [0:105]; set xtics autofreq 10; set ytics autofreq 10; set yrange [0:105]; set xlabel"Coverage"; set ylabel "%positives"; p "semiselected_rev_results_bsum80.dat" u 3:2:(log10($1)>1?1:log10($1)<-1?-1:log10($1)) w p pt 7ps 1.4 palette not

set terminal pngcairo size 900,700 font 'Helvetica,16'
set output "familiy_1.png"
set ytics ("0" -1, "1" 0, "2" 1, "3" 2, "4" 3, "5" 4);
set ylabel "%post / %pre"; set xrange [-0.5:9]; set xtics offset 0.15;  set yrange [-1.5:4]; set style fill solid; set boxwidth 0.3; set grid; p "init_pep_dist.dat" u 0:($6/$5-1):xtic(1) w boxes lc rgb "#4F5B94" t "BLOSUM80", "" u ($0+0.3):($7/$5-1) w boxes lc 3 t "EDSSMat90", 0 lc rgb "#333333" lw 2 not

