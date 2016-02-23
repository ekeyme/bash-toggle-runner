#toggle-run and status-toggle
A BASH helper script to run your app in Run-Pause-Run-Pause toggle model.

### ( ! ) ATTENTION
toggle-run and status-toggle use `getopt`, not the bash buildin `getopts` to parse options, which you can do install `getopt` or reflector the options parsing code in both 2 script.

##Why this?
I write these 2 bash script, cause I come cross a situation that I want to run a cronjob daemon every two weeks, on friday on my server basing on crontab. As show in the [crontab manual](http://man7.org/linux/man-pages/man5/crontab.5.html), there is not a direct way to solve this sityation. And a [Q.A. in serverfault](http://serverfault.com/questions/633264/cronjob-run-every-two-weeks-on-saturday-starting-on-this-saturday) solve this in a brilliant way as following:
```bash
0 19 * * 5 [[ $((10#$(date +\%W)\%2)) = 1 ]] && your app here
```

But I have many cronjobs just like this on my server, and there are some similar situations too, for another example, you might want to echo same prety mark on the even line of your output(maybe this example is not very appropriate, never mind!). Also,with the purpose of gaining more controls on my cronjob. So I write there 2 to patch my needing.

##Usage
Firstly, download this 2 scripts and put them into the executable PATH dir, then add executable permission to them, as following:
```bash
chmod +x toggle-run status-toggle.sh
```
I want to let you know that *status-toggle.sh* is the base implement and *toggle-run* is a wrapper for *status-toggle.sh*. This means you can implement your applications base on *status-toggle.sh*.

###*status-toggle.sh*
True-False-True-False toggle emulator. You can use this to toggle run your app just as following:
```bash
status-toggle.sh -a i identifer_path  # initial it
status-toggle.sh && your_app_script  #  put this on crontab or whatever
```

    Usage: 
        status-toggle.sh [-a i|ri|run] [identifer_path]
    Option:
        -a, action, default run without initial. i: initial, true first; ri, reverse initial, false first.

###*toggle-run*
An implemention basing on *status-toggle.sh*.
Run your app in Run-Pause-Run-Pause toggle model.

    Usage: 
        toggle-run [-a i|ri|run] [-p path] [your_app[+id]] [-- app args...]
    Option:
        -a, action, default run without initial. i: initial, run first; ri, reverse initial, pause in the first round.
        -p, directory to store toggle status, default is the dir your set on config.

##### 1. Change the previous config appropriately in code
```bash
# config
marker_store_path=$HOME/bin/tmp/toggle-run
status_toggle_bin=$HOME/bin/status-toggle.sh
```
##### 2. Initial(you can just omit this step)
```bash
toggle-run -a i your_app
```
##### 3. Run in loop model daemon, like in crontab
```bash
toggle-run your_app -- your_app_argvs ...
```