
#!/bin/bash 

for k in 1 5 10 20;
do
	for i in $(seq 1 10);
	do
		trickle -s -u 10 -d 10 ./sample client garbage $k
	done
	rm garbage
	printf '\n' >> time_taken.txt

	for i in $(seq 1 10);
	do
		trickle -s -u 30 -d 30 ./sample client garbage $k
	done
	rm garbage
	printf '\n' >> time_taken.txt

	for i in $(seq 1 10);
	do
		trickle -s -u 100 -d 100 ./sample client garbage $k
	done
	rm garbage
	printf '\n' >> time_taken.txt

	for i in $(seq 1 10);
	do
		trickle -s -u 300 -d 300 ./sample client garbage $k
	done
	rm garbage
	printf '\n' >> time_taken.txt

	for i in $(seq 1 10);
	do
		trickle -s -u 1000 -d 1000 ./sample client garbage $k
	done
	rm garbage
	printf '\n' >> time_taken.txt
	printf '\n' >> time_taken.txt
done
