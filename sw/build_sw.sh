#! /bin/bash

echo '----------------------make fw-----------------------------' &&
cd hello_world/ && make all && 
echo '----------------------create fw param & boot/src/sec_init.S-----------------------------' &&
../create_fw_param.py build/hello_world.bin
echo '----------------------make boot-----------------------------' &&
cd ../boot_rom/ && make all && cd ../ &&
echo '----------------------copy file to Host-----------------------------' &&
cp ./hello_world/build/hello_world.vmem /mnt/hgfs/VM_WIN_GMEM/ && echo "- copy hello_world ok!"  &&
cp ./boot_rom/build/boot_rom.vmem /mnt/hgfs/VM_WIN_GMEM/ && echo "- copy boot_rom ok!" 