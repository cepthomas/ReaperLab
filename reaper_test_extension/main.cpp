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


// Data.
REAPER_PLUGIN_HINSTANCE _hInstance; // used for dialogs, if any
static reaper_plugin_info_t* _rec = nullptr;
static int _my_command_id = 0;

// Forward refs.
static void _print(std::string msg);
static void _log(std::string msg);
static bool _runCommand(int command, int flag);
static void _onExit(void);
static std::string _format(const char* fmt, ...);
static bool HookCommand2(int command, int flag);


//////////////////////// start here ///////////////////////////////
// REAPER extensions must support this entry function:
// int ReaperPluginEntry(HINSTANCE hInstance, reaper_plugin_info_t *rec);
// return 1 if you are compatible (anything else will result in plugin being unloaded)
// if rec == NULL, then time to unload 
extern "C" REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(REAPER_PLUGIN_HINSTANCE hInstance, reaper_plugin_info_t* rec)
{
    _hInstance = hInstance;

    if (!rec) // time to unload
    {
        if (_rec)
        {
            // Unregister on unload TODO1 others --- Note: custom_action unregistration uses "-custom_action" with the registered struct/id
            plugin_register("-hookcommand2", (void *)HookCommand2);
        }
        _rec = nullptr;
        return 0;
    }
    _rec = rec;

    if (rec->caller_version != REAPER_PLUGIN_VERSION || !rec->GetFunc) { return 0; }  // ???

    ///// else good to go
    REAPERAPI_LoadAPI(rec->GetFunc);

    _log(">>>>>>> good to go >>>>>>>>>");

    ///// Init my reaper command handlers.
    // Refer to reaper_plugin_info_t in reaper-sdk\sdk\reaper_plugin.h.
    // See also reaper-sdk\sdk\example_m3u\import_m3u.cpp
    // Register() is also available by using GetFunc("plugin_register")
    rec->Register("hookcommand", _runCommand);
    rec->Register("atexit", (void*)_onExit);
    // plugin_register("atexit", (void*)_onExit);

    rec->Register("ext_name", (void*)"My cool extension");
    rec->Register("ext_vendor", (void*)"Ephemera");
    rec->Register("ext_url", (void*)"https://github.com/cepthomas/ReaperLab/blob/main/README.md");

    ///// Init my custom action/commands.
    rec->Register("hookcommand2", (void *)HookCommand2);
    custom_action_register_t action =
    {
        0,                  // uniqueSectionId (0 = Main section)
        "MY_UNIQUE_ACTION_ID", // idStr (must be unique)
        "My Cool C++ Custom Action", // descriptive name
        nullptr
    };
    _my_command_id = (int)(INT_PTR)rec->Register("custom_action", &action);
    std::string s = _format("Reg command_id:%d", _my_command_id);
    _print(s);
    _log(s);


    // /*
    // ** custom_action_register_t allows you to register ("custom_action") an action or a reascript into a section of the action list
    // ** register("custom_action",ca) will return the command ID (instance-dependent but unique across all sections), 
    // ** or 0 if failed (e.g dupe idStr for actions, or script not found/supported, etc)
    // ** for actions, the related callback should be registered with "hookcommand2"
    // */
    // typedef struct _REAPER_custom_action_register_t
    // {
    //   int uniqueSectionId; // 0/100=main/main alt, 32063=media explorer, 32060=midi editor, 32061=midi event list editor, 32062=midi inline editor, etc
    //   const char* idStr; // must be unique across all sections for actions, NULL for reascripts (automatically generated)
    //   const char* name; // name as it is displayed in the action list, or full path to a reascript file
    //   void *extra; // reserved for future use
    // } custom_action_register_t;

    // void regit()
    // {
    //     static custom_action_register_t s;
    //     memset(&s, 0, sizeof(custom_action_register_t));
    //     s.idStr = pCommand->id;
    //     s.name = pCommand->accel.desc;
    //     s.uniqueSectionId = pCommand->uniqueSectionId;
    //     cmdId = plugin_register("custom_action", (void*)&s); // will re-use the known cmd ID, if any
    // }


    // std::stringstream ss;
    // ss << "Loaded reaper_test_extension ver:" << __TIME__;// << std::endl;
    // _print(ss.str());
    // _log(ss.str());

    s = _format("Loaded reaper_test_extension ver:%s", __TIME__);
    _print(s);
    _log(s);


    return 1;
}

///////////////////////// Internals /////////////////////////////////////

//!!!!! Command hook callback
static bool HookCommand2(int command, int flag)
{
    if (command == _my_command_id)
    {
        // Do your custom action work here
        _print("Hello from C++ Custom Action!");
        _log("Hello from C++ Custom Action!");
        return true; // Handled
    }
    return false; // Not handled
}



// Hook which runs prior to every action in the main section:
bool _runCommand(int command, int flag)
{
    // It is OK to call Main_OnCommand() from runCommand(), but it must check for and handle any recursion.
    std::stringstream ss;
    ss << "command:" << command << " flag:" << flag;
    _log(ss.str());
    // Return true if it processed the command (prevent further hooks or the action from running)
    return false;
}

// Receive a notification that REAPER is about to quit (prior to main window being destroyed).
void _onExit(void)
{
    _log("Adios!");
}

void _print(std::string msg)
{
    msg += "\n";
    ShowConsoleMsg(msg.c_str());
    // MessageBox(nullptr, "reaper_test_extension says", buff, 0);
}

// Log line, adds NL.
void _log(std::string msg)
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


std::string _format(const char* fmt, ...)
{
    char buff[100];
    va_list args;
    va_start(args, fmt);
    vsnprintf(buff, sizeof(buff), fmt, args);
    va_end(args);
    return std::string(buff);
}


// std::string _format2(const char* fmt, ...)
// {
//     // A common C++11 pattern to safely allocate a buffer for snprintf
//     va_list args;
//     va_start(args, fmt);
//     std::vector<char> buf(100);

//     std::vsnprintf(buf.data(), buf.size(), fmt, args);
//     va_end(args);
//     return std::string(buf.data(), buf.size());
// }


// std::string format_string(const char* fmt, ...)
// {
//     // A common C++11 pattern to safely allocate a buffer for snprintf
//     va_list args;
//     va_start(args, fmt);
    
//     // Determine required size
//     va_list args_copy;
//     va_copy(args_copy, args);
//     int size = std::vsnprintf(nullptr, 0, fmt, args_copy);
//     va_end(args_copy);
    
//     if (size < 0) { va_end(args); return ""; }

//     std::vector<char> buf(size + 1);
//     std::vsnprintf(buf.data(), buf.size(), fmt, args);
//     va_end(args);
    
//     return std::string(buf.data(), size);
// }

