#!/bin/sh

./sexy clean

for i in tests/*.sxy; do
    echo $i
    echo
    ./sexy run $i;
    echo
done

