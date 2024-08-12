  cat -n medicalRecord.txt

  echo ""
  echo "Enter the line number of the test you want to update."
  
  med_record_count=$(wc -l < medicalRecord.txt)
  
  read line
  line=$(echo "$line" | tr -d " ")

  while ! [[ "$line" =~ ^[0-9]+$ ]] || [ "$line" -gt "$med_record_count" ] # checks if the input is in the right format
  do
	  echo "You need to enter a valid number. or -1 to exit input"
	  read line
	  echo ""

	  if [[ "$line" == "-1" ]]
	  then
		  printf "update cancelled\n\n"
		  exit 1
	  fi
  done


echo "Insert new test result:"

read new_test_result

until [[ $new_test_result =~ ^-?[0-9]+\.?[0-9]*$ ]]
do
	echo "The test result must be a floating point number, make sure to enter the result correctly or enter -1 to exit (if a test result is -1, write it as -1.0)."

	read new_test_result
	if [ $new_test_result = -1 ]
        then
                echo "Update cancelled"
                exit 2
        fi 
done


old_test_result=$(sed -n "${line}p" medicalRecord.txt | cut -d"," -f3 | sed 's/^[ \t]*//;s/[ \t]*$//')


  sed "${line}s/${old_test_result}/${new_test_result}/g" medicalRecord.txt > temp
  mv temp medicalRecord.txt

  echo "Record #${line} successfully updated."
  echo ""
  
  cat -n medicalRecord.txt
	
