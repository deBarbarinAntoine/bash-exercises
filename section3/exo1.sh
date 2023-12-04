#!/bin/bash

if [ $# != 1 ]; then
  >&2 echo "Error: This program expects one and only one numerical parameter";
else
  regex='^[+-]?([0-9]+|[0-9]*\.[0-9]+)$'
  if [[ $1 =~ $regex ]]; then
    declare -i note=${1%.*}
    echo -n "With note $1, "
    if [[ note -lt 0 ]]; then
      echo "you just didn't even try, right?"
      echo "How did you do to have such a qualification, anyway?"
      echo "Go away, you trash!"
    elif [[ note -lt 10 ]]; then
      echo "you didn't pass your exam, sorry!"
      if [[ note -lt 5 ]]; then
        echo "How did you do to have such a trash qualification?"
        echo "Go away, you noob!"
      fi
    elif [[ note -lt 12 ]]; then
      echo "you passed your exam with mention 'Passable'."
    elif [[ note -lt 14 ]]; then
      echo "you passed your exam with mention 'Rather good'."
    elif [[ note -lt 16 ]]; then
      echo "you passed your exam with mention 'Good'."
    elif [[ note -le 20 ]]; then
      echo "you passed your exam with mention 'Very good'."
      echo "Congratulations!"
    else
      echo "you cheated, I think... :("
      echo "How can you have more than 20/20, anyway?"
      echo "Go away, you traitor!"
    fi
  else
    >&2 echo "Error: The parameter must be an int or a float";
  fi
fi
