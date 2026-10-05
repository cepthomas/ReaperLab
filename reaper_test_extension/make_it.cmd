
cls
echo off

:: cmake stuff
mkdir build\win
pushd build\win
set REAPER_SDK_PATH=C:\Dev\Reaper\reaper-sdk
cmake ..\..

:: build stuff
rem cmake -E environment
cmake --build .
copy C:\Dev\Misc\ReaperLab\reaper_test_extension\build\win\Debug\reaper_test_extension.dll  C:\Users\cepth\AppData\Roaming\REAPER\UserPlugins
popd

