{ 
  general = {
    reaper_freq=5;
    desiredgov="performance";
    desiredprof="performance";
    igpu_desiredgov="performance";
    igpu_power_threshold=0.3;
    softrealtime="auto"; 
    renice=20;
    ioprio=0;
    inhibit_screensaver=1;
    disable_splitlock=1;
  };
  cpu = {
    pin_cores="yes";
  };
}
