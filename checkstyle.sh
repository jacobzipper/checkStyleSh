checkstyle=/usr/local/bin/checkstyle.jar
count=0
if (($# < 1)); then
	echo -e "\033[1;31mERROR: \033[0;31mNo argument found\033[0;0m"
	exit
fi
while getopts ":a" opt; do
	case $opt in
		a)
			shift
			count=$((count + 1))
			for var in "$@"
			do
				file=$var
				echo -e "\033[1;31mCompiling\033[0;0m"
				filename=${file##*/}
				filenameNoExtension=${filename%.*}
				dirpath=${file%/*}
				cd $dirpath
				if javac -Xlint $filename; then
					printf "Compiled Successfully\n\n"
				else
					echo "Failed to compile"
					continue
				fi
				echo -e "\033[1;31mRunning Checkstyle\033[0;0m"
				java -jar $checkstyle $filename
				printf "\n"
				echo -e "\033[1;31mRunning program\033[0;0m"
				shift #Get rid of the first parameter
				java $filenameNoExtension
			done
			;;
	esac
done
if [ $count -eq 0 ]
then
	file=$1
	echo -e "\033[1;31mCompiling\033[0;0m"
	filename=${file##*/}
	filenameNoExtension=${filename%.*}
	dirpath=${file%/*}
	if [[ $dirpath == $filename ]]; then
    	cd $dirpath
	fi
	if javac -Xlint $filename; then
	    printf "Compiled Successfully\n\n"
	else
	    echo "Failed to compile"
	    exit
	fi
	echo -e "\033[1;31mRunning Checkstyle\033[0;0m"
	java -jar $checkstyle $filename
	printf "\n"
	echo -e "\033[1;31mRunning program\033[0;0m"
	shift #Get rid of the first parameter
	java $filenameNoExtension $@
fi