
#!/bin/bash

for k in $(seq 1 21);
do
	./sample server 4KB $k &
done

