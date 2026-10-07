# ReaperLab TODO1 clean up

Play with Reaper extensions and plugins.

# Extensions

C/C++

https://github.com/justinfrankel/reaper-sdk

C:\Dev\Reaper\reaper-sdk\reaper-plugins contains some very vague examples. I hacked my-stab and it builds but it is murky.
From https://github.com/justinfrankel/reaper-sdk.

Better to use SWS code as example. Install from https://standingwaterstudios.com/index.php.
Goes in C:\Users\cepth\AppData\Roaming\REAPER
See Building the SWS Extension - https://github.com/reaper-oss/sws/wiki/Building-the-SWS-Extension

- Clone the repository and submodules
git clone --recursive https://github.com/reaper-oss/sws
cd sws
tgit: Submodule update

- Create a build tree (requires php)
cmake -B build -DCMAKE_BUILD_TYPE=Debug
     -DBUILD_SWS_PYTHON=NO # don't build py support which needs perl

- Open C:\Dev\Reaper\sws\build\sws.slnx

`reaper_xyz_extension` is a demo skeleton of a Reaper extension.

# Plugins

`plugins` contains some lua flavored plugins.

