#!/bin/bash
#generate list of ips
#usage $0 begin end rangewithout last .
#by n0b1dy

for i in $(seq $1 1 $2 );
do
echo $3.$i
done


