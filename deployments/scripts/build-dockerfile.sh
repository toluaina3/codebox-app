#!/bin/bash

# Assign the filename
filename="../../Dockerfile"
build_branch=$(git branch --show-current)
echo $build_branch
# shellcheck disable=SC2154
if [[ $build_branch == "dev" ]] ;
  then
    # shellcheck disable=SC2143
    if [[ $(grep "dev" $filename) ]]
      then
        true
        echo "Build config is dev, no changes made!!!!"
    elif [[ $(grep "staging" $filename) ]]
      then
      sed -i "s/MIX_ENV=staging/MIX_ENV=dev/" $filename
      echo "Build config is staging, changed to dev!!!!"

    elif [[ $(grep "prod" $filename) ]]
      then
      sed -i "s/MIX_ENV=prod/MIX_ENV=dev/" $filename
      echo "Build config is prod, changed to dev!!!!"
    else
      echo "Keyword undefined in dev branch!!!"
    fi
elif [[ $build_branch == "staging" ]] ;
  then
    # shellcheck disable=SC2143
    if [[ $(grep "dev" $filename) ]]
      then
        sed -i "s/MIX_ENV=dev/MIX_ENV=staging/" $filename
        echo "Build config is dev, changed to staging!!!!"

        elif [[ $(grep "prod" $filename) ]]
      then
      sed -i "s/MIX_ENV=prod/MIX_ENV=staging/" $filename
      echo "Build config is prod, changed to staging!!!!"
    else
      echo "Keyword undefined in staging branch!!!"
    fi
else
  sed -i "s/MIX_ENV=dev/MIX_ENV=prod/" $filename
  sed -i "s/MIX_ENV=staging/MIX_ENV=prod/" $filename
fi