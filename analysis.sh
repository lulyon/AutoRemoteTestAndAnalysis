#! /bin/bash

declare case_num
declare algorithm_name
# case_num=8
# algorithm_name=overlay

source "config.ini"


if [ -f "concluded_file.config" ];
then
	rm "conclude_file.config"
fi

echo "calcCaseFactor.R"
Rscript calcCaseFactor.R logdata $case_num $algorithm_name

echo "calcCaseFactorWithoutIO.R"
Rscript calcCaseFactorWithoutIO.R logdata $case_num $algorithm_name

echo "calcMinTime.R"
Rscript calcMinTime.R logdata $case_num $algorithm_name

echo "calcConcludedFactor.R"
Rscript calcConcludedFactor.R logdata

echo "mergeKernelTime.R"
Rscript mergeKernelTime.R logdata $case_num $algorithm_name

echo "multiLine.R"
Rscript multiLine.R logdata kernel_time_data_table.txt

echo "paraProficiency.R"
Rscript paraProficiency.R logdata

echo "paraProficiencyWithoutIO.R"
Rscript paraProficiencyWithoutIO.R logdata

echo "relativeSpeedupRadio.R"
Rscript relativeSpeedupRadio.R logdata

echo "relativeSpeedupRadioWithoutIO.R"
Rscript relativeSpeedupRadioWithoutIO.R logdata

echo "speedupRadio.R"
Rscript speedupRadio.R logdata

echo "timeAnalysis.R"
Rscript timeAnalysis.R logdata

echo "timeCompare.R"
Rscript timeCompare.R  logdata

cd logdata
source "concluded_file.config"

cat template.md | sed "s%time_table_content%$time_table_content%g" | \
sed "s%total_table_content%$total_table_content%g" | \
sed "s%cpu_table_content%$cpu_table_content%g" | \
sed "s%replace_s1%$replace_s1%g" | \
sed "s%replace_s2%$replace_s2%g" | \
sed "s%replace_s3%$replace_s3%g" | \
sed "s%replace_s4%$replace_s4%g" | \
sed "s%replace_s5%$replace_s5%g" | \
sed "s%replace_s6%$replace_s6%g" | \
sed "s%replace_s7%$replace_s7%g" | \
sed "s%replace_s8%$replace_s8%g" | \
sed "s%replace_s9%$replace_s9%g" | \
sed "s%replace_sa%$replace_sa%g" | \
sed "s%replace_sb%$replace_sb%g" | \
sed "s%replace_sc%$replace_sc%g" | \
sed "s%replace_sd%$replace_sd%g" > report.md

markdown report.md > report.html


