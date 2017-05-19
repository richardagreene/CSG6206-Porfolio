#!/bin/bash
clear
mkdir processFiles

processImage ()
{

# -- processing files --
    for image in $1
    do
        echo "Processing $image file..."
        filename="process_$(basename "$image")"
        node ../Workshop6/Workshop6.js $image ../Workshop9/$filename
        node ../Workshop7/workshop7.js $filename | ../Workshop5/workshop5.sh >> "$2/$filename.txt"
        #clean up the graphic file
        rm $filename
    done
}

createTrainingFileData ()
{
    # create training file
    count=$(find $1 -maxdepth 1 -type f|wc -l)
    length=22500;  # The size of the dataset  
    # prints out how many were in the directory
    printf "${count//[[:space:]]/} $length 1\n" >> $2 #count files, 1 input one output
    for image in $1
    do    
         tr -d "\n\r" < $image > "$image-spaced" 
         sed -e 's/\(.\)/\1 /g' < "$image-spaced" >> $2
         rm $image-spaced
         result="0";
         if [[ $image == *"car"* ]]; then
            result="1";
        fi
        printf "$result\n" >> $2;
    done
}

createClassificationFileData ()
{
    for image in $1
    do
         tr -d "\n\r" < $image >> "$image-classify" 
         rm $image
    done
}


#-- trim taken from 
#  http://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
trim () {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    echo -n "$var"
}

 # -- remove any existing processing files --
rm ./processFiles/process*
processImage "./cars/*" "./processFiles"
processImage "./cats/*" "./processFiles"
rm ./unsorted/process*
processImage "./unsorted/*" "./unsorted"
rm ./processFiles/training.txt
createTrainingFileData "processFiles/process_*.txt" "processFiles/training.txt" 
createClassificationFileData "./unsorted/process_*.txt"