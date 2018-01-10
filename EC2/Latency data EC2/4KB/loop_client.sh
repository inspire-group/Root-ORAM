
#!/bin/bash

for k in $(seq 1 21);
do
	for i in $(seq 1 10);			# Averaging over 100 trials.
	do
		./sample client garbage $k
	done
	rm garbage
	printf '\n' >> time_taken.txt
done

