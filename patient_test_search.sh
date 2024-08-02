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
# given the medical test name
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
