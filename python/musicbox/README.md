# Musicbox

## Oppsett

Satt opp Raspberry Pi OS
  WiFi https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-networking
  SSH https://www.raspberrypi.com/documentation/computers/remote-access.html#enabling-the-server
    ssh-copy-id <USERNAME>@<IP-ADDRESS>

Installerte minidlna https://raspberrypi.stackexchange.com/a/118452
  Sikkert mer config: https://help.ubuntu.com/community/MiniDLNA

Lastet ned Bandcamp album
  https://github.com/easlice/bandcamp-downloader
  
Enable GPIO
  sudo usermod -a -G gpio <username>
  https://www.raspberrypi.com/documentation/computers/os.html#permissions
  
Python bibliotek for gpio
  https://gpiozero.readthedocs.io/

Python bibliotek for rfid
  https://github.com/pimylifeup/MFRC522-python
