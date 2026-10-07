# ReaperLab

Play with Reaper extensions and plugins.

# Extensions

[reaper-sdk](https://github.com/justinfrankel/reaper-sdk) contains some extension examples but they are vague and/or incorrect:
```
reaper-sdk
+---reaper-plugins
|   +---reaper_csurf
|   \---reaper_mp3
\---sdk
    +---example_m3u
    \---example_raw
```

The `extensions` directory contain a working example that implements the basic API.
It doesn't do any real work but does site in the Actions menu. For real work, look at
the source behind real applications like [SWS](https://standingwaterstudios.com/index.php).

# Plugins

`plugins` contains some lua flavored plugins.
