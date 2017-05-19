<?php 	

//***************************************************
//   FANN Training Process
//***************************************************

function FANNtraining($filename, $length) { 
  $trainedFANN = $filename . ".net";
  set_time_limit ( 300 ); // do not run longer than 5 minutes (adjust as needed)
  $num_input = $length;
  $num_output = 1;
  $num_layers = 3;
  $num_neurons_hidden = 107;
  $desired_error = 0.00001;
  $max_epochs = 5000000;
  $epochs_between_reports = 10;
  $cats_ann = fann_create_standard($num_layers, $num_input, $num_neurons_hidden, $num_output);
  if ($cats_ann) {
      echo 'Training ANN... '; 
      fann_set_activation_function_hidden($cats_ann, FANN_SIGMOID_SYMMETRIC);
      fann_set_activation_function_output($cats_ann, FANN_SIGMOID_SYMMETRIC);
      $filename = dirname(__FILE__) . $filename;
      if (fann_train_on_file($cats_ann, $filename, $max_epochs, $epochs_between_reports, $desired_error))
          fann_save($cats_ann, dirname(__FILE__) . $trainedFANN);

      fann_destroy($cats_ann);
  }
  echo '\nFANN training complete\n';
  return $trainedFANN;
}

//***************************************************
//   FANN Evaluation of images
//***************************************************

function evalImage($filename, $binaryArray, $positiveName, $negativeName, $ann) {
    printf("Image Name: $filename" . PHP_EOL . '\n');
    $calc_out = fann_run($ann, $binaryArray);
    
    printf('Raw: ' .  $calc_out[0] . '\n' . PHP_EOL);
    echo 'Rounded: ' . round($calc_out[0]) . '\n' . PHP_EOL;
    echo 'Outcome: ';

    if( round($calc_out[0])) {
        echo $positiveName;
    }else{
        printf($negativeName);
    }
    printf('\n\n' . PHP_EOL);    
}

//***************************************************
//   FANN Classification of images
//***************************************************

function classify($trainingFile, $file, $data_array)
{
    $train_file = (dirname(__FILE__) . '/'. $trainingFile);
    if (!is_file($train_file))
        die('The training data file has not been created!\n' . PHP_EOL);
    $trained_ann = fann_create_from_file($train_file);
    if ($trained_ann) {
        
        evalImage($file, $data_array, "Cat", "Car", $trained_ann);
        
        fann_destroy($trained_ann);
    } else {
        die("Training data is in invalid format....\n" . PHP_EOL);
    }
}

// run a sub process sending command and optionally standard input
// returns standard output
function runprocs($command, $input = "") { 

  // build up channels
  $descriptorspec = array( 
    0 => array("pipe", "r"),  // stdin 
    1 => array("pipe", "w"),  // stdout 
    2 => array("pipe", "w")   // stderr ?? instead of a file 
  ); 
  $process = proc_open($command, $descriptorspec, $pipes); 
  if (is_resource($process)) { 
    fwrite($pipes[0], $input); 
    fclose($pipes[0]); 

    // get stdout
    while($s= fgets($pipes[1], 1024)) { 
          // read from the pipe 
          $output .= $s; 
    } 
    fclose($pipes[1]); 
    // get stderr
    while($s= fgets($pipes[2], 1024)) { 
      $output.= "\nError: $s\n\n"; 
    } 
    fclose($pipes[2]); 
  } 
  return $output; 
} 

//***************************************************
//   Create the files needed for processing
//***************************************************

function processFiles($subdir, $value)
{
    $root = dirname(__FILE__) . $subdir;
    $files = array_diff(scandir($root), array('..', '.'));
    foreach ($files as $file)
    {
        printf("Processing $file file...");
        $outputfilename="process_$file";
        runprocs("node ../Workshop6/Workshop6.js $root/$file $root/$outputfilename");
        $imageData = runprocs("node ../Workshop7/workshop7.js $root/$outputfilename");
        $result = str_replace(' ', '', runprocs("../Workshop5/workshop5.sh", $imageData));
        $imageArr[] = array($file, $result, $value);
        #clean up the graphic file
        unlink("$root/$outputfilename");
    } 
    return $imageArr;
}

//***************************************************
//  Format of the training file is determined by FANN
//  See: https://github.com/bukka/php-fann/blob/master/examples/ocr/ocr.data
//***************************************************
function generateTrainingFile($imageArr)
{
  $inputItems=0;
  $imputLength=0;
  $trainingFile = 'training.data';
  // calculate the first inputs
  foreach ($imageArr as $dir) {
    $inputItems = $inputItems + count($dir);
    $imputLength = strlen($dir[0][1]);
  }
  file_put_contents($trainingFile, $inputItems . " ". $imputLength . " 1\n" ); 
  // write the training array and results
  foreach ($imageArr as $dir) {
    foreach ($dir as $image) {
      file_put_contents($trainingFile, implode(' ', str_split(str_replace("\r", '', str_replace("\n", '', $image[1])))) . "\n", FILE_APPEND); 
      file_put_contents($trainingFile, $image[2] . "\n", FILE_APPEND); 
    }
  }
  return $trainingFile;
}

//  ---- Main programme loop -----
if($argv[1] == "" || $argv[2] == "" || $argv[3] == "" ) {
    printf("ERROR: Syntax incorrect; \n");
    printf("     php Workshop9.php <positive dir> <negative dir> <sort dir>\n");
    printf("  example: ");
    printf("     php Workshop9.php /cats /cars /unsorted\n");
}

// load an array with the values
$imageStack[] = processFiles($argv[1], 0);
$imageStack[] = processFiles($argv[2], 1);
$trainingFile = generateTrainingFile($imageStack);
$classifyImages = processFiles($argv[3], 0);

// Generate data files to copy to Linux machine
foreach ($classifyImages as $image) {
    file_put_contents($image[0] . ".dat", str_split(str_replace("\r", '', str_replace("\n", '', $image[1]))));
}

// ***
//  Note:  The following lines did not work on Mac as the FANN was not compatable with OSx..
//         Copy the training file 'training.data' and image files '*.dat' to a Linux machine and type:
//           php FANN_Train.php training.data.net
//           php FAN_Classify.php \unsorted
//
// ***
//  If it did work the could would be below :
//
// $trainedFANN = FANNtrainig($trainingFile, strlen($imageStack[0][0][1]));
// Read all files and attempt to classify them
// $classifyImages = processFiles($argv[3], 0);
// foreach ($classifyImages as $image) {
//        classify($trainingFile, $image[0], str_split($image[1]));
//    } 

?>
