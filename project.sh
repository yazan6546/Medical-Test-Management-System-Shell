#! /bin/sh

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

