
:: Win builder for example extension.
:: Run cmake, build products, copy to reaper dir.
:: Uses my particular system configuration.

cls
echo off

:: cmake stuff
mkdir build\win
pushd build\win
set REAPER_SDK_PATH=C:\Dev\Misc\ReaperLab\vendor\reaper-sdk
cmake ..\..

:: build stuff
rem cmake -E environment
cmake --build .
copy %DEV_PATH%\Misc\ReaperLab\extensions\build\win\Debug\reaper_xyz_extension.dll  C:\Users\cepth\AppData\Roaming\REAPER\UserPlugins
popd

