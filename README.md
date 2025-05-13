## Radar Signal Processing (2023H2)
### UHF Radar Echo Analysis using the Chungli UHF Radar Station
This project utilizes the ST Array Antenna at the Chungli UHF Radar Station, operating in a monostatic radar configuration, to analyze received echo signals. The data processing pipeline is as follows:

1. IQ Signal Extraction:  
When the raw radar signal enters the mixer, it generates in-phase (I) and quadrature (Q) channel signals.  

2. IQ Signal Processing:  
The IQ signals are shifted in phase to compensate for delay time effects, which enhances the accuracy of subsequent spectral analysis.  

3. Preliminary Results – Range-Time-Intensity (RTI):  
The abscissa (x-axis) represents time, and the ordinate (y-axis) represents the slant range between the antenna and the target. To estimate the actual altitude of the target, a coordinate transformation is required.

4. Spectral Analysis:  
(1) Non-coherent Integration: Smooths the raw radar spectrum to reduce noise and improve the clarity of the data.  
(2) White Noise Removal: Background noise is filtered out to isolate meaningful signals.  
(3) Running Mean: Applies a smoothing function to the power spectrum for clearer visualization.

5. Result:  
Strong echo signals are observed in the spectrogram. These signals were verified to originate from aircraft, which is consistent with the presence of an airport near the Chungli UHF Radar Station.
