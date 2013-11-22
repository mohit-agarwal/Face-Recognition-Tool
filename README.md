*README*


The Project has been done in MATLAB.

The project is divided into into 3 parts:

1.For *Yale Dataset* : The matlab file for this part is ‘yale.m’.

For this part, there are 39 classes, each containing some images initially. As guided, we have select 20 images from each class, where elevation angle and Azimuth angle is b/w -25 to 25.
This has been done using a Perl Script, “smai.pl”. The script picks 20 images from each class based on the constraints, and copies them into a new folder, “dataset_yale”.
Then, the “yale.m” file operates on the files in the folder, “dataset_yale”.


2.For *CMU-PIE Dataset* : The matlab file for this part is ‘cmu.m’.


3.For *SMAI Students Dataset* : There are 2 matlab files for this:

-> SMAIstudent_crossvalidation.m : This file is for 4-cross validation method.
-> SMAIstudent_holdoneout.m : This file is for the hold-one-out validation method.

IMAGE RECONSTRUCTION
--------------------

There is also a “democode_smai.m” code file, that has been trained on the SMAI Students dataset.It takes an input image and returns the label of the closest image, that is present in the trained dataset. The input image is also reconstructed using the Eigen Faces computed.
The “democode_yale.m” code file is trained on the Yale Dataset.

VERIFICATION
------------

There is a "verify_yale.m" code file which is trained on Yale dataset and is used for verification.
There is a "verify_smai.m" code file which is trained on SMAI Students dataset and is used for verification.


