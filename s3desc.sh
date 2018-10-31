#!/bin/bash

aws s3 ls > buckets.txt

while read b; do
   bucketname=$(echo "$b" | cut -f3 -d' ')    
   totalobjects=$(aws s3 ls --recursive --summarize $bucketname | head -n -1 | tail -1 | cut -f2 -d:)
   totalsize=$(aws s3 ls --recursive --summarize $bucketname | tail -1 | cut -f2 -d:)
   echo $totalsize $totalobjects >> tmp.txt
done < buckets.txt

paste buckets.txt tmp.txt | awk '{print $1,$2,$3,$4,$5}'

rm tmp.txt
rm buckets.txt
