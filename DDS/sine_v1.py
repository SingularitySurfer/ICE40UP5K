

# SingularitySurfers sine script :)

import math;
import sys;

f = open('sine16x16.bin', 'w+b')

C=32768; #2^16
y= range(C);
hex=range(C);
byte_sine=range(C);

for x in range(C):
    y[x]=int(((1+math.sin((float(x)/C)*2*math.pi))/2)*C*2);
    hex[x]='{0:04X}'.format(int(y[x]));
    sys.stdout.write(hex[x]);
    #byte_sine[x]=bytearray.fromhex(hex[x]);
    f.write(bytes(hex[x]));

f.close;


# fuuuck python
