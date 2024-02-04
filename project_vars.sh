export p_root=$(pwd)
export p_programs=$p_root/programs
export p_data=$p_root/data
export p_analysis=$p_root/analysis
export p_private=$p_root/private_data
export PATH="$p_programs/getcontacts:$p_programs/ab-blast/:$p_programs/TMalign:$PATH"
export LC_NUMERIC="en_US.UTF-8"

echo -e "Root: \t\t$p_root"
echo -e "Programs: \t$p_programs"
echo -e "Data: \t\t$p_data"
echo -e "Analysis: \t$p_analysis"
echo -e "PATH: \t\t$PATH"
