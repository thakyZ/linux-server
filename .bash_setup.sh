#!/bin/bash

if [ ! -d $HOME/.cron ]; then
  mkdir $HOME/.cron
fi

if [ -d $HOME/.cron ]; then
  # Make the crontab log directory
  mkdir "$HOME/.cron/log"

  # Make default monitor file
  echo -e "!/bin/bash\n\nexec > >(tee \$\HOME/.cron/log/${USER}-monitor.log)\nsource /etc/servers/startup.cfg\nsource \$\HOME/.cron/${USER}-servers.cfg\n\ntimestamp() {\n  date +\"%Y-%m-%d %H:%M:%S\"\n}\nexit $?\n" > $HOME/.cron/${USER}-monitor.sh
  chmod +x $HOME/.cron/${USER}-monitor.sh

  # Make default startup file
  echo -e "!/bin/bash\n\nexec > >(tee \$\HOME/.cron/log/${USER}-startup.log)\nsource /etc/servers/startup.cfg\nsource \$\HOME/.cron/${USER}-servers.cfg\n\ntimestamp() {\n  date +\"%Y-%m-%d %H:%M:%S\"\n}\nexit $?\n" > $HOME/.cron/${USER}-startup.sh
  chmod +x $HOME/.cron/${USER}-startup.sh

  (crontab -l 2>/dev/null; echo -e "MAILTO=\"admin@example.com\"\n@reboot      $HOME/.cron/${USER}-startup.sh\nMAILTO=\"\"\n*/15 * * * * $HOME/.cron/${USER}-monitor.sh\n") | crontab -

  echo -e "!/bin/bash\n\ntestVar=0\n" > $HOME/.cron/${USER}-servers.cfg

  # Done with crontab
fi

if [ ! -d $HOME/bin ]; then
  mkdir $HOME/bin
fi

if [[ $USER = *"server" ]]; then
  steamcmd=$(which steamcmd)

  if [ -z $steamcmd ]; then
    echo "This is a server account, please install steamcmd. If steamcmd is not required then ignore this message."
    read -p "Do you want to install SteamCmd locally? [Y/y]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      mkdir $HOME/steamcmd

      lastdir=$PWD

      cd $HOME/steamcmd

      echo "Downloading SteamCMD..."
      curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
      echo "Finished."

      cd $lastdir
      unset lastdir

      echo "SteamCMD is being set up currently..."
      $HOME/steamcmd/steamcmd.sh +quit 2>/dev/null
      echo "Finished."
  else
    mkdir $HOME/steamcmd

    ln -s /usr/games/steamcmd $HOME/steamcmd/steamcmd.sh

    echo "SteamCMD is being set up currently..."

    $HOME/steamcmd/steamcmd.sh +quit 2>/dev/null

    echo "Finished."

    ln -s $HOME/.steam/steamcmd/linux32 $HOME/steamcmd/linux32
  fi
fi
