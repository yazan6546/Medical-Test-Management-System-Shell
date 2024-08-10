med_test_count=$(wc -l < medicalTest.txt)
declare -a instance_count
declare -a instance_val
declare -a avgs
declare -A tests

#declare -a instance_val

to_upper() {
  echo "$1" | tr "[a-z]" "[A-Z]"
}

i=0


while IFS= read -r line
do

	test=$(echo "$line" | cut -d";" -f1)
	test=$(to_upper "$test")
	tests[$test]=$i
	instance_count["$i"]=0
	instance_val["$i"]=0

	i=$((i + 1))

done < medicalTest.txt




while IFS= read -r line
do

	test_type=$(echo "$line" | cut -d":" -f2 | cut -d"," -f1)
	test_type=$(to_upper "$test_type")
	test_result=$(echo "$line" | cut -d":" -f2 | cut -d"," -f3)
	index=${tests[$test_type]}
	instance_count["$index"]=$((${instance_count[$index]} + 1))

	instance_val["$index"]=$(echo "${instance_val[$index]} + $test_result" | bc)
	#echo ${instance_val[$index]}
done <medicalRecord.txt


j=0
while [ "$j" -lt "${#tests[@]}" ]
do

	if [ ${instance_count[$j]} -gt 0 ]
	then
		avgs["$j"]=$(echo "scale=1;${instance_val[$j]} / ${instance_count[$j]}" | bc)
	else
		avgs["$j"]=-1
	fi
	j=$(("$j"+1))

done 

j=0
while IFS= read -r line
do

	test_type=$(echo "$line" | cut -d";" -f1 | cut -d":" -f2)
	test_type=$(to_upper "$test_type")
	index=${tests[$test_type]}
	echo "The average for the $test_type test is: ${avgs[$index]}"

done < medicalTest.txt

