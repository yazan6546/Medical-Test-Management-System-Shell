echo "enter the ID of the record you want to update:"

read record_id

id_len=$(echo -n  $record_id | wc -m) #count number of characters in users input

while [[ $id_len -ne 7  ||  ! $record_id =~ ^[0-9]+$ ]] #enters correction if ID contains alphabetics or not 7 characters long
do
        echo "ID length should be 7 digits, please reneter a correct ID or enter -1 to cancel: "

        read record_id

        id_len=$(echo -n  $record_id | wc -c)

        if [ $record_id = -1 ] #exits the operation 
        then
                echo "Insertion cancelled"
                exit 1
        fi
done

line_to_update="-1"

while IFS= read -r line
do
	line_id=$(echo "$line" | cut -d":" -f1)
	
	if [ $line_id = $record_id ]
	then
		line_to_update=$(echo "$line")
		$(sed -i "/$line_id/d" ./medicalRecord.txt)
		break
	fi
done < medicalRecord.txt

echo $line_to_update
if [ $line_to_update = "-1" ] 
then
	"No record matches the ID you have entered."
	exit 1
fi


echo "Insert new test result:"

read new_test_result

until [[ $new_test_result =~ ^-?[0-9]+\.?[0-9]*$ ]]
do
	echo "The test result must be a floating point number, make sure to enter the result correctly or enter -1 to exit (if a test result is -1, write it as -1.0)."

	read new_test_result
	if [ $new_test_result = -1 ]
        then
                echo "Insertion cancelled"
                echo $line_to_update >> medicalRecord.txt
                exit 1
        fi 
done


old_test_result=$(echo $line_to_update | cut -d"," -f3 | sed 's/^[ \t]*//;s/[ \t]*$//')

updated_line=$(echo $line_to_update | sed "s/$old_test_result/$new_test_result/")

echo $updated_line >> medicalRecord.txt
	
	


	


