#!/bin/bash

current_revision=$(git rev-parse HEAD)
echo "Current git revision: $current_revision"

git ls-files | while read -r file
do
  sed -i "s/##REVISION##/$current_revision/g" "$file"
  echo "Processed: $file"
done

echo "Replacement complete."
