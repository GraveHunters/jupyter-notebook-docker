#!/usr/bin/env bash

# Parse arguments
# -key=value args
for i in "$@"
do
case $i in
--PIPS=*)
PIPS="${i#*=}"
shift # past argument=value
;;
esac
done

pip3 install --upgrade pip
pip3 install --upgrade setuptools
pip3 install --upgrade wheel
pip3 install jupyter

echo "PIPS passed: $PIPS"

if [ ${PIPS} ]
then
array=(${PIPS//,/ })
for i in "${!array[@]}"
do
SAFE_ELEMENT="$(echo -e "${array[i]}" | tr -d '[:space:]')"
echo "PIPS list contains: $SAFE_ELEMENT"
pip3 install $SAFE_ELEMENT
done
else
echo "No PIPS list was passed"
fi
exit 0
