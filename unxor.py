#curl https://download.eac-cdn.com/api/v1/games/55/client/win64/download/?uuid=0 --output EAC

# Decode the first kilobyte of binary data

# ./unxor.py binary_data.eac

import sys

data = bytearray(open(sys.argv[1], "rb").read())

for i in range(1024):
    data[i] ^= (i * 3) & 0xff

open("./out", "wb").write(data)