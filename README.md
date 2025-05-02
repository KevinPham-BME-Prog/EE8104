The purpose of this git repository is to upload and hold the programming files (MATLAB) used to complete personalized assignments
for Adaptive Signal Processing taught by Sri Krishnan at Toronto Metropolitan University in the Winter 2025 Semester. 
There are five assignments, each corresponding to different goals for the code, analysis, and datasets. 
Some assignments used the same dataset; however performed a different analysis or were built upon the previous dataset.
The first assignment focused on understanding the importance of using proper sampling frequencies for signal acquisition,
allocating necessary bits for analog and digital conversion, and applying denoising methodologies on the signal for analysis.
This assignment used the "VOICED Database" found on the PhysioNet website, the signals were resampled to half and double the original
Sampling frequency was quantized to a different number of bits allocated, and artificial noise was removed using a synchronized averaging filter
and a moving average filter to find the corresponding signal-to-noise ratio.
The second assignment focused on applying the linear predictor adaptive filter for speech synthesis to generate an autoregressive signal.
This assignment used the same dataset as assignment 1 and used the linear predictive coefficients of different speech signals to attempt to reconstruct the signal for analysis.
The third assignment compared the recursive least squares algorithm and the least mean square algorithm for electrocardiogram and phonocardiogram denoising.
This assignment used the “EPHNOGRAM: A Simultaneous Electrocardiogram and Phonocardiogram Database” found on PhysioNet.
The fourth assignment involved the implementation of a Support Vector Machine for the  classification of electroencephalograms of students performing 
mental arithmetic. However, the code provided is used to create the features necessary for the classification, which consists of using the Hjorth parameters and the 
peak frequency and the corresponding frequency. The SVM model was designed and implemented using the apps found in MATLAB.
The fifth assignment focused on the implementation of both an SVM model and a deep learning model, specifically an artificial neural network, to both analyze the number of features used vs the accuracy plot, percentage of the dataset used vs the accuracy plot, using the features obtained in assignment 4.
