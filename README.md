### Forked for running on Raspberry Pi


```docker run -d --name="Home-Automation-Bridge" --net="host" -e SERVERIP="192.168.X.X" -e SERVERPORT="XXXX" -v /path/to/config/:/config:rw -v /etc/localtime:/etc/localtime:ro aptalca/home-automation-bridge```


- Replace the SERVERIP variable (192.168.X.X) with your server's IP
- Replace the SERVERPORT variable (XXXX) with whichever port you choose for the web gui.
- Replace the "/path/to/config" with your choice of location
- If the `-v /etc/localtime:/etc/localtime:ro` mapping causes issues, you can try `-e TZ="<timezone>"` with the timezone in the format of "America/New_York" instead

### Home Automation Bridge

Use Amazon Echo to voice control your home automation devices through http commands sent to your home automation controller or built-in direct control of the Harmony Hub and Nest.

This is a docker container for bwssystems' ha-bridge - https://github.com/bwssytems/ha-bridge

