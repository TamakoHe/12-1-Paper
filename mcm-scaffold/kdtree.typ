#set text(size:12pt)
#set par(first-line-indent: 12pt)
Considering problem 2 that the sensors data from 24 hours 
is requied to be processed, the size of matrix constructed
for differential calculation is extremely large ($4311 times 4311$). It requires approximately 25GB of GPU memory if the data is stored in 64-bit floting point form which exceed the limit of household PC. Although we rent a A800 
GPU to obtain the accurate results, this is not pratical 
in because of high cost.


