
#!/bin/bash

for k in 1 5 10 20; 
do
	./sample server 1KB $k &
done


