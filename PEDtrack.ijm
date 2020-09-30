// PEDtrack.ijm
// 
// This ImageJ macro extracts objects from stacks of images. Further processing of the results happens in the PEDtracker R package.
//
// Author: Tilman Triphan, tilman.triphan@uni-leipzig.de
// License: GNU General Public License v3.0
// Copyright (C) 2020  Tilman Triphan
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.

//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

BATCHSIZE = 1080;

infiletype = ".png";
outfiletype = ".png";
code = "Larva"
roipath = "D:\rois\\"; // Path to Roi file
outpath = "";
blur_sigma = 2.0;

// Settings for larval sizes
circArray = newArray (0.6, 0.35, 0.25);	
min_size_threshold = newArray (50, 250, 1000);
max_size_threshold = newArray (300, 1500, 3200);
bg_threshold = newArray (10, 20, 30);
method_threshold = newArray ("Default", "Default", "Intermodes")

current_folder_nr = -1;
foldernum = 1;

// Estimate larval stage for batch
function setSize (folder_nr) {
	if ((folder_nr >= 1) & (folder_nr <= 10)) {
		return 0;
	}
	if ((folder_nr >= 11) & (folder_nr <= 20)) {
		return 1;
	}
	if (folder_nr >= 21) {
		return 2;
	}
}

function setSize2 (folder_nr){	
	if (((folder_nr >= 3) & (folder_nr <= 3)) | (folder_nr >= 6) & (folder_nr <= 6)){
		return 1;
	}
	if ((folder_nr >= 16) & (folder_nr < 20)){
		return 2;
	}
	return -1;
}

// Extract images from list of all files
function createImageList(inputDir) {
	fileList = getFileList(inputDir);
	start = -1;
	end = -1;
	for (i = 0; i < fileList.length; i++) {
		// Find the first image
		if ((start == -1) & (endsWith(fileList[i],infiletype))) {
			start = i;
		}
		// Find the last image and return list
		if ((start != -1) & (!endsWith(fileList[i],infiletype))) {
			end = i;
			return Array.slice(fileList,start,end);
		}
	}
	// If there are no images, return -1;
	if (start == -1)
		return -1;
	// Return list even if no other files have been found
	return Array.slice(fileList,start,fileList.length);
}

// Split the images into batches of BATCHSIZE
function createBatches (inputDir) {
	print("Processing folder: " + inputDir);
	list = createImageList(inputDir);
	if (list == -1) {
		print("No images in folder, skipping to next step");
		return;
	}
	// Calculate the number of batches
	if ((list.length/BATCHSIZE) == floor(list.length/BATCHSIZE)) {
		batchcount = list.length/BATCHSIZE;
	} else {
		batchcount = floor(list.length/BATCHSIZE)+1;
	}
	print("Creating " + batchcount + " batches");
	//create batches and directories
	for (i = 0; i < batchcount; i++) {
		subfolderpath = inputDir+IJ.pad(d2s(i,0),3)+"\\";
		if (!File.exists(subfolderpath)) {
			File.makeDirectory(subfolderpath);
		}
		//loop through batch
		for (j = i*BATCHSIZE; j < (i+1)*BATCHSIZE; j++) {
			// ran out of files to distribute
			if (j >= list.length) {
				print("subfolder done!");
				return;
			}
			infile = inputDir + list[j];			
			outfile = replace(subfolderpath + list[j], infiletype, outfiletype);
			if (endsWith(File.getName(inputDir + list[i]), infiletype)) {
				if (!File.exists(outfile)) {
					// Move file, will return (and print) 1 if successful
					File.rename(infile, outfile);
				}				
			}
		}
		print("subfolder "+ i +" done!");
	}
}

// Create a video for a single chamber
function processRoi(fn) {
	run("Duplicate...", "duplicate");
	run("AVI... ", "compression=None frame=3 save="+fn);
	close();
}

// Process a single folders to extract rois for chambers
function processFolderRoi(input) {
	print("Processing folder: " + input);
	run("Image Sequence...", "open=" + input + " file=" + outfiletype + " sort");
	temp = split(inputDir,"\\");
	fn_roi = roipath + temp[temp.length - 1]+".zip";
	roiManager("open", fn_roi);
	for (i = 0; i < roiManager("count"); i++) {
		roiManager("select", i);
		fn = input + code + d2s(i+1,0) + ".avi";
		processRoi(fn);
	}
	close();
	roiManager("reset");
	print("Folder " + input + " done!");
}

// Process all folders to extract rois for chambers
function processFoldersForRois(path) {
	print("Processing experiment folder: " + path);
	folders = getFileList(path);
	for (i = 0; i < folders.length; i++) {
		if (File.isDirectory(path + folders[i])) {
			current_folder_nr = i;
			print("Current folder: " + current_folder_nr);
			processFolderRoi(path + folders[i]);
		}
	}
}

function processFileAnalysisForSize(fn, folder_nr, step) {
	if (step == 1) {
		size = setSize(folder_nr);
	} else {
		size = setSize2(folder_nr);
	}
	if (size == -1)
		return;
	print("Processing in folder #" + IJ.pad(d2s(folder_nr,0),2) + ": " + fn);
	print ("larvaSize: " + size + ", using these settings: " + circArray[size] + " " + min_size_threshold[size] + " " + max_size_threshold[size]);	
	run("AVI...", "open=" + fn);
	id = getImageID();
	//Background Adjustment (Problem:Larva in the dark)
	fn_temp = replace(fn,".avi","_"+IJ.pad(d2s(folder_nr,0),2)+"_"+d2s(size,0)+"_light.bmp");
	fn_light = outpath+File.getName(fn_temp);
	if (!File.exists(fn_light)) {
		run("Z Project...", "projection=Median");
		run("Gaussian Blur...", "sigma="+16);
		print(fn_light + " saved");
		saveAs("BMP", fn_light);
	} else {
		open(fn_light);
		print(fn_light + " loaded");
	}
	run("Invert");
	name = File.getName(fn);
	imageCalculator("Average stack", name, File.getName(fn_light));
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT", "stack");
	selectWindow(File.getName(fn_light));
	close();
	selectImage(id);
	run("Gaussian Blur...", "sigma="+blur_sigma+" stack");
	run("Z Project...", "projection=Median");
	name = File.getName(fn);
	imageCalculator("Difference stack", name,"MED_"+name);
	if (method_threshold[size] == "Default") {
		print ("using Default Threshold "+ bg_threshold[size]);
		setThreshold(bg_threshold[size], 255);
	}
	run("Make Binary", "method="+method_threshold[size]+" background=Dark black");
	run("Dilate", "stack");
	run("Close-", "stack");
	min_th = min_size_threshold[size];
	max_th = max_size_threshold[size];
	run("Analyze Particles...", "size="+min_th+"-"+max_th
		+" circularity="+circArray[size]+"-1 display exclude clear add stack");
	fn_roi = replace(fn,".avi","_"+d2s(size,0)+"_roiset.zip");
	print("Current folder (Analysis): " + folder_nr);
	fn_results = replace(fn,".avi","_"+IJ.pad(d2s(folder_nr,0),2)+"_"+d2s(size,0)+"_results.csv");
	saveAs("Results", outpath+File.getName(fn_results));
	roiManager("Save", fn_roi);
	close();
	close();	
}

// Process a single folder to extract larva position
function processFolderAnalysis(input, folder_nr) {
	print("Processing folder: " + input);
	print("This is folder nr: " + folder_nr);
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if (endsWith(list[i], ".avi")) {
			print("Processing " + list[i]);
			// Process for two formats
			processFileAnalysisForSize(input + list[i], folder_nr, 1);
			processFileAnalysisForSize(input + list[i], folder_nr, 2);
		}
	}
	print("Folder " + input + " done!");
}

// Process all folders to extract larva position
function processVideoAnalysis(path) {
	print("Processing experiment folder: " + path);
	folders = getFileList(path);
	for (i = 0; i < folders.length; i++) {
		foldernum = i+1;
		folder_nr = i+1;
		if (File.isDirectory(path + folders[i])) {
			processFolderAnalysis(path + folders[i], folder_nr);
		}
	}
	print("Experiment analyzed.");
}

setBatchMode(true);
// Select the folder containing the images
inputDir = getDirectory("Please select the input directory");
// Select output directory?

// Split the images into batches
createBatches(inputDir);

// Create Avis for single chamber rois
processFoldersForRois(inputDir);
print("Rois processed!");
processVideoAnalysis(inputDir);

print("all done!");
setBatchMode(false);