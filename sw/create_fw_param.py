#! /usr/bin/python3
import os
import sys
# import binascii
import array

def sha1(data):
    bytes = ""

    h0 = 0x67452301
    h1 = 0xEFCDAB89
    h2 = 0x98BADCFE
    h3 = 0x10325476
    h4 = 0xC3D2E1F0

    for n in range(len(data)):
        bytes += '{0:08b}'.format(ord(data[n]))
    bits = bytes+"1"
    pBits = bits
    # pad until length equals 448 mod 512
    while len(pBits)%512 != 448:
        pBits += "0"
    # append the original length
    pBits += '{0:064b}'.format(len(bits)-1)

    def chunks(l, n):
        return [l[i:i+n] for i in range(0, len(l), n)]

    def rol(n, b):
        return ((n << b) | (n >> (32 - b))) & 0xffffffff

    for c in chunks(pBits, 512): 
        words = chunks(c, 32)
        w = [0]*80
        for n in range(0, 16):
            w[n] = int(words[n], 2)
        for i in range(16, 80):
            w[i] = rol((w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16]), 1)  

        a = h0
        b = h1
        c = h2
        d = h3
        e = h4

        # Main loop
        for i in range(0, 80):
            if 0 <= i <= 19:
                f = (b & c) | ((~b) & d)
                k = 0x5A827999
            elif 20 <= i <= 39:
                f = b ^ c ^ d
                k = 0x6ED9EBA1
            elif 40 <= i <= 59:
                f = (b & c) | (b & d) | (c & d) 
                k = 0x8F1BBCDC
            elif 60 <= i <= 79:
                f = b ^ c ^ d
                k = 0xCA62C1D6

            temp = rol(a, 5) + f + e + k + w[i] & 0xffffffff
            e = d
            d = c
            c = rol(b, 30)
            b = a
            a = temp

        h0 = h0 + a & 0xffffffff
        h1 = h1 + b & 0xffffffff
        h2 = h2 + c & 0xffffffff
        h3 = h3 + d & 0xffffffff
        h4 = h4 + e & 0xffffffff

    return '%08x%08x%08x%08x%08x' % (h0, h1, h2, h3, h4)

def read_and_hash(filename):
    # 以二进制模式打开文件
    with open(filename, 'rb') as f:
        data = f.read()

    # 将数据转换为字符串，因为我们的 sha1 函数需要一个字符串作为输入
    data_str = data.decode('latin-1')

    # 计算哈希值
    hash_value = sha1(data_str)

    return hash_value

class CRC32:
    def __init__(self):
        self.polynomial = 0xEDB88320
        self.crc32_table = array.array('I')
        self._init_crc32_table()

    def _init_crc32_table(self):
        for i in range(256):
            crc = i
            for _ in range(8):
                if crc & 1:
                    crc = (crc >> 1) ^ self.polynomial
                else:
                    crc = crc >> 1
            self.crc32_table.append(crc)

    def calculate(self, buf):
        ret = 0xFFFFFFFF
        for idx, b in enumerate(buf):
            ret = self.crc32_table[(ret ^ b) & 0xFF] ^ (ret >> 8)
            # if idx % 64 == 0 or idx - 1 == len(buf):
            #     print(idx, hex(b), hex(ret), len(buf))
        return ret ^ 0xFFFFFFFF

bin_file_path = sys.argv[1]
print('''
______ _    _                  _  __       
|  ___| |  | |                (_)/ _|      
| |_  | |  | | __   _____ _ __ _| |_ _   _ 
|  _| | |/\| | \ \ / / _ \ '__| |  _| | | |
| |   \  /\  /  \ V /  __/ |  | | | | |_| |
\_|    \/  \/    \_/ \___|_|  |_|_|  \__, |
                                      __/ |
                                     |___/ 

''')
print('- file path: ', bin_file_path + '\n' + '-'*60)

# 获取文件大小
file_size = os.path.getsize(bin_file_path)
print('- bin len: {}({}) bytes'.format(file_size, hex(file_size)))

center_index = (file_size>>1)&0xfffffff0

# 打开并读取文件
with open(bin_file_path, 'rb') as f:
    first_word = int.from_bytes(f.read(4), 'little')  # 使用小端字节序
    print('- bin first 4Byte: {}({})'.format(hex(first_word), first_word))

    f.seek(center_index)
    center_word = int.from_bytes(f.read(4), 'little')  # 使用小端字节序
    print('- bin center 4Byte: {}({})'.format(hex(center_word), center_word))
    print('- center index: {}({})'.format(hex(center_index), center_index))

    f.seek(file_size - 4)
    last_word = int.from_bytes(f.read(4), 'little')  # 使用小端字节序
    print('- bin last 4Byte: {}({})'.format(hex(last_word), last_word))

    part_param = first_word^center_word^last_word

print('-'*60)
print('- param_local(XOR):', hex(part_param))

# 创建一个 CRC32 对象
crc32 = CRC32()

data = None
with open(bin_file_path, 'rb') as f:
        data = f.read()
# 计算一个字符串的 CRC32 值
param_detail = hex(crc32.calculate(data))
print('- param_detail(CRC32):', param_detail)

# print('- hash(sha1):', read_and_hash(bin_file_path))

raw_sec_init_s = '''  
    .section .sec_param, "a"
    .org 0x0
    .long 0x00000000

    .org 0x4
    .long 0x00000000

    .org 0x8
    .long 0x00000000

    .org 0xc
    .long @PARAM_DETAIL

    .org 0x10
    .long @PARAM_LOCAL

    .org 0x14
    .long @LEN
'''
sec_init_s = raw_sec_init_s.replace('@LEN', hex(file_size)).replace('@PARAM_LOCAL', hex(part_param)).replace('@PARAM_DETAIL', param_detail)
# print(sec_init_s)

with open('../boot_rom/src/sec_init.S', 'w') as f:
    f.write(sec_init_s)
print('- boot_rom/src/sec_init.S create success!')