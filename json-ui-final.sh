#!/bin/bash

create_json_array_strings() {
  echo "[\"$(echo "$1" | sed 's/,/","/g' | sed 's/[^,]*\"[^\"]*\"[^,]*/&/g')\"]"
}

create_json_array_integers() {
  echo "[$(echo "$1" | tr ',' ' ')]"
}

tenantStageLevel_array=($(echo "$RD_OPTION_TENANTSTAGELEVEL" | tr ',' ' '))

myJson=$(cat <<EOF
{
  "organization_description": "Company Name of the customer",
  "organization": "$RD_OPTION_ORGANIZATION",
  "country_description": "Country of the customer",
  "country": "$RD_OPTION_COUNTRY",
  "contractTier_description": "contractTier is the actual tier which is mentioned in the contract for ex: BASIC, ADVANCED and ENTERPRISE",
  "contractTier": "$RD_OPTION_CONTRACTTIER",
  "firstName": "$RD_OPTION_FIRSTNAME",
  "lastName": "$RD_OPTION_LASTNAME",
  "email": "$RD_OPTION_EMAIL",
  "username_description": "A username is given to the customer to log in to his account. usually it will be the same as the email id",
  "username": "$RD_OPTION_USERNAME",
  "region_description": "Region in which the tenants have to be created for ex: us-west-2, eu-central-1, aw-au, az-us, az-eu, az-au",
  "region": "$RD_OPTION_REGION",
  "contractNo_description": "The latest validated contract number",
  "contractNo": "$RD_OPTION_CONTRACTNO",
  "endDate_description": "It is the expiry date of the products, it needs to be passed with the date and time",
  "endDate": "$RD_OPTION_ENDDATE",
  "environments_description": "It should be passed as an array, only these three values are supported (Development, Test, Production)",
  "environments": $(create_json_array_strings "$RD_OPTION_ENVIRONMENTS"),
  "environmentNames_description": "Environment names need to be passed as an array",
  "environmentNames": $(create_json_array_strings "$RD_OPTION_ENVIRONMENTNAMES"),
  "environmentTier_description": "For dev and test tenants, it should be PAID_BASIC and for prod it should be based on the contract",
  "environmentTier": ["$RD_OPTION_ENVIRONMENTTIER"],
  "tenantStageLevel_description": "It is for API gateway upgrade priority, pass the numbers in an array, starting from dev it is 1",
  "tenantStageLevel": $(create_json_array_integers "${tenantStageLevel_array[@]}"),
  "products_description": "Should be passed as an array, based on the customer request for ex: webmethodsioint etc.",
  "products": $(create_json_array_strings "$RD_OPTION_PRODUCTS"),
  "capabilities_description": "Should be passed as an array, based on the customer request for ex: metering etc.",
  "capabilities": $(create_json_array_strings "$RD_OPTION_CAPABILITIES"),
  "phone": "$RD_OPTION_PHONE",
  "skipProductApiInvocation_description": "Boolean value, to create tenants on the product side it should be false else true to skip it",
  "skipProductApiInvocation": $RD_OPTION_SKIPPRODUCTAPIINVOCATION,
  "internalUser_description": "Name of the user who is executing this script",
  "internalUser": "$RD_OPTION_INTERNALUSER",
  "description_description": "Prod tenant name with prefix ac and suffix _contractNo",
  "description": "$RD_OPTION_DESCRIPTION",
  "displayName_description": "Prod tenant name with prefix ac and suffix _contractNo",
  "displayName": "$RD_OPTION_DISPLAYNAME",
  "itracNo_companyName_description": "Itrac no with company name for creating the log file, for ex: CSOWAS-4555_ABC",
  "itracNo_companyName": "$RD_OPTION_ITRACNO_COMPANYNAME",
  "tenantType_description": "If it is a complete new provisioning, it should be New, if tenants are already present it should be existing",
  "tenantType": "$RD_OPTION_TENANTTYPE"
}
EOF
)


REPO_URL="https://github.com/abhi0703/tenant_automation.git"
BRANCH_NAME="main"
file_path="/tmp/json_file.json"

# Copy the output file to the repository
echo "$myJson" > "$file_path"
cat /tmp/json_file.json

# Configure git account
git config --global user.email "agowda077@gmail.com"
git config --global user.name "abhi0703"

# Clone the repository if not already cloned
git clone $REPO_URL 

# Move to the repository directory
cd .\tenant_automation\JSON_Files\

# Copy the generated JSON file to the repository
cp $file_path .

# Add, commit, and push the changes
git add .
git commit -m "Add output file from Rundeck job"
git push -u origin $BRANCH_NAME