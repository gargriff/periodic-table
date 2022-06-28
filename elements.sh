#!/bin/bash
# Script that accepts an argument in the form of an atomic number, symbol, or name of an element and outputs some information about the given element.

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

#Check whether argument is given when running script

if [[ -z $1 ]]
then
echo -e "Please provide an element as an argument."

else

  # if input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then

    # find element in database using atomic number
    ELEMENT_DETAILS=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  
  # test whether argument is a single capital letter or single capital letter followed by lower case letter
  elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
  then
  
    # find element in database using symbol
    ELEMENT_DETAILS=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
  
  else
    # find element in database using name
    ELEMENT_DETAILS=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")

  fi

# if element not present
  if [[ -z $ELEMENT_DETAILS  ]]
  then
    # if element not present echo message
    echo "I could not find that element in the database."
  else
      # display element details replace | with space and then read variables with while loop
    echo "$ELEMENT_DETAILS" | sed 's/|/ /g' | while read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
