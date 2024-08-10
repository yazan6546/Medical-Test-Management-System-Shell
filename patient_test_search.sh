handle_find_case() {

  find_patient_tests $1 # saves all patients with input id in an array "arr"

  if [ "${#arr[@]}" -eq 0 ]
  then
      echo "ID not found...."
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

      3) echo "Enter dates in this format exactly : YYYY-MM"
         echo "Enter date 1"
         read date1
         check_valid_date "$date1" || { printf "Date is incorrect...\n"; continue; }
         echo "Enter date 2"
         read date2
         check_valid_date "$date2" || { printf "Date is incorrect...\n"; continue; }

         get_tests_from_date "$date1" "$date2" || printf "\nNo tests found in this period\n";;

      4) echo "Enter status"
         read status
         echo "$patient_list" | grep -i "${status}$" || printf "\nNo tests found..."
         echo "";;

      5) break;;
      *) printf "Invalid option...\n\n"
    esac
  done
}

get_tests_from_date() {

  flag=1
  year1=$(echo "$1" | cut -d',' -f2 | cut -d'-' -f1)
  month1=$(echo "$1" | cut -d',' -f2 | cut -d'-' -f2)

  year2=$(echo "$2" | cut -d',' -f2 | cut -d'-' -f1)
  month2=$(echo "$2" | cut -d',' -f2 | cut -d'-' -f2)

  for test in "${arr[@]}"
  do
    year=$(echo "$test" | cut -d',' -f2 | cut -d'-' -f1)
    month=$(echo "$test" | cut -d',' -f2 | cut -d'-' -f2)

    if [ "$year" -gt "$year1" -a "$year" -lt "$year2" ]
    then
      echo "$test"
      flag=0
    elif [ "$year" -eq "$year1" -a "$year" -ne "$year2" -a "$month" -ge "$month1" ]
    then
      echo "$test"
      flag=0

    elif [ "$year" -eq "$year1" -a "$year" -eq "$year2" -a "$month" -ge "$month1" -a "$month" -le "$month2" ]
    then
      echo "$test"
      flag=0

    elif [ "$year" -eq "$year2" -a "$year" -ne "$year1" -a "$month" -le "$month2" ]
    then
      echo "$test"
      flag=0
    else
      continue
    fi

  done

  return "$flag"
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

    result1=$(echo "$test_result > $number1" | bc )
    result2=$(echo "$test_result < $number1" | bc )

    if [ \( "$compare1" = "<" -a "$result1" -eq 1 \) -o  \( "$compare1" = ">" -a "$result2" -eq 1 \) ]
    then
        return 0
    fi

    result1=$(echo "$test_result > $number2" | bc )
    result2=$(echo "$test_result < $number2" | bc )

    if [ "$number_values" -eq 2 ]
    then
      if [ \( "$compare2" = "<" -a "$result1" -eq 1 \) -o  \( "$compare2" = ">" -a "$result2" -eq 1 \) ]
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

  if  ! echo "$1" | grep -qE "^(19[0-9]{2}|20[0-2][0-9]|2030)-(0[1-9]|1[0-2])$"
  then
    return 1
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

