#!/bin/bash

# Input file containing URLs
input_file=$1

# Output file for modified URLs
output_file="fuzz_modified.txt"

# Process each line in the input file
while IFS= read -r line; do
  # Replace the query parameter values with FUZZ
  modified_line=$(echo "$line" | sed -E 's/(\?[a-zA-Z0-9_]+=)[^&]+/\1FUZZ/g')
  echo "$modified_line" >> "$output_file"
done < "$input_file"

echo "URLs have been modified and saved to $output_file"

