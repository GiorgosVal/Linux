#!/bin/bash
A=7
B=2
C='3.1'

echo "A is ${A}"
echo "B is ${B}"
echo "C is ${C}"
echo

echo "-----------------"
echo "SIMPLE OPERATIONS"
echo "-----------------"
echo "With bash:"
echo "${A} + ${B} = $((A + B))"
echo "${A} - ${B} = $((A - B))"
echo "${A} * ${B} = $((A * B))"
echo "${A} / ${B} = $((A / B))"
echo "${A} % ${B} = $((A % B))"
echo "${A} ** ${B} = $((A ** B))"

echo
echo "With bc:"
echo -n "${A} + ${B} = "
echo "${A} + ${B}" | bc -l
echo -n "${A} - ${B} = "
echo "${A} - ${B}" | bc -l
echo -n "${A} * ${B} = "
echo "${A} * ${B}" | bc -l
echo -n "${A} / ${B} = "
echo "${A} / ${B}" | bc -l
echo -n "${A} / ${B} = "
echo "scale=2; ${A} / ${B}" | bc -l
echo -n "${A} % ${B} = "
echo "${A} % ${B}" | bc -l
echo -n "${A} ^ ${B} = "
echo "${A} ^ ${B}" | bc -l
echo -n "${A} + ${C} = "
echo "${A} + ${C}" | bc -l
echo -n "${A} - ${C} = "
echo "${A} - ${C}" | bc -l
echo -n "${A} * ${C} = "
echo "${A} * ${C}" | bc -l
echo -n "${A} / ${C} = "
echo "${A} / ${C}" | bc -l
echo -n "${A} / ${C} = "
echo "scale=2; ${A} / ${C}" | bc -l
echo -n "${A} % ${C} = "
echo "${A} % ${C}" | bc -l
echo -n "${A} ^ ${C} = "
echo "${A} ^ ${C}" | bc -l

echo
echo "With awk:"
echo -n "${A} + ${B} = "
awk "BEGIN {print ${A} + ${B}}"
echo -n "${A} - ${B} = "
awk "BEGIN {print ${A} - ${B}}"
echo -n "${A} * ${B} = "
awk "BEGIN {print ${A} * ${B}}"
echo -n "${A} / ${B} = "
awk "BEGIN {print ${A} / ${B}}"
echo -n "${A} % ${B} = "
awk "BEGIN {print ${A} % ${B}}"
echo -n "${A} ^ ${B} = "
awk "BEGIN {print ${A} ^ ${B}}"
echo -n "${A} ** ${B} = "
awk "BEGIN {print ${A} ** ${B}}"
echo -n "${A} + ${C} = "
awk "BEGIN {print ${A} + ${C}}"
echo -n "${A} - ${C} = "
awk "BEGIN {print ${A} - ${C}}"
echo -n "${A} * ${C} = "
awk "BEGIN {print ${A} * ${C}}"
echo -n "${A} / ${C} = "
awk "BEGIN {print ${A} / ${C}}"
echo -n "${A} % ${C} = "
awk "BEGIN {print ${A} % ${C}}"
echo -n "${A} ^ ${C} = "
awk "BEGIN {print ${A} ** ${C}}"
echo -n "${A} ** ${C} = "
awk "BEGIN {print ${A} ^ ${C}}"

echo
echo "With let:"
let NUM="${A} + ${B}"
echo "let '${A} + ${B}' = ${NUM}"
let NUM="${A} - ${B}"
echo "let '${A} - ${B}' = ${NUM}"
let NUM="${A} * ${B}"
echo "let '${A} * ${B}' = ${NUM}"
let NUM="${A} / ${B}"
echo "let '${A} / ${B}' = ${NUM}"
let NUM="${A} % ${B}"
echo "let '${A} % ${B}' = ${NUM}"
let NUM="${A} ** ${B}"
echo "let '${A} ** ${B}' = ${NUM}"

echo
echo "With expr:"
echo "${A} + ${B} = $(expr ${A} + ${B})"
echo "${A} - ${B} = $(expr ${A} - ${B})"
echo "${A} \* ${B} = $(expr ${A} \* ${B})"
echo "${A} / ${B} = $(expr ${A} / ${B})"
echo "${A} % ${B} = $(expr ${A} % ${B})"

echo "---------------------------------"
echo "INCREMENT & ASSIGNMENT OPERATIONS"
echo "---------------------------------"
echo "With bash:"
echo -n "${A}++ = "
((A++)) # post-increment
echo "${A}"
echo -n "${A}-- = "
((A--)) # post-decrement
echo "${A}"
echo "++${A} = $((++A))" # pre-increment
echo "--${A} = $((--A))" # pre-decrement
NUM=${A}
echo "${NUM} += 5 => $((NUM += 5))"

echo "With bc:"
echo -n "${A}++ = "
echo "var=${A};var++" | bc -l
echo -n "${A}-- = "
echo "var=${A};var--" | bc -l
echo -n "++${A} = "
echo "var=${A};++var" | bc -l
echo -n "--${A} = "
echo "var=${A};--var" | bc -l

echo
echo "With awk:"
# Refactor the below commented
#echo -n "${A}++ = "
#awk "BEGIN { ${A}++; print ${A}}"
#echo -n "${A}-- = "
#awk "BEGIN {print ${A}--}"

echo
echo "With let:"
echo -n "let ${A}++ = "
let A++
echo ${A}

