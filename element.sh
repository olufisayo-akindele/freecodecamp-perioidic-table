#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"




if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

#if argument is atomic number
if [[ ! $1 =~ ^[1-9]+$ ]]
then
  POTENTIAL_ELEMENT=$($PSQL "SELECT e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e INNER JOIN properties p on e.atomic_number=p.atomic_number INNER JOIN types t on t.type_id=p.type_id WHERE name = '$1' or symbol = '$1'")
else
  POTENTIAL_ELEMENT=$($PSQL "SELECT e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e INNER JOIN properties p on e.atomic_number=p.atomic_number INNER JOIN types t on t.type_id=p.type_id WHERE e.atomic_number = '$1'")

#if argument is string
  fi

#element not in db
if [[ ! $POTENTIAL_ELEMENT ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo $POTENTIAL_ELEMENT | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
do
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done

