<?php

function evalImage($filename, $binaryArray, $positiveName, $negativeName, $ann) {
    printf("Image Name: $filename" . PHP_EOL . '\n');
    $calc_out = fann_run($ann, $binaryArray);
    
    printf('Raw: ' .  $calc_out[0] . '\n' . PHP_EOL);
    printf('Rounded: ' . round($calc_out[0]) . '\n' . PHP_EOL);
    printf('Outcome: ');

    if( round($calc_out[0])) {
        echo $positiveName;
    }else{
        printf($negativeName);
    }

    printf('\n\n' . PHP_EOL);    
}

//  Classify the file 
function classify($trainedData, $file, $data_array)
{
    if (!is_file($trainedData))
        die('The training data file has not been created!\n' . PHP_EOL);
    $trained_ann = fann_create_from_file($trainedData);
    if ($trained_ann) {
        
        evalImage($file, $data_array, "Cat", "Car", $trained_ann);
        
        fann_destroy($trained_ann);
    } else {
        die("Training data is in invalid format....\n" . PHP_EOL);
    }
}


if($argv[1] == "" ) {
    printf("ERROR: Syntax incorrect; \n");
    printf("     php FANN_Classify.php <trained data>\n");
    printf("  example: ");
    printf("     php FANN_Classify.php training.data.net\n\n");
    return;
}

// Read all files and attempt to classify them
foreach (glob("*.dat") as $file) {
   $contents = file_get_contents($file);
   $arr=str_split($contents);
   // attempt to classify this file if it's a data file
   classify($argv[1], $file, $arr);
} 

?>