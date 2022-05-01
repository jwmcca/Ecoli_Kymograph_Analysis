// Measure the speed in a kymograph.
frame_time = 0.7; //answer in seconds.
pixel_size = 25; //answer in nm.

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
getLine(x1, y1, x2, y2, lineWidth);
setColor(255,255,0) //yellow
//setColor(0,0,0) //black
Overlay.drawLine(x1, y1, x2, y2);
Overlay.show
time = abs((y2-y1)*frame_time);
length = abs((x2-x1)*pixel_size);
velocity = abs(length/time);
n = nResults;
setResult("Time (s)",n,time);
setResult("Length (nm)",n,length);
setResult("Velocity (nm/s)",n,velocity);