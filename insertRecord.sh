# function to check if the date provided is in past or present
is_date_in_past() {
        input_year=$(echo $1 | cut -d"-" -f1)
        input_month=$(echo $1 | cut -d"-" -f2)

        if { [[ $input_year -lt $current_year ]] && [[ $((10#$input_month)) -le 12 ]]; } ||
        { [[ $input_year -eq $current_year ]] && [[ $((10#$input_month)) -le $((10#$current_month)) ]]; };
        then
		echo "0"
    	else
		echo "1"
    	fi
}

#ID insertion block

echo "Insert record ID:"
read record_id
echo ""
id_len=$(echo -n  "$record_id" | wc -m) #count number of characters in users input

while [[ $id_len -ne 7  ||  ! $record_id =~ ^[0-9]+$ ]] #enters correction if ID contains alphabetics or not 7 characters long
do
        echo "ID length should be 7 digits, please reneter a correct ID or enter -1 to cancel: "
        read record_id
        echo ""

        id_len=$(echo -n  $record_id | wc -c)

        if [ $record_id == -1 ] #exits the operation 
        then
                printf "Insertion cancelled\n\n"
                exit 1
        fi
done






# test name insertion

echo "Insert test name:"
read test_name
echo ""

while [[ -z $test_name ]] || ! grep -qi "${test_name};" medicalTest.txt #checks for null strings and if the test exists
do
	echo "You need to enter a valid name or -1 to exit insertion"
	read test_name
	echo ""
	
	if [[ "$test_name" == "-1" ]]
	then
		printf "Insertion cancelled\n\n"
		exit 2
	fi
done


# date insertion


echo "Insert test date:"
echo "Format: YYYY-MM" #the date format

read test_date
echo ""

correct_date_format="^(19[0-9]{2}|20[0-2][0-9]|2030)-(0[1-9]|1[0-2])$" #the exact date format that should be followed

current_month=$(date +%m)
current_year=$(date +%Y)


is_past=$(is_date_in_past "$test_date")

until [[ $test_date =~ $correct_date_format && $is_past == 0 ]] #asks for re-ensertion until the input is correct
do
	echo "incorrect date formatting, please insert date in the format YYYY-MM or enter -1 to exit insertion"
	read test_date
	echo ""

	if [[ $test_date =~ $correct_date_format ]]
	then
		is_past=$(is_date_in_past "$test_date")
	fi

	if [[ "$test_date" == "-1" ]]
	then
		printf "Insertion cancelled\n\n"
		exit 3
	fi
done



#test result insertion

echo "Insert test result:"
read test_result
echo ""

until [[ $test_result =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
do
	echo "The test result must be a floating point number, make sure to enter the result correctly or enter -1 to exit (if a test result is -1, write it as -1.0)."
	read test_result
	echo ""

	if [[ $test_result == -1 ]]
        then
                printf "Insertion cancelled\n\n"
                exit 4
        fi 
done


#grabbing the test unit from medicalTest file
test_unit=$(grep -i "${test_name};" medicalTest.txt | cut -d";" -f3)

echo "Insert the status of the test:"
read test_status
test_status=$(echo "$test_status" | tr -d " ")
echo ""

while ! echo "$test_status" | grep -qiE 'completed|pending|reviewed';
do
        echo "please enter a valid status or -1 to exit."
        read test_status

        if [[ $test_status == "-1" ]]
        then
                printf "Insertion cancelled\n\n"
                exit 5
        fi

done
record=$(echo "$record_id:$test_name,$test_date,$test_result,$test_unit,$test_status" | tr -d " ")
echo "$record" >> medicalRecord.txt

sort medicalRecord.txt > temp
mv temp medicalRecord.txt

printf "Insertion completed successfully!\n\n"