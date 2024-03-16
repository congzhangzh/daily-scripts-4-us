# hope this may help someone

I write many little script which inspire my life from 13 years, hope this may help others.

some of them learn from other place, I will add reference at the beginning if I remmember.

# [Find your raspberry pi](find_your_pi.sh)
# [Stop gnome tracker eat all your disk space](stop_gnome_tracker_eat_all_your_disk_space.sh)
# [Enable NoMachine with hardware acceleration by Intel iGPU on headness server ](daily-scripts-4-us/enable_headness_intel_igpu_4_nomachine.sh)
# Speed you windows C++ build by ccache like tools

## 1. Install ccache to c:\\ccache

https://ccache.dev/download.html

## 2. Three way to make ccache work on windows
### - [The first way] Work for Visual Studio project 

Tips: You may need call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" like stuff

#### 1. Step1:
Copy ccache.exe to cl.exe, masq as cl.exe and will forward work to real cl.exe, 

```bat
cd c:\ccache\
copy c:\ccache\ccache.exe cl.exe
```

#### 2. Step2:
Put [Directory.Build.props](ccache/Directory.Build.props) in any upper dir

#### 3. Step3:
Put [Directory.Build.targets](ccache/Directory.Build.targets) in any upper dir

### - [The second way] Work for ninja-build like tools

Tips: You may need call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" like stuff

#### 1. Create a real wapper with this content, 
[ccache_cl_wrapper.bat](ccache/ccache_cl_wrapper.bat)

Tips: put the file with your ccache.exe

```bat
@echo off
%~dp0\ccache.exe cl.exe %*
```

#### 2. run some tools which work with CC&CXX Environment Variable
```bat
CC=c:\ccache\ccache_cl_wrapper.bat
CXX=c:\ccache\ccache_cl_wrapper.bat

cmake -G Ninja -S your_src_dir -B your_build_dir
```

### - [The third way] Work with CMake by CMAKE_C_COMPILER_LAUNCHER and CMAKE_CXX_COMPILER_LAUNCHER

```bat
cmake -G Ninja -DCMAKE_C_COMPILER_LAUNCHER="c:\ccache\ccache.exe" -DCMAKE_CXX_COMPILER_LAUNCHER="c:\ccache\ccache.exe" -S your_src_dir -B your_build_dir
```

## 3. The hard part

some time, you may mix these way together, which does not work most of the time, windows is not friendly for build cache, as Visual Studio is a one in all solution?!

## 4. How to debug ccache works or not

### By your cache info
```bat
c:\ccache\ccache -s
c:\ccache\ccache --print-stats
```
### By [ProcExp](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

## 5. Have a lot of fun


