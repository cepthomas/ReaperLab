#define REAPERAPI_IMPLEMENT

//#include <windows.h>
//#include <stdio.h>
//#include <math.h>
#include <cstdlib>
#include <ctime>
#include <cstdio>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>

#include "reaper_plugin.h"
#include "reaper_plugin_functions.h"


extern "C"
{
    // Forward refs.
    void _debugIt(std::string msg);
    void _logIt(std::string msg);
    bool _runCommand(int command, int flag);
    void _onExit(void);

    REAPER_PLUGIN_HINSTANCE _hInstance; // used for dialogs, if any

    // REAPER extensions must support this entry function:
    // int ReaperPluginEntry(HINSTANCE hInstance, reaper_plugin_info_t *rec);
    // return 1 if you are compatible (anything else will result in plugin being unloaded)
    // if rec == NULL, then time to unload 
    REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(REAPER_PLUGIN_HINSTANCE hInstance, reaper_plugin_info_t* rec)
    {
        _hInstance = hInstance;

        if (!rec) { return 0; } // time to unload
        if (rec->caller_version != REAPER_PLUGIN_VERSION || !rec->GetFunc) { return 0; }  // ???
        
        // else good to go
        REAPERAPI_LoadAPI(rec->GetFunc);

        _logIt(">>>>>>>>>>>>>>>>");

        // Init my command handlers.
        // Refer to reaper_plugin_info_t in reaper-sdk\sdk\reaper_plugin.h.
        // See also reaper-sdk\sdk\example_m3u\import_m3u.cpp
        // Register() is also available by using GetFunc("plugin_register")
        rec->Register("hookcommand", _runCommand);
        plugin_register("atexit", (void*)_onExit);

        rec->Register("ext_name", (void*)"My cool extension");
        rec->Register("ext_vendor", (void*)"Ephemera");
        rec->Register("ext_url", (void*)"https://github.com/cepthomas/ReaperLab/blob/main/README.md");

        char buff[100];
        std::snprintf(buff, 100, "Loaded reaper_test_extension ver:%s", __TIME__);
        _debugIt(buff);
        _logIt(buff);

        return 1;
    }

    ///////////////////////// Internals /////////////////////////////////////
    void _debugIt(std::string msg)
    {
        ShowConsoleMsg(msg.c_str());
        // MessageBox(nullptr, "reaper_test_extension says", buff, 0);
    }

    //void LogIt(const char* msg)
    void _logIt(std::string msg)
    {
        // Write to file.
        time_t now = std::time(0);
        std::tm* local_time = std::localtime(&now);
        char buffer[200];
        std::strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local_time);

        std::fstream myfile("C:\\Dev\\Misc\\ReaperLab\\plugin_log.txt", std::ios::app);
        myfile << buffer << " " << msg << std::endl;
        myfile.close();
    }

    // Hook which runs prior to every action in the main section:
    bool _runCommand(int command, int flag)
    {
        //It is OK to call Main_OnCommand() from runCommand(), but it must check for and handle any recursion.
        std::stringstream ss;
        ss << "command:" << command << " flag:" << flag;
        _logIt(ss.str());
        // Return true if it processed the command (prevent further hooks or the action from running)
        return false;
    }

    //    Receive a notification that REAPER is about to quit (prior to main window being destroyed).
    void _onExit(void)
    {
        _logIt("Adios!");
    }
};
