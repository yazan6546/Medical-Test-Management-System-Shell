delete_test() {
  cat -n medicalRecord.txt

  echo ""
  echo "Enter the line number of the test you want to delete."

  read line
  line=$(echo "$line" | tr -d " ")

  while ! echo "$line" | grep -qE '^[0-9]+$' # checks if the input is in the right format
  do
	  echo "You need to enter a valid number. or -1 to exit input"
	  read line
	  echo ""

	  if [[ "$line" == "-1" ]]
	  then
		  printf "Insertion cancelled\n\n"
		  exit 2
	  fi
  done

  sed "${line}d" medicalRecord.txt > temp
  mv temp medicalRecord.txt

  echo "Record #${line} successfully deleted."
  echo ""
}
