# Arithmetic Operations
## With bash
```bash
echo "A is ${A}"
echo "B is ${B}"
echo "C is ${C}"
echo

echo "Doing calculations with bash"
echo "${A} + ${B} = $((A + B))"     # 7 + 2 = 9
echo "${A} - ${B} = $((A - B))"     # 7 - 2 = 5
echo "${A} * ${B} = $((A * B))"     # 7 * 2 = 14
echo "${A} / ${B} = $((A / B))"     # 7 / 2 = 3
echo "${A} % ${B} = $((A % B))"     # 7 % 2 = 1
echo "${A} ** ${B} = $((A ** B))"   # 7 ** 2 = 49
# Arithmetics with floats generate syntax errors
```
>**Note:** Bash doesn't support floating point arithmetic. Do accomplish this we need to use external programs such as `bc`, `awk`, etc).

## With `bc`
### Quick interactive calculator
Just type `bc` or `bc -l` (use the predefined math routines) and execute calculations. To exit, press `Ctrl + D`.

### Use in script
```bash
echo "Doing the same calculations with bc:"
echo -n "${A} + ${B} = "
echo "${A} + ${B}" | bc -l          # 7 + 2 = 9
echo -n "${A} - ${B} = "
echo "${A} - ${B}" | bc -l          # 7 - 2 = 5
echo -n "${A} * ${B} = "
echo "${A} * ${B}" | bc -l          # 7 * 2 = 14
echo -n "${A} / ${B} = "
echo "${A} / ${B}" | bc -l          # 7 / 2 = 3.50000000000000000000
echo -n "${A} / ${B} = "
echo "scale=2; ${A} / ${B}" | bc -l # 7 / 2 = 3.50
echo -n "${A} % ${B} = "
echo "${A} % ${B}" | bc -l          # 7 % 2 = 0
echo -n "${A} ^ ${B} = "
echo "${A} ^ ${B}" | bc -l          # 7 ^ 2 = 49
echo -n "${A} + ${C} = "
echo "${A} + ${C}" | bc -l          # 7 + 3.1 = 10.1
echo -n "${A} - ${C} = "
echo "${A} - ${C}" | bc -l          # 7 - 3.1 = 3.9
echo -n "${A} * ${C} = "
echo "${A} * ${C}" | bc -l          # 7 * 3.1 = 21.7
echo -n "${A} / ${C} = "
echo "${A} / ${C}" | bc -l          # 7 / 3.1 = 2.25806451612903225806
echo -n "${A} / ${C} = "
echo "scale=2; ${A} / ${C}" | bc -l # 7 / 3.1 = 2.25
echo -n "${A} % ${C} = "
echo "${A} % ${C}" | bc -l          # 7 % 3.1 = .000000000000000000014
echo -n "${A} ^ ${C} = "
echo "${A} ^ ${C}" | bc -ll         # 7 ^ 3.1 = Runtime warning (func=(main), adr=9): non-zero scale in exponent
```

## With `awk`

### Use in script
```bash
echo "Doing the same calculations with awk:"
echo -n "${A} + ${B} = "
awk "BEGIN {print ${A} + ${B}}" # 7 + 2 = 9
echo -n "${A} - ${B} = "
awk "BEGIN {print ${A} - ${B}}" # 7 - 2 = 5
echo -n "${A} * ${B} = "
awk "BEGIN {print ${A} * ${B}}" # 7 * 2 = 14
echo -n "${A} / ${B} = "
awk "BEGIN {print ${A} / ${B}}" # 7 / 2 = 3.5
echo -n "${A} % ${B} = "
awk "BEGIN {print ${A} % ${B}}" # 7 % 2 = 1
echo -n "${A} ^ ${B} = "
awk "BEGIN {print ${A} ^ ${B}}" # 7 ^ 2 = 49
echo -n "${A} ** ${B} = "
awk "BEGIN {print ${A} ** ${B}}" # 7 ** 2 = 49
echo -n "${A} + ${C} = "
awk "BEGIN {print ${A} + ${C}}" # 7 + 3.1 = 10.1
echo -n "${A} - ${C} = "
awk "BEGIN {print ${A} - ${C}}" # 7 - 3.1 = 3.9
echo -n "${A} * ${C} = "
awk "BEGIN {print ${A} * ${C}}" # 7 * 3.1 = 21.7
echo -n "${A} / ${C} = "
awk "BEGIN {print ${A} / ${C}}" # 7 / 3.1 = 2.25806
echo -n "${A} % ${C} = "
awk "BEGIN {print ${A} % ${C}}" # 7 % 3.1 = 0.8
echo -n "${A} ^ ${C} = "
awk "BEGIN {print ${A} ** ${C}}" # 7 ^ 3.1 = 416.681
echo -n "${A} ** ${C} = "
awk "BEGIN {print ${A} ^ ${C}}" # 7 ** 3.1 = 416.681
```

## With let
```bash
echo "With let:"
let NUM="${A} + ${B}"
echo "let '${A} + ${B}' = ${NUM}"   # let '7 + 2' = 9
let NUM="${A} - ${B}"
echo "let '${A} - ${B}' = ${NUM}"   # let '7 - 2' = 5
let NUM="${A} * ${B}"
echo "let '${A} * ${B}' = ${NUM}"   # let '7 * 2' = 14
let NUM="${A} / ${B}"
echo "let '${A} / ${B}' = ${NUM}"   # let '7 / 2' = 3
let NUM="${A} % ${B}"
echo "let '${A} % ${B}' = ${NUM}"   # let '7 % 2' = 1
let NUM="${A} ** ${B}"
echo "let '${A} ** ${B}' = ${NUM}"  # let '7 ** 2' = 49
```

## With `expr`
```bash
echo "With expr:"
echo "${A} + ${B} = $(expr ${A} + ${B})"
echo "${A} - ${B} = $(expr ${A} - ${B})"
echo "${A} \* ${B} = $(expr ${A} \* ${B})"
echo "${A} / ${B} = $(expr ${A} / ${B})"
echo "${A} % ${B} = $(expr ${A} % ${B})"
```

# Increment && Assignment Operations
## With bash
```bash
echo -n "${A}++ = "
# post-increment
((A++))
echo "${A}"                         # 7++ = 8
echo -n "${A}-- = "
# post-decrement
((A--))
echo "${A}"                         # 8-- = 7
# pre-increment
echo "++${A} = $((++A))"            # ++7 = 8
# pre-decrement
echo "--${A} = $((--A))"            # --8 = 7
```
## With `bc`
```bash
echo -n "${A}++ = "
echo "var=${A};var++" | bc -l       # 7++ = 7
echo -n "${A}-- = "
echo "var=${A};var--" | bc -l       # 7-- = 7
echo -n "++${A} = "
echo "var=${A};++var" | bc -l       # ++7 = 8
echo -n "--${A} = "
echo "var=${A};--var" | bc -l       # --7 = 6
```

## With `awk`
```bash
# Refactor the below commented
#echo -n "${A}++ = "
#awk "BEGIN { ${A}++; print ${A}}"
#echo -n "${A}-- = "
#awk "BEGIN {print ${A}--}"
```

## With let
```bash
echo "With let:"
echo -n "let ${A}++ = "
let A++
echo ${A}
```