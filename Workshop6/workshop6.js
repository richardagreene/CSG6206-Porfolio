// Note: required Sharp Library
//     sudo npm install sharp
var sharp = require('sharp');
// check that command was correctly entered
if(!process.argv[2] || !process.argv[3])
{
  console.log("Error: parameters where not passed correctly.");
  console.log(" syntax: node workshop6 <input filename> <output filename>");
  return;
}

console.log("Setting image threshold of " +process.argv[2] + ", output " +process.argv[3])
sharp(process.argv[2])
  .threshold(200)
  .png()
  .toFile(process.argv[3], function(err, info) {
      if(err)
        console.log(err);
  });
