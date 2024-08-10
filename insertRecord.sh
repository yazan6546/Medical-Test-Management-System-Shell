echo "Please insert a new record: "




#ID insertion block

echo "Insert record ID:"
read record_id

id_len=$(echo -n  $record_id | wc -m) #count number of characters in users input

while [[ $id_len -ne 7  ||  ! $record_id =~ ^[0-9]+$ ]] #enters correction if ID contains alphabetics or not 7 characters long
do
        echo "ID length should be 7 digits, please reneter a correct ID or enter -1 to cancel: "

        read record_id

        id_len=$(echo -n  $record_id | wc -c)

        if [ $record_id == -1 ] #exits the operation 
        then
                echo "Insertion cancelled"
                exit 1
        fi
done






# test name insertion

echo "Insert test name:"
read test_name

while [[ -z $test_name ]] #checks for null strings
do
	echo "You need to enter a valid string or -1 to exit insertion"
	read test_name
	
	if [$test_name == -1]
	then
		echo "Insertion cancelled"
		exit 2
	fi
done


# date insertion


echo "Insert test date:"
echo "Format: YYYY-MM" #the date format

read test_date

correct_date_format="^[1-2][0-9][0-9][0-9]-[0-1][0-9]$" #the exact date format that should be followed

current_month=$(date +%m)
current_year=$(date +%Y)


#function to check if the date provided is in past or present
is_date_in_past() {
        input_year=$(echo $test_date | cut -d"-" -f1)
        input_month=$(echo $test_date | cut -d"-" -f2)
	
        if { [[ $input_year -lt $current_year ]] && [[ $((10#$input_month)) -le 12 ]]; } || 
        { [[ $input_year -eq $current_year ]] && [[ $((10#$input_month)) -le $((10#$current_month)) ]]; }; 
        then
		echo "0"
    	else
		echo "1"
    	fi
}

is_past=$(is_date_in_past)

until [[ $test_date =~ $correct_date_format && $is_past == 0 ]] #asks for re-ensertion until the input is correct 
do
	echo "incorrect date formatting, please insert date in the format YYYY-MM or enter -1 to exit insertion"
	read test_date

	if [[ $test_date =~ $correct_date_format ]]
	then
		is_past=$(is_date_in_past)
	fi

	if [ $test_date == -1 ]
	then
		echo "Insertion cancelled"
		exit 3
	fi
done



#test result insertion

echo "Insert test result:"

read test_result

until [[ $test_result =~ ^-?[0-9]+\.?[0-9]*$ ]]
do
	echo "The test result must be a floating point number, make sure to enter the result correctly or enter -1 to exit (if a test result is -1, write it as -1.0)."

	read test_result
	if [ $test_result == -1 ]
        then
                echo "Insertion cancelled"
                exit 4
        fi 
done


#test unit insertion


echo "Insert the unit of the result:"

read test_unit

while [[ -z $test_unit  ]]
do
	echo "please enter a valid unit or -1 to exit."
	read test_unit

	if [ $test_unit == -1 ]
        then
                echo "Insertion cancelled"
                exit 5
        fi

done


#test unit insertion


echo "Insert the status of the test:"

read test_status

while [[ -z $test_status  ]]
do
        echo "please enter a valid status or -1 to exit."
        read test_status

        if [ $test_status == -1 ]
        then
                echo "Insertion cancelled"
                exit 5
        fi

done




echo "$record_id: $test_name, $test_date, $test_result, $test_unit, $test_status" >> medicalRecord.txt

echo "Insertion completed successfully!"
