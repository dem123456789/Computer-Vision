This is code provides a minimal working (MWE) example of the paper
"Inverting RANSAC: Global Model Detection via Inlier Rate Estimation"
presented at CVPR 2015

---	Verson 0.1 ---

Please note
- The code provided "as-is" and my not work on your machine - please let us know if this happens. The code was tested on matlab 2013b.
- Some functions are implemented in c++. We provide compiled mex files for windows 64-bit. 
- Some matlab code were converted using "matlab coder". We provide compiled mex files for windows 64-bit. (In the future we will release the "prj" file and the "codegen" folder).
- Run the 'compile-mex' script
- To run the MWE - try "script_MWE_ComparisonToUSAC.m" in the "code" folder.
- The code relies on the following 3rd party packeages:
	1) USAC (provided as windows EXE file)
	2) Mikolajczyk's data-set (two images provided along with groundtruth)
	3) vl_feat (no provided, but the result of "vl_sift" is saved in a mat file)
	
	
Good luck!
The authors