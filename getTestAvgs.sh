med_test_count=$(wc -l < medicaltests.txt)
declare -a instance_count
declare -a instance_val
declare -a avgs
declare -A tests

#declare -a instance_val

i=0


while IFS= read -r line
do
	test=$(echo "$line" | cut -d";" -f1 | cut -d":" -f2 | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -d"(" -f2 | awk '{print substr($0, 1, length($0)-1)}') 
	tests[$test]=$i
	instance_count[$i]=0
	instance_val[$i]=0

	i=$((i + 1))
done < medicaltests.txt




while IFS= read -r line
do
	test_type=$(echo "$line" | cut -d":" -f2 | cut -d"," -f1 | sed 's/^[ \t]*//;s/[ \t]*$//')
	test_result=$(echo "$line" | cut -d":" -f2 | cut -d"," -f3 | sed 's/^[ \t]*//;s/[ \t]*$//')
	index=${tests[$test_type]}
	instance_count[$index]=$((${instance_count[$index]} + 1))
	echo ${instance_count[$index]}
	
	instance_val[$index]=$(echo "${instance_val[$index]} + $test_result" | bc)
	echo ${instance_val[$index]}
done <medicalRecord.txt


j=0
while [ $j -lt "${#tests[@]}" ]
do	
	if [ ${instance_count[$j]} -ne 0 ]
	then
		avgs[$j]=$(echo "${instance_val[$j]} / ${instance_count[$j]}" | bc)
	else
		avgs[$j]=-1
	fi
	j=$(($j+1))
done 


j=0
while IFS= read -r line
do
	test_type=$(echo "$line" | cut -d";" -f1 | cut -d":" -f2 | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -d"(" -f2 | awk '{print substr($0, 1, length($0)-1)}') 
	index=${tests[$test_type]}
	
	echo "the average for the $test_type test is: ${avgs[$index]}"
done < medicaltests.txt 

