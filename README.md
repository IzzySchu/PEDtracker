# PEDtracker
PEDtracker (post-embryonal development (PED) tracker) is a tool for tracking and analyzing the post-embryonal development of insects and relatives.

First component of the software is an ImageJ script (PEDtrack.ijm)

(1) Select ROIs (regions of interests) in your arena/image and save them as RoiSet.zip in the parent folder
(2) Adjust parameters according to your research question
(3) Running PEDtrack.ijm the user has to select the folder containing the images

--> By using PEDtrack.ijm images are processed in batches and videos of ROIs are generated (batch = time; ROI = space). Then objects are extracted and results are saved as .csv-files. Transition areas between larval stages are analyzed by settings of two larval stages. 

Second component of the software is a R package (PEDtracker.R)

(1) Adjust parameters according to your research question
(2) Run PEDtracker 
    (2.1) .csv-files are loaded and processed by number of ROIs and batches (one .csv-file = one batch); each ROI is then processed individually 
    (2.2) .csv-files of an individual ROI are sorted by number of batches; better fitting files of the transition area can be selected by specific parameters (in our case   
    Solidity) 
    (2.3) .csv-files of an individual ROI are combined to a single table containing all data (= data_table_new)
    (2.4) duplicated detections for each frame (= ID) are removed by comparing specific parameters (in our case Solidity)
    (2.5) Data of data_table_new are transferred to a new table (data_table_final) containing one detection point per time/frame; frames missing data are indicated with NaN
    (2.6) data_table_final are analyzed for different body parameters (e.g. activity, growth) by applying respective functions 
    (2.7) Results are saved for each individual ROI as .csv-files and .tiffs.
    
    
    
    
    
    
