REM copy this in esptool.py directory
esptool.py --port COM6 write_flash -fs 1MB -fm dout  0x00000 0x00000.bin 0x10000 0x10000.bin
pause