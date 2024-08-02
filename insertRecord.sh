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

is_date_in_past() {
        input_year=$(echo "$test_date" | cut -d"-" -f1)
        input_month=$(echo "$test_date" | cut -d"-" -f2)
	
        if { [[ "$input_year" -lt "$current_year" ]] && [[ $((10#$input_month)) -le 12 ]]; } || 
        { [[ "$input_year" -eq "$current_year" ]] && [[ $((10#$input_month)) -le $((10#$current_month)) ]]; }; 
        then
		echo "0"
    	else
		echo "1"
    	fi
}

is_past=$(is_date_in_past)

until [[ $test_date =~ $correct_date_format && "$is_past" == 0 ]] #asks for re-ensertion until the input is correct 
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
