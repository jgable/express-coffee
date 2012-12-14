require("coffee-script");

var uploader = require("./src/s3AssetUpload");

uploader.upload(console.log, function(err, uploaded) {
	if(err) {
		return console.log("Error uploading: " + err.message);
		process.exit(1);
	}

	console.log("Completed");
	process.exit(0);
});