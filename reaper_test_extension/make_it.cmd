
:: My builder for test extension.

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
copy %DEV_PATH%\Misc\ReaperLab\reaper_test_extension\build\win\Debug\reaper_test_extension.dll  C:\Users\cepth\AppData\Roaming\REAPER\UserPlugins
popd

