
show_menu() {
  printf "________Medical Test Management System_________\n\n"
  echo "1) Add a new medical test"
  echo "2) Search for a test by patient ID"
  echo "3) Search for all abnormal tests"
  echo "4) Get the average test values"
  echo "5) Update an existing test result"
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
  while true; do

  show_find_menu
  echo ""
  echo "Choose your option"
  read option

  case "$option"
  in

      1) echo "${arr[@]}" | tr " " "\n"
         echo "";;
      2) continue ;;
      3) continue ;;
      4) echo "Enter status"
         read status
         echo "${arr[@]}" | tr " " "\n" | grep -i "${status}$"
         echo "";;

      5) break;;
    esac
  done
}

check_valid_date() {

  if  ! echo "$1" | grep -qE '^[0-9]\{4\}-[0-9]\{2\}$'
  then
    return 1
  fi

  day=$(echo "$1" | cut -d"-" -f2)

  if [ "$day" -lt 1 -a "$day" -gt 31 ]
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


#save_patients() {
#  arr=()
#  while IFS= read -r line; do
#  arr+=("$line")
#  done < "$1"
#}

#
# Function that takes patient ID and prints all tests of this patient
#

find_patient_tests() {

#  count=0
#  found=()
#  for patient in "${arr[@]}"
#  do
#      id=$(echo "$patient" | cut -d":" -f1)
#      if [ "$id" -eq "$1" ]
#      then
#        echo "${arr[$count]}"
#      fi
#
#      count=$((count + 1))
#  done\


  arr=()

  while IFS= read -r line; do
    arr+=("$line")
  done < <(grep "^$1" medicalRecord.txt)
}

filter_spaces() {
  cat "$1" | tr -d " " > temp
  mv temp "$1"

}



filter_spaces medicalRecord.txt
filter_spaces medicalTest.txt
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
    handle_find_case $id
    ;;
  3);;
  4);;
  5);;
  *) echo "Wrong option!";;

  esac
done


