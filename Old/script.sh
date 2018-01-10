

#!/bin/bash

echo > data.txt

for L in $(seq 10 11);
do
	for k in $(seq 1 $L);
	do
		for Z in $(seq 2 5);
		do
			./a.out $L $k $Z 2>&1 >>data.txt
		done
		printf '\n' >> data.txt
	done
	printf '\n' >> data.txt
done

