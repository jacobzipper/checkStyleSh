checkstyle=~/checkstyle.jar

if (($# < 1)); then
    echo -e "\033[1;31mERROR: \033[0;31mNo argument found\033[0;0m"
    exit
fi
for var in "$@"
do
	file=$var
	echo -e "\033[1;31mCompiling\033[0;0m"
	filename=${file##*/}
	filenameNoExtension=${filename%.*}
	dirpath=${file%/*}
	cd $dirpath
	if javac $filename; then
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
	java $filenameNoExtension $@
done
