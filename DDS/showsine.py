

import struct

with open('sine_np.bin', 'rb') as file:
      indata= file.read()
struct.unpack('h'*65536, indata)

import matplotlib.pyplot as plt

plt.plot(struct.unpack('h'*65536, indata))
plt.show()
