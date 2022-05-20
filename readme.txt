Data uploaded are pressure fluctuations time series (*.txt). 

Left columns are times, right columns are pressure fluctuations. 

Details of pressure fluctuation data:
	Sampling Rate : 12kHz
	Senstivity : 217.5 mV/kPa (this unit is used to convert voltage to Pascals)
	Acquired signals are in V.

Time is obtained in seconds by substracting the first element of the first column from the entire first column.

Data sets are given for different rates of change of airflow rates (g/s^2).
data1: 0.1 g/s^2, (splitted into two parts data1a, and data1b)
data2: 0.3 g/s^2,
data3: 0.4 g/s^2,
data4: 0.6 g/s^2,
data5: 0.8 g/s^2,
data6: 1.2 g/s^2,
data7: 2.0 g/s^2.
 
To analyse data sets MATLAB software have been used. 

Source codes for generating results are also attached. 
