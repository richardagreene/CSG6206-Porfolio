<?php 	
// process image 
// code modifed from : 
//    http://php.net/manual/en/function.imagesetpixel.php */
//

$input = stream_get_line(STDIN, 1024);
$input = trim($input, "\n"); // remove last carrage return if passed

// check arguments
if (count($input) == 0 || count($argv) < 2)
{
    echo "Error; No data passed or argument provided\n";
    echo "   Syntax; \"printf <binary data> | php binary_to_image.php <output filename>\" \n";
    return;
}

// check binary 
$regex = "/[^01\\n]+/";
if (preg_match($regex, $input)) {
    echo "Error; non-binary data found in stream.\n";
    return;
}

// check rows 
$arr = explode("\n", $input);
foreach($arr as $curLine => $lineElement) {
    if(strlen($lineElement) != strlen($arr[1])) {
        echo "Error; not all row lengths are equal.\n";
        return;
    }
}

// process image stream

$image = imagecreate(strlen($arr[1]), count($arr));
$white = imagecolorallocate($image, 0xFF, 0xFF, 0xFF); 
$black = imagecolorallocate($image, 0x00, 0x00, 0x00);

foreach($arr as $curLine => $lineElement) {
    $lineSplit = preg_split("//", $lineElement);
    foreach($lineSplit as $pixelkey => $pixelElement) {
        if ($pixelElement == "1") 
            imagesetpixel($image, $pixelkey-1, $curLine, $black);
    }
}
imagepng($image, $argv[1]);
imagedestroy($image);

?>
