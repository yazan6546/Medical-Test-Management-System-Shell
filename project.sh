
show_menu() {
  printf "________Medical Test Management System_________\n\n"
  echo "1) Add a new medical test"
  echo "2) Search for a test by patient ID"
  echo "3) Search for all abnormal tests"
  echo "4) Get the average test values"
  echo "5) Update an existing test result"
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


save_patients() {
  arr=()
  while IFS= read -r line; do
  arr+=("$line")
  done < "$1"
}

#
# Function that takes patient ID and prints all tests of this patient
#

find_patient_tests() {

  count=0
  found=()
  for patient in "${arr[@]}"
  do
      id=$(echo "$patient" | cut -d":" -f1)
      if [ "$id" -eq "$1" ]
      then
        echo ${arr[$count]}
      fi

      count=$((count + 1))
  done

}

find_abnormal_patient_tests() {

  count=0
  found=()
  for patient in "${arr[@]}"
  do
      id=$(echo "$patient" | cut -d":" -f1)
      if [ "$id" -eq "$1" ]
      then
        echo ${arr[$count]}
      fi

      count=$((count + 1))
  done

}

save_patients medicalRecord.txt
find_patient 1300511