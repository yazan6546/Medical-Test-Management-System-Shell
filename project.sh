
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
  echo "1) Retrieve all patient tests"
  echo "2) Retrieve all up normal patient tests"
  echo "3) Retrieve all patient tests in a given specific period"
  echo "4) Retrieve all patient tests based on test status"
  echo "5) Go back to menu"
}

handle_find_case() {

  find_patient_tests $1 # saves all patients with input id in an array "arr"

  if [ "${#arr[@]}" -eq 0 ]
  then
      echo "ID not found..."
      echo ""
      return 1
  fi

  # Convert array to newline-separated list
  patient_list=$(printf "%s\n" "${arr[@]}")
  while true; do

  show_find_menu
  echo ""
  echo "Choose your option"
  read option

  case "$option"
  in

      1) echo "$patient_list"
         echo "";;
      2) find_abnormal_tests arr
         echo "";;
      3) continue ;;
      4) echo "Enter status"
         read status
         echo "$patient_list" | grep -i "${status}$"
         echo "";;

      5) break;;
    esac
  done
}

find_abnormal_tests() {

  local array_name="$1"
  local -n tests="${array_name}"

  flag=0 # a flag to point to whether an abnormal test has been found
  for patient in "${tests[@]}"
  do
    test_name=$(echo "$patient" | cut -d':' -f2 | cut -d',' -f1)
    test_result=$(echo "$patient" | cut -d':' -f2 | cut -d',' -f3)

    if is_abnormal "$test_name" "$test_result"
    then
      echo "$patient"
      flag=1
    fi

  done

  if [ "$flag" -eq 0 ]
  then
    echo "No abnormal tests found..."
    echo ""
  fi
}

is_abnormal() {

    test_result="$2"
    test_info=$(grep -i "$1" medicalTest.txt)
    field_range=$(echo "$test_info" | cut -d';' -f2) # >number1,<number2
    number_values=$(echo "$field_range" | tr "," " " | wc -w)

    compare1=$(echo "$field_range" | cut -c1) # get the compare operator
    number1=$(echo "$field_range" | cut -d',' -f1 | cut -c2-) # get normal test result

    compare2=$(echo "$field_range" | cut -d',' -f2 | cut -c1)
    number2=$(echo "$field_range" | cut -d',' -f2 | cut -c2-) # get normal test result

    if [ \( "$compare1" = "<" -a "$test_result" -gt "$number1" \) -o  \( "$compare1" = ">" -a "$test_result" -lt "$number1" \) ]
    then
        return 0
    fi

    if [ "$number_values" -eq 2 ]
    then
      if [ \( "$compare2" = "<" -a "$test_result" -gt "$number2" \) -o  \( "$compare2" = ">" -a "$test_result" -lt "$number2" \) ]
      then
        return 0
      fi
    fi


    return 1
}

#
# Function that returns an array containing medical tests
# given the medical test
#
find_tests() {
  arr_tests=()

  while IFS= read -r line; do
    arr_tests+=("$line")
  done < <(grep -i "$1" medicalRecord.txt)

  find_abnormal_tests arr_tests

}



check_valid_date() {

  if  ! echo "$1" | grep -qE '^[0-9]\{4\}-[0-9]\{2\}$'
  then
    return 1
  fi

  day=$(echo "$1" | cut -d"-" -f2)

  if [ "$day" -lt 1 -a "$day" -gt 12 ]
  then
    return 2
  fi

  year=$(echo "$1" | cut -d"-" -f1)

  if [ "$year" -lt 1900 -a "$year" -gt 2030 ]
  then
      return 3
  fi

  return 0
}

#
# Function that takes patient ID and returns an array of all tests of this patient
#

find_patient_tests() {

  arr=()

  while IFS= read -r line; do
    arr+=("$line")
  done < <(grep "^$1" medicalRecord.txt)
}

filter_spaces() {
  cat "$1" | tr -d " " > temp
  mv temp "$1"
}

remove_blank_lines() {
  sed '/^$/d' "$1" > temp
  mv temp "$1"
}



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

  1) ;;
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

  4);;
  5);;
  6) exit 0;;
  *) echo "Wrong option!";;

  esac
done


