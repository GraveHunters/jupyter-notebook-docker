#!/usr/bin/env bash

# Parse arguments
# -key=value args
for i in "$@"
do
case $i in
--APKS=*)
APKS="${i#*=}"
shift # past argument=value
;;
esac
done

echo "APKS passed: $APKS"

if [ ${APKS} ]
then
array=(${APKS//,/ })
for i in "${!array[@]}"
do
SAFE_ELEMENT="$(echo -e "${array[i]}" | tr -d '[:space:]')"
echo "APKS list contains: $SAFE_ELEMENT"
apk update && apk add --no-cache $SAFE_ELEMENT
done
else
echo "No APKS list was passed"
fi
exit 0
