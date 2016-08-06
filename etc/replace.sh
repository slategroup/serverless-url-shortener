#!/bin/bash
. scripts/ask.sh

ADDINGFILES=0

AWS_KEY_ID=`aws configure get aws_access_key_id`

if ask "Is $AWS_KEY_ID the correct AWS Access Key Id?"; then
  echo "OK. Using $AWS_KEY_ID for replacement"
else
  read -p "Ok. What profile shoudl I use? \n" PROFILE
  AWS_KEY_ID=`aws configure get aws_access_key_id --profile $PROFILE`
fi


## loop over .gitignore to look for files that need variables replaced
cat .files_with_aws_creds | \
while read CMD; do
    if [ "$CMD" = '## END_REPLACE_VARS_AND_COPY_BLOCK' ]; then
      ADDINGFILES=0
    fi
    if [ "$ADDINGFILES" = "1" ]; then
      # contains characters other than space
      if [[ $CMD = *[!\ ]* ]]; then
        echo "running sed"
        sed -i '' -e "s/{{YOUR AWS ACCOUNT ID}}/$AWS_KEY_ID/g" $CMD
      fi
    fi
    if [ "$CMD" = "## BEGIN_REPLACE_VARS_AND_COPY_BLOCK" ]; then
      ADDINGFILES=1
    fi
done


if ask "Done replacing vars. Ready to switch them back?"; then
  echo "Yay."
fi



## loop over .gitignore to look for files that need variables replaced
cat .files_with_aws_creds | \
while read CMD; do
    if [ "$CMD" = '## END_REPLACE_VARS_AND_COPY_BLOCK' ]; then
      ADDINGFILES=0
    fi
    if [ "$ADDINGFILES" = "1" ]; then
      # contains characters other than space
      if [[ $CMD = *[!\ ]* ]]; then
        echo "running sed"
        sed -i '' -e "s/$AWS_KEY_ID/{{YOUR AWS ACCOUNT ID}}/g" $CMD
      fi
    fi
    if [ "$CMD" = "## BEGIN_REPLACE_VARS_AND_COPY_BLOCK" ]; then
      ADDINGFILES=1
    fi
done

# echo "OK. Puttin values back.\n"
