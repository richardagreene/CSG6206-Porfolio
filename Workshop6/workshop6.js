// Note: required Sharp Library
//     sudo npm install sharp
sharp = require('sharp');
console.log("Setting image threshold of " +process.argv[2] + ", output " +process.argv[3])
sharp(process.argv[2])
  .threshold(200)
  .png()
  .toFile(process.argv[3], function(err, info) {
      if(err)
        console.log(err);
  });
