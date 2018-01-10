

#!/bin/bash
g++ -std=c++11 -O3 -o oram test_path_oram.cpp

N=20
Z=5
#epsilon=(0 1 2 3 4 5 6 7 8 9 10 12 14 16 18 20)
#varI=(9 10 11 12 13 14)
epsilon=(0)
varI=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19)


for i in "${varI[@]}";
do
	for eps in "${epsilon[@]}";
	do
		./oram $N $Z $i $eps &
	done
	# printf '\n' >> res/path_"$N"_"$Z"
done





# for (( i = 0; i < 1; i++ )); do
# 	for eps in "${epsilon[@]}";
# 	do
# 		./oram 12 4 6 $eps &
# 	done
# 	printf '\n' >> res/path_12_4_6
# done



# #!/bin/bash
# varK=(1 2 3 4 5 6 7 8 9 10 11 12)

# for (( i = 0; i < 1; i++ )); do
# 	for k in "${varK[@]}";
# 	do
# 		./oram 12 4 $k 1 &
# 	done
# done


