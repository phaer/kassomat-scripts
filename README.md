# Auxillary files and scripts for [Metalabs](https://metalab.at) [kassomat](https://metalab.at/wiki/Kassomat)

* `sudo ./install.sh`
  links all other files in this repo to their destination and sets
  them executable where needed.

* `changeomatic.sh`
  is a simple shell script to start, stop and inspect [changeomatic](https://github.com/sixtyeight/changeomatic).

* `payout.service`
  is a systemd unit file which starts and stops [payoutd](https://github.com/sixtyeight/Payout)

* `kassomat-maintenance.sh`
  opens an xterm with `kassomat-set-coin-levels.py` running. Normally
  called by an openbox key binding (escape).

* `kassomat-set-coin-levels.py`
  enables the user to inform the hardware about new coins.

* `kassomat-count-coins.py`
  ...emptys hopper, the count unit, and counts everything inside. should be manually invoked.

* `xsession`
  initializes the user session. Hides the mouse pointer, starts changeomatic and
  openbox.

* `openbox-rc.xml`
  is the default config extended by a key binding on ESC, which
  activates maintaince mode, and rules to put changeomatic and
  `kassomat-maintenance.sh` in fullscreen mode.

* `payout-log-less.sh`,
* `payout-log-tail.sh` and
* `payout-restart.sh` are just little helpers, for those of us
  who don't work with systemd on a daily basis. ;)

