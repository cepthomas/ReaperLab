#define REAPERAPI_IMPLEMENT

#include <windows.h>
#include <cstdlib>
#include <ctime>
#include <cstdio>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>

#include "reaper_plugin.h"
#include "reaper_plugin_functions.h"

// Shut up localtime warning.
#define _CRT_SECURE_NO_WARNINGS

// Data.
REAPER_PLUGIN_HINSTANCE _hInstance = 0; // used for dialogs, if any
static reaper_plugin_info_t* _rec = nullptr;
static int _xyz_command_id1 = 0;
static int _xyz_command_id2 = 0;

// Forward refs.
static bool _runCommand(int command, int flag);
static void _onExit(void);
static bool _hookCommand2(KbdSectionInfo* sec, int commandId, int val, int valhw, int relmode, HWND hwnd);
static void _print(std::string msg);
static void _log(std::string msg);
static std::string _format(const char* fmt, ...);


//////////////////////// start here ///////////////////////////////
// REAPER extensions must support this entry function:
// return 1 if you are compatible (anything else will result in plugin being unloaded)
// if rec == NULL, then time to unload 
extern "C" REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(REAPER_PLUGIN_HINSTANCE hInstance, reaper_plugin_info_t* rec)
{
    _hInstance = hInstance;

    if (rec == nullptr) // time to unload
    {
        if (_rec != nullptr)
        {
            // Unregister on unload.
            plugin_register("-hookcommand2", (void *)_hookCommand2);
            // custom_action unregistration uses "-custom_action" with the registered struct/id.
            plugin_register("-custom_action", (void *)(uintptr_t)_xyz_command_id1);
            plugin_register("-custom_action", (void *)(uintptr_t)_xyz_command_id2);
            _rec = nullptr;
        }
        return 0;
    }

    if (rec->caller_version != REAPER_PLUGIN_VERSION || !rec->GetFunc) { return 0; }  // ???

    ///// good to go
    _rec = rec;
    REAPERAPI_LoadAPI(rec->GetFunc);
    _log(">>>>>>> good to go >>>>>>>>>");
    _print(_format("Loaded reaper_xyz_extension %s", __TIME__));

    ///// Init my reaper command handlers.
    plugin_register("hookcommand", _runCommand);
    plugin_register("atexit", (void*)_onExit);
    // or rec->Register("atexit", (void*)_onExit); or GetFunc("plugin_register")->("atexit", (void*)_onExit);
    // Hook for custom actions.
    plugin_register("hookcommand2", (void *)_hookCommand2);
    // Optional info.
    plugin_register("ext_name", (void*)"reaper_xyz_extension");
    plugin_register("ext_vendor", (void*)"Ephemera");
    plugin_register("ext_url", (void*)"https://github.com/cepthomas/ReaperLab/blob/main/README.md");

    ///// Init my custom action/commands { 0 = Main section, unique idstr, menu text }
    custom_action_register_t action1 = { 0, "XYZ_ACTION_ID1", "XYZ: Action1", nullptr };
    _xyz_command_id1 = (int)(INT_PTR)plugin_register("custom_action", &action1);
    _log(_format("Reg command_id:%d", _xyz_command_id1));

    custom_action_register_t action2 = { 0, "XYZ_ACTION_ID2", "XYZ: Action2", nullptr };
    _xyz_command_id2 = (int)(INT_PTR)plugin_register("custom_action", &action2);
    _log(_format("Reg command_id:%d", _xyz_command_id2));

    return 1;
}

///////////////////////// Internals /////////////////////////////////////

// Command hook callback
bool _hookCommand2(KbdSectionInfo* sec, int commandId, int val, int valhw, int relmode, HWND hwnd)
{
    _log(_format("_hookCommand2 commandId:%d val:%d hwnd:%d", commandId, val, hwnd));

    if (commandId == _xyz_command_id1)
    {
        // Do your custom action work here
        _print("Hello from XYX Action 11111!");
        return true; // Handled
    }
    else if (commandId == _xyz_command_id2)
    {
        // Do your custom action work here
        _print("Hello from XYX Action 22222!");
        return true; // Handled
    }


    return false; // Not handled
}

// Hook which runs prior to every action in the main section:
bool _runCommand(int command, int flag)
{
    // It is OK to call Main_OnCommand() from runCommand(), but it must check for and handle any recursion.

    _log(_format("_runCommand command:%d flag:%d", command, flag));

    // Return true if it processed the command (prevent further hooks or the action from running)
    return false;
}

// Receive a notification that REAPER is about to quit (prior to main window being destroyed).
void _onExit(void)
{
    _log(">>>>>>> adios amigo >>>>>>>>>");
}

void _print(std::string msg)
{
    _log(msg);
    // MessageBox(nullptr, "reaper_xyz_extension says", buff, 0);
    msg += "\n";
    ShowConsoleMsg(msg.c_str());
}

// Log line, adds NL.
void _log(std::string msg)
{
    // Write to file.
    std::time_t now = std::time(nullptr);
    std::fstream myfile("C:\\Dev\\Misc\\ReaperLab\\extensions\\plugin_log.txt", std::ios::app);
    myfile << now << " " << msg << std::endl;
    myfile.close();
}

std::string _format(const char* fmt, ...)
{
    char buff[100];
    va_list args;
    va_start(args, fmt);
    vsnprintf(buff, sizeof(buff), fmt, args);
    va_end(args);
    return std::string(buff);
}
