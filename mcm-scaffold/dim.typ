=== Description
It is known that there are 353 geomagnetic monitoring sensors.Each sensor send back a set of data for each moment.A set of data includes the strength of the magnetic field in the three directions of x,y,z.In order to establish a suitable mathematical model to ensure that the variation in the measurement data from all sensors between 24:00 and 4:00 (midnight to 4:00 AM) is consistent based on appendix 1.Each moment,we need select a variation   from one sensor, such that the difference between the variation of each sensor is minimized. To establish a mathematics model based on our problem analysis.

First of all,eliminate the effect of different initial values for each sensor caused by different position.

Then, to select the data points that is the closest to the mass of center, we need to calculate the distance between every samples and the mass of center meaning that for a 
certain time, every differences between values from every 
sensors should be calculated. For problem 2, there are 353 
sensors and 2881 time stamps in 24 hours and x,y,z three directions. The amount of calculation is $2881*353*353*3=1076995587$ which is huge for non-parallel 
algorithm. However, we can remodel this problem to matrix 
operation. 

Take a simple example of deriving every difference between elements of vector $[1,2,3]$. The following steps can be 
taken to get the result. 
1. Expand the vector to a matrix
#set math.mat(delim: "[", align: center)
$ mat(1,2,3;1,2,3;1,2,3) $
2. Transpose the matrix
$ mat(1,1,1;2,2,2;3,3,3) $
3. Do element-element subtract between the original and transposed matrix.
$ M=mat(0,1,2;-1,0,1;-2,-1,0) $
For the newly obtained matrix  $M$, its $x$-th row and $y $-th column represent the difference between the $x$-th element and the $y$-th element of the original vector.
4. Replace every element in M with its square.
$ M_1=mat(0,1,4;1,0,1;4,1,0) $
5. Sum up $M_1$ along its columns to get a new vector.
$ V_1=[5,2,5] $
The $x$-th value of $V_1$ is the square sum of differences
between the $x$-th value in the original vector and its other elements.
6. Select the minimum value from $V_1$The minimum value of $V_1$ is 2 (its second element),thus, the second value of the original vector (2) is the value that is closest to the mass of center of $[1,2,3]$

For the data from the sensors, this method can also be appied with the following steps. 
1. Rearrange the data 
Form the data to a tensor with a shape of:
$ M_0:["num of time stamps"times"num of sensors"times"3"] $
2. Expand the matrix along the second dimension
$ M_1:["num of time stamps"times"num of sensors"times"num of sensors"times 3] $
3. Subtract with its transposed as $M_2$
$ M_2=M_1-M_1^T:["num of time stamps"times"num of sensors"times"num of sensors"times 3] $
4. Perform element-wise square on $M_2$
$ M_3=M_2.^2:["num of time stamps"times"num of sensors"times"num of sensors"times 3] $
5. Sum up $M_3$ along the third dimension
$ M_4:["num of time stamps"times"num of sensors"] $
6. Find the indices of maximum value of every time stamps and map the obtained indices to the values of the original vector.
=== Implementation and results
For both problem 1 and 2, we used some simple operation of PyTorch framework along with CUDA to 
accelerate our matrix calculation on GPU, the solution of both problems can be obtained within one second,
however, it required large memory for large matrix especially for problem 2. #ref(<table-1>) shows
the optimal sensors of a few time stamps of problem 2.
#align(center)[#figure(caption: "Results illustration")[
#table(columns: 2, align: center)[Time stamp][Optimal sensors indexed][19:23:36][41][19:24:06][330][19:24:36][210][19:25:06][120][19:25:36][42][19:26:06][320][19:26:36][254][19:27:06][151][19:27:36][291]
]<table-1>]
#figure(caption: "Error occurred when the memory is not enough")[#image("2024-12-01-16-17-30.png")]
// 由于这个过程计算量特别大