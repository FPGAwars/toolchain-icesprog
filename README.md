# toolchain-icesprog
Apio package that contains the [icesprog programmer](https://github.com/wuxx/icesugar) for the icesugar board

## build instructions

On *Ubuntu 18.04.5 LTS*

```
sudo apt install git && git clone https://github.com/FPGAwars/toolchain-icesprog.git
cd toolchain-icesprog
./build.sh linux_i686
./build.sh linux_x86_64
./build.sh windows_x86
./build.sh windows_amd64
```

Other target platforms may work in the future.

On *Ubuntu 16.04.6 LTS on WSL2*

```
sudo apt install git && git clone https://github.com/FPGAwars/toolchain-icesprog.git
cd toolchain-icesprog
# ./build.sh linux_i686 # Not working!!
./build.sh linux_x86_64 
./build.sh windows_x86
./build.sh windows_amd64
```

## Credits

* The [icesprog](https://github.com/wuxx/) programmer has been develop by [wuxx](https://github.com/wuxx)  

