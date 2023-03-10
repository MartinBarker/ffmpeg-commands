#!/bin/bash

numbers="297.825,547.017,770.274,1027.31,1339.35,1589.02,1823.66,2027.97,2267.45"

# Convert the comma-separated string into an array
arr=($(echo $numbers | tr ',' '\n'))

# Initialize a new array to store the results
new_arr=()

# Iterate through each element and add 1
for i in "${arr[@]}"; do
  result=$(echo "$i + 1" | bc -l)
  new_arr+=("$result")
done

# Convert the array back into a comma-separated string
new_numbers=$(IFS=,; echo "${new_arr[*]}")

# Print the result
echo $new_numbers