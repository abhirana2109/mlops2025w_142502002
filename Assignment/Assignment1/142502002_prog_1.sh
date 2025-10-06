#!/bin/bash

<<question1
    Write a shell script to find the roots of the quadratic equation
question1

clear

echo "----- Quadratic Equation Root Finder -----"

# take user input
read -p "Enter the value of a: " a
read -p "Enter the value of b: " b
read -p "Enter the value of c: " c

echo "Equation: ${a}x^2 + ${b}x + ${c} = 0"

# discriminant
d=$(echo "$b^2 - 4*$a*$c" | bc -l)

if (( $(echo "$d > 0" | bc -l) )); then
	echo "Two distinct real roots:-"
	root1=$(echo "scale=7; ((-1 * $b) + sqrt($d)) / (2 * $a)" | bc -l)
	root2=$(echo "scale=7; ((-1 * $b) - sqrt($d)) / (2 * $a)" | bc -l)
	echo "Root 1: $root1"
	echo "Root 2: $root2"

elif (( $(echo "$discriminant == 0" | bc -l) )); then
    echo "One real root:-"
    root1=$(echo "scale=7; -$b / (2*$a)" | bc -l)
    echo "Root: $root1"

else
    echo "Two complex roots:-"
    realPart=$(echo "scale=7; (-1 * $b) / (2 * $a)" | bc -l)
    iPart=$(echo "scale=7; sqrt(-1 * $d) / (2 * $a)" | bc -l)
    echo "Root 1 = $realPart + ${iPart}i"
    echo "Root 2 = $realPart - ${iPart}i"
fi