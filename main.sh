source patient_test_search.sh

show_menu() {
  printf "________Medical Test Management System_________\n\n"
  echo "1) Add a new medical test"
  echo "2) Search for a test by patient ID"
  echo "3) Search for all abnormal tests"
  echo "4) Get the average test values"
  echo "5) Update an existing test result"
  echo "6) Exit program"
  echo ""
}

show_find_menu() {
  printf "\n1) Retrieve all patient tests\n"
  echo "2) Retrieve all up normal patient tests"
  echo "3) Retrieve all patient tests in a given specific period"
  echo "4) Retrieve all patient tests based on test status"
  echo "5) Go back to menu"
}


filter_spaces() {
  cat "$1" | tr -d " " > temp
  mv temp "$1"
}

remove_blank_lines() {
  sed '/^$/d' "$1" > temp
  mv temp "$1"
}

check_file() {

file_name=$1
  if [ ! -w "$file_name" ]
  then
      echo "$file_name Does not exist or is not writable"
  exit 1
  fi
}



check_file medicalTest.txt
check_file medicalRecord.txt

filter_spaces medicalRecord.txt
filter_spaces medicalTest.txt

remove_blank_lines medicalRecord.txt
remove_blank_lines medicalTest.txt

#find_patient_tests 1300511
#
#echo "${arr[@]}" | tr " " "\n"

while true; do
  show_menu
  echo "Choose your option."
  read option

  case "$option"
  in

  1) ./insertRecord.sh;;
  2)
    echo "enter patient ID"
    read id
    handle_find_case "$id"
    ;;

  3)
    echo "enter test name"
    read test_name
    find_tests "$test_name"
    echo ""
    ;;

  4) ./getTestAvgs.sh;;
  5) ./updateTestVal.sh;;
  6) exit 0;;
  *) printf "Invalid option...\n\n";;

  esac
done


