<?php

if($argv[1] == "") {
    printf("ERROR: Syntax incorrect; \n");
    printf("     php FANN_Train.php <training data file>\n");
    printf("  example: ");
    printf("     php FANN_Train.php /training.data.net \n\n");
    return;
}

set_time_limit ( 300 ); // do not run longer than 5 minutes (adjust as needed)
$num_input = 22500;
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
    $filename = dirname(__FILE__) . $argv[1];
    if (fann_train_on_file($cats_ann, $filename, $max_epochs, $epochs_between_reports, $desired_error))
        fann_save($cats_ann, dirname(__FILE__) . $argv[1] . ".net");

    fann_destroy($cats_ann);
}
printf('\ntraining complete\n');

?>