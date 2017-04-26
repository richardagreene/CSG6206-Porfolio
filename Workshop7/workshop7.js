// Note: required Sharp Library
//     sudo npm install sharp
var sharp = require('sharp');
var fs = require('fs');

// check that command was correctly entered
if(!process.argv[2])
{
  console.log("Error: parameters where not passed correctly.");
  console.log(" syntax: node workshop7 <input filename>");
  return;
}
// check file exists
if(!fs.existsSync(process.argv[2])) {
  console.log("Error: file '"+process.argv[2]+"' not found.");
  return;
}
//  ----------------
//  Process the file
//  ----------------
var buffer = sharp(process.argv[2])
  .raw()
  .toBuffer(function(err, data, info)
  {
    // verify it's an image file
    if(err) { console.log("Error:", err.message ); return }
    // verify it's monochrome i.e. all bits are 255 (white) or 0 (black)
    for (var l = 0; l < data.length; l++) {
        if(data[l] != 255 && data[l] !=0)
        {
            console.log("Error file is not monochrome");
            return;
        }
    }
    // process the graphic file
    for (var y = 0; y < info.height; y++) {
        var line="";
        for (var x = 0; x < info.width; x++) {
            var idx = (info.width * y + x) * 3 ;
            line=line+(data[idx] + data[idx+1] + data[idx+2] > 0 ? "0" : "1") 
        }
        console.log(line);
    }
  });