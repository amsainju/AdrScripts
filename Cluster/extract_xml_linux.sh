#/!bin/bash
# author: JianNan Tian
# timezone: Central Time

# update: 4:18 PM, March 13, 2019
#   check num of args

# update: 3:56 PM, March 13, 2019 (central time)
#   add printing range functionality

if [[ $# -eq 0 ]] ; then
    echo "You need provide at least 1 argument, which is the XML filename."
    echo "And the 2nd optional argument is about the functionality, namely:"
    echo ""
    echo "For example, 
sh ./extract_xml_linux.sh example.xml printRange
    generates CSV and TSV, prints the calculated range
sh ./extract_xml_linux.sh example.xml printCSV
    generates CSV and TSV, prints generated CSV
sh ./extract_xml_linux.sh example.xml
    generates CSV and TSV silently"
    exit 1
fi


xml_file=$1

# grep by desired keyword
cat $xml_file | grep -E "(config type=\"(adc.*\">$|dac.*waveform\">$)|sampFreq|ddc0NcoFreq|ddc1NcoFreq|decimation|centerFreq|bandwidth|afterPulseDelay|alpha|scale|numPoints|numInt|adcMode|bypass|rg)" > tmp

# awk to good format
cat tmp \
	| awk '{ gsub("config type", "configType"); print $0 }' \
	| awk '{ gsub("</.*$", ""); print $0 }' \
	| awk '{ gsub("(^.*<|\">$)", "", $1); print $1 }' \
	| awk '{ gsub("(=\"|>)", "\t"); print $0 }' \
	> tmp2

# delete duplicate of demication (the first occurence)
# comment out for now
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#cat tmp2 | awk '/decimation.*/ && !f{f=1; next} 1' > tmp3
# ----------------------------------------------------------------
cat tmp2 > tmp3
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

echo -e "PARAMETER\tVALUE" > ${xml_file%.*}.tsv
cat tmp3 >> ${xml_file%.*}.tsv


cat ${xml_file%.*}.tsv |  awk '{ gsub("\t", ","); print $0 }' >${xml_file%.*}.csv

if [[ $# -eq 2 ]] ; then
    if [ $2 == "printCSV" ]; then
        cat ${xml_file%.*}.csv
    fi
    if [ $2 == "printTSV" ]; then
        cat ${xml_file%.*}.tsv
    fi
    if [ $2 == "printRange" ]; then
        raw_range=$(cat ${xml_file%.*}.tsv | grep rg | awk '{ print $2}')
        start=$(cut -d':' -f1 <<< $raw_range)
        end=$(cut -d':' -f2 <<< $raw_range)
        #echo $start
        #echo $end
        bc <<< "$end-$start+1"
    fi
fi

# delete imtermediate file
rm -f tmp tmp2 tmp3

