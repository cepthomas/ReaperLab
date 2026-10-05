#define REAPERAPI_IMPLEMENT

#include <cstdlib>
#include <ctime>
#include <cstdio>

#include "reaper_plugin.h"
#include "reaper_plugin_functions.h"


extern "C"
{
    REAPER_PLUGIN_HINSTANCE _hInstance; // used for dialogs, if any

    // REAPER extensions must support this entry function:
    // int ReaperPluginEntry(HINSTANCE hInstance, reaper_plugin_info_t *rec);
    // return 1 if you are compatible (anything else will result in plugin being unloaded)
    // if rec == NULL, then time to unload 
    REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(REAPER_PLUGIN_HINSTANCE hInstance, reaper_plugin_info_t* rec)
    {
        _hInstance = hInstance;

        // static pcmsink_register_t myreg = { ... };
        // rec->Register("pcmsink", &myreg);

        if (!rec) { return 0; } // time to unload
        if (rec->caller_version != REAPER_PLUGIN_VERSION || !rec->GetFunc) { return 0; }  // ???
        
        // else good to go
        REAPERAPI_LoadAPI(rec->GetFunc);

        //auto now = std::chrono::system_clock::now();
        //auto snow = std::chrono::format("Current time: {:%Y-%m-%d %H:%M:%S}\n", now);

        time_t now = std::time(0);
        std::tm* local_time = std::localtime(&now);

        char buffer[80];
        std::strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local_time);

        // std::srand(static_cast<unsigned int>(std::time(0)));
        // int die_roll = (std::rand() % 60) + 1;

        char buff[100];
        std::snprintf(buff, 100, "Loaded reaper_test_extension ver:%s", __TIME__);

        ShowConsoleMsg(buff);
        // ShowConsoleMsg("Loaded reaper_test_extension");
        // MessageBox(nullptr, "Hello from reaper_test_extension", snow, 0);

        return 1;
    }
};



/*  TODO1 >>> From C:\Dev\Reaper\reaper-sdk\reaper-plugins\reaper_plugin.h

typedef struct reaper_plugin_info_t
{
    int caller_version; // REAPER_PLUGIN_VERSION
    HWND hwnd_main;


    ///// get a generic API function, there many of these defined. see reaper_plugin_functions.h
    void * (*GetFunc)(const char *name); // returns 0 if function not found

    ///// register a function
    int (*Register)(const char *name, void *infostruct); // returns 1 if registered successfully
    Register() is the API that plug-ins register most things, be it keyboard shortcuts, project importers, etc.
    Register() is also available by using GetFunc("plugin_register")

    extensions typically register things on load of the DLL, for example:
     static pcmsink_register_t myreg = { ... };
     rec->Register("pcmsink", &myreg);

    on plug-in unload (or if the extension wishes to remove it for some reason):
     rec->Register("-pcmsink", &myreg);

    the "-" prefix is supported for most registration types.
    some types support the < prefix to register at the start of the list

    Registration types:
      API_*:
        if you have a function called myfunction(..) that you want to expose to other extensions, use:
          rec->Register("API_myfunction",funcaddress);
        other extensions then use GetFunc("myfunction") to get the function pointer.

      APIdef_*:
        To make a function registered with API_* available via ReaScript, follow the API_ registration with:
          double myfunction(char* str, int flag);
          const char *defstring = "double\0char*,int\0str,flag\0help text for myfunction"
          rec->Register("APIdef_myfunction",(void*)defstring);
        defstring is four null-separated fields: return type, argument types, argument names, and help.

      APIvararg_*:
        Used to set the reascript vararg function pointer for an API_:
           (void *) (void * (*faddr_vararg)(void **arglist, int numparms))

          numparms will typically be the full requested parameter count (including NULL pointers for any
          unspecified optional parameters)

          arguments and return values:
            integer as (void *)(INT_PTR) intval
            double as (void *)&some_double_in_memory
            pointers directly as pointers (can be NULL, especially if Optional)


      hookcommand:
        Registers a hook which runs prior to every action in the main section:
          bool runCommand(int command, int flag);
          rec->Register("hookcommand",runCommand);
        runCommand() should return true if it processed the command (prevent further hooks or the action from running)
        It is OK to call Main_OnCommand() from runCommand(), but it must check for and handle any recursion.

      hookpostcommand:
        Registers a hook which runs after each action in the main section:
          void postCommand(int command, int flag);
          rec->Register("hookpostcommand",postCommand);

      hookcommand2:
        Registers a hook which runs prior to every action triggered by a key/MIDI event:
          bool onAction(KbdSectionInfo *sec, int command, int val, int val2, int relmode, HWND hwnd);
          rec->Register("hookcommand2",hook); \
        onAction returns true if it processed the command (preventing further hooks or actions from running)
          val/val2 are used for actions triggered by MIDI/OSC/mousewheel
            - val = [0..127] and val2 = -1 for MIDI CC,
            - val2 >=0 for MIDI pitch or OSC with value = (val2|(val<<7))/16383.0
            - relmode absolute(0) or 1/2/3 for relative adjust modes

      hookpostcommand2:
         void (*hook)(KbdSectionInfo *section, int actionCommandID, int val, int valhw, int relmode, HWND hwnd, ReaProject *proj);
         rec->Register("hookpostcommand2",hook);

      command_id:
        Registers/looks up a command ID for an action. Parameter is a unique string with only A-Z, a-z, 0-9.
          int command = Register("command_id","MyCommandName");
        returns 0 if unsupported/out of actions

      command_id_lookup:
        Like command_id but only looks up, does not create a new command ID.

      pcmsink_ext:
        Registers an extended audio sink type:
          (pcmsink_register_ext_t *)

      pcmsink:
        Registers an audio sink type:
          (pcmsink_register_t *)

      pcmsrc:
        Registers an audio source:
        (pcmsrc_register_t *)

      timer:
        Runs a timer periodically:
          void (*timer_function)();

      hwnd_info:  (6.29+)
        query information about a hwnd
          int (*callback)(HWND hwnd, INT_PTR info_type);
         -- note, for v7.23+ ( -- check with GetAppVersion() -- ), you may also use a function with this prototype:
          int (*callback)(HWND hwnd, INT_PTR info_type, const MSG *msg); // if msg is non-NULL, it will have information about the currently-processing event.

        return 0 if hwnd is not a known window, or if info_type is unknown

        info_type:
           0 = query if hwnd should be treated as a text-field for purposes of global hotkeys
               return: 1 if text field
               return: -1 if not text field
           1 = query if global hotkeys should be processed for this context  (6.60+)
               return 1 if global hotkey should be skipped (and default accelerator processing used instead)
               return -1 if global hotkey should be forced

      file_in_project_ex:
         void *p[2] = {(void *)fn, projptr };
         plugin_register("file_in_project_ex",p);
         plugin_register("-file_in_project_ex",p);

         fn does not need to persist past the call of the function (it is copied)
         projptr must be a valid ReaProject (the default NULL=g_project semantics do not apply).
         file references are reference counted so you can add twice/remove twice etc.

      file_in_project_ex2:
         Extended syntax to receive rename notifications, or to have your plug-in request that the file go in a subdirectory:

         INT_PTR fileInProjectCallback(void *_userdata, int msg, void *parm) {
           if (msg == 0 && parm)
           {
              // rename notification, parm is (const char *)new filename
           }
           if (msg == 0x100) return (INT_PTR)"samples"; // subdirectory name, if desired (return 0 if not desired)

           if (msg == 0x101) return (INT_PTR)fxdspparentcontext_if_any; // if fx, optional
           if (msg == 0x102) return (INT_PTR)takecontext_if_any; // if pcmsrc, optional
           if (msg == 0x103) return (INT_PTR)"context/plug-in name"; // optional
           return 0;
         }

         void *p[4] = {(void *)fn, projptr, userdatacontext, fileInProjectCallback };
         plugin_register("file_in_project_ex2",p);
         plugin_register("-file_in_project_ex2",p);

      toolbar_icon_map:
         Allows a plugin to override default toolbar images for its registered commands.

         const char *GetToolbarIconName(const char *toolbar_name, int cmd, int state)
         {
           if (!strcmp(toolbarid,"Main toolbar") || !strncmp(toolbarid,"Floating toolbar",16))
             if (cmd == g_registered_command_id) return "toolbar_whatever";
           return NULL;
         }
         plugin_register("toolbar_icon_map", (void *)GetToolbarIconName);

      accelerator:
         Allows hooking the keyboard shortcut processing, see accelerator_register_t below
           static accelerator_register_t accel = { ... };
           plugin_register("accelerator",(void*)&accel);

      atexit:
         Receive a notification that REAPER is about to quit (prior to main window being destroyed).
           void on_exit(void) { }
           plugin_register("atexit",(void*)on_exit);

      ext_name:
      ext_url:
      ext_vendor:
         These can all be registered at extension load-time only in order to provide information on the
         plug-in (for purposes of the prefs view). ext_url should be a page where the user can get updates, ideally.

           plugin_register("ext_name",(void*)"MyPluginName");

      accel_section:
      action_help:
      custom_action:
      gaccel:
      hookcustommenu:
      prefpage:
      projectimport:
      projectconfig:
      editor:
      csurf:
      csurf_inst:
      toggleaction:
      on_update_hooks:
      open_file_reduce:

} reaper_plugin_info_t;
*/


