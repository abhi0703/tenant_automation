#!/bin/bash


Input_data=$(cat <<EOF
{
  "Name_description": "Enter your name",
  "Name": "$RD_OPTION_NAME",
  "DateOfBirth_description": "Enter your date of birth",
  "DateOfBirth": "$RD_OPTION_DATEOFBIRTH"
}
EOF
)


# Copy the output file to the repository
echo "$Input_data" > "json_file.json"
cat json_file.json



readlink -f "json_file.json"

REPO_URL="https://github.com/abhi0703/terraform_test.git"
BRANCH_NAME="main"


git clone $REPO_URL 


cp /C/Users/abgo/json_files/json_file.json . 


# Add, commit, and push the changes
git add .
git commit -m "Add output file from Rundeck job"
git push -u origin $BRANCH_NAME

