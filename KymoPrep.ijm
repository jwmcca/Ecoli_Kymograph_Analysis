//This is V2 of KymoPrep. V1 written by Josh. 
//V2 vastly improved upon V1, written by Martin Yepes.

path = "/Users/jmccausland/Xiao Lab Dropbox/Lab Members/McCausland_Josh/Projects/ZipA_Project/JM221_Treadmill/20220419-JM221-Trdml/Kymo/"
//path = "/Users/myepes/Xiao Lab Dropbox/Lab Members/McCausland_Josh/Projects/ZipA_Project/JM221_Treadmill/20220423-JM221-Trdml/Kymo/"
//path = "E:\Xiao Lab Dropbox\Lab Members\McCausland_Josh\Projects\ZipA_Project\JM221_Treadmill\20220423-JM221-Trdml\Kymo\"

CurrentFile = getTitle(); //Get the title of main image window.
TextNumPos1 = lastIndexOf(CurrentFile, ".")-2;
TextNumPos2 = lastIndexOf(CurrentFile, ".");
getLocationAndSize(x, y, width, height);

roi_length = roiManager("count"); 
roiManager("add");

if(roi_length == 0){
	roiManager("select",0);
	cell_num = 1;
	roiManager("rename","Cell1");
}else{
	roiManager("select",roi_length-1);
	last_roi_name = Roi.getName;
	roiManager("select",roi_length);
	if(roi_length <= 19){
		cell_num = parseFloat(substring(last_roi_name,4,5))+1;
	}else{
		cell_num = parseFloat(substring(last_roi_name,4,6))+1; //Dealing with digits greater than 10
	}
	roiManager("rename","Cell" + cell_num);
}
	
run("Duplicate...", "title=Cell duplicate");
imagewidth = getWidth;
imageheight = getHeight;
imagewidth = imagewidth*4;
imageheight = imageheight*4;

run("Size...", "width=imagewidth height=imageheight depth=201 constrain average interpolation=Bicubic");
run("Walking Average", "Number of frames to average=4");
setLocation(x, y+50);
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
getLocationAndSize(x, y, width, height);
close("Cell");
run("Z Project...", "projection=[Max Intensity]");
setLocation(x+width, y);
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");

setTool("line");
waitForUser("Draw line and then hit OK");

roi_length = roiManager("count");
roiManager("add");
selectWindow("walkAv");
roiManager("select",roi_length);
roiManager("rename","Cell" + cell_num + "_Line1");

run("Multi Kymograph", "linewidth=7");
run("Fire");
setLocation(x, y);
run("In [+]");
run("In [+]");
run("In [+]");

if(cell_num <= 9){
	saveAs("tiff",path + "Kymo-" + substring(CurrentFile,TextNumPos1,TextNumPos2) + "-0" + cell_num + ".tif");
}else{
	saveAs("tiff",path + "Kymo-" + substring(CurrentFile,TextNumPos1,TextNumPos2) + "-" + cell_num + ".tif");
}

wait(1000);

selectWindow(CurrentFile);
close("\\Others");

setTool("rectangle");

roiManager("Show All");