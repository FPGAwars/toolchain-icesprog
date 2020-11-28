# toolchain-icesprog
Apio package that contains the [icesprog programmer](https://github.com/wuxx/icesugar) for the icesugar board

## Supported platfomos:

* linux_i868: Linux 32-bits
* linux_x86_64: Linux 64-bits
* windows_x86: Windows 32 bits
* windows_amd64: Windows 64bits

## build instructions

Tested on *Ubuntu 20.04 LTS*

```
sudo apt install git && git clone https://github.com/aalku/toolchain-icesprog.git
cd toolchain-icesprog
./build.sh linux_i686
./build.sh linux_x86_64
./build.sh windows_x86
./build.sh windows_amd64
```

It will generate the static binaries in the following tar.gz files (where v.x.y is the version)

* toolchain-icesprog-linux_x86_64-v.x.y.tar.gz : Linux 64-bits

Other target platforms may work in the future.

## Credits

* The [icesprog](https://github.com/wuxx/) programmer has been develop by [wuxx](https://github.com/wuxx)  

