#!/bin/bash
# This script is a simple approach on generating random passwords automatically.

# We generate a random checksum:
#   First we retieve the current date (seconds, nanoseconds).
#   In the current date we append two random rumbers.
#   The output is hashed, and we keep the first 48 characters of the checksum.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)

# We then generate a random special character:
#  We echo the special characters
#  We separate each character in different lines (fold -w1)
#  We randomly output these lines (shuf)
#  We pick the first line of this output (head -c1)
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
echo ${PASSWORD}${SPECIAL_CHARACTER}

