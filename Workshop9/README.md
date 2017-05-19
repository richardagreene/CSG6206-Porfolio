# The following are the instructions for generating and classifying the files using FANN and PHP.
 Note that the it assumes that the folloing software is installed:
    https://github.com/bukka/php-fann

# Instuction for running the scripts
1) Generate all the image data files using the following:
   php Workshop9.php /car /cat /unsorted

!! NOTE: The FANN did not work on my copy of OSX 
         so it required me to copy the entire directory "Workshop9" after generation
         of the data files to the Ubuntu/Linux. 

2) Train the FANN using the following:
   php FANN_Train.php /training.data.net
   - This should result in "training complete" being shown
   - The "training.data.net" file can be found in the current directory

3) Classify files using the FANN using the following:
   FANN_Classify.php training.data.net

Not perfect, but it worked...

