#!/bin/bash
set -eu

dir=$(dirname $(readlink -f "$0"))

executables=(changeomatic.sh kassomat-maintenance.sh payout-log-less.sh payout-restart.sh kassomat-set-coin-levels.py payout-log-tail.sh)
echo $executables
echo "installing payout systemd unit file"
ln -svf ${dir}/payout.service /etc/systemd/system/payout.service

echo "installing xession"
sudo -u kassomat ln -svf ${dir}/xsession ~kassomat/.xsession
chmod +x ~kassomat/.xsession

echo "installing openbox configuration"
sudo -u kassomat mkdir -p ~kassomat/.config/openbox
sudo -u kassomat ln -svf ${dir}/openbox-rc ~kassomat/.config/openbox/rc.xml

for filename in ${executables[@]}
do
  echo $filename
  name="${filename%.*}"
  ln -svf ${dir}/${filename} /usr/local/bin/${name}
  chmod +x /usr/local/bin/${name}
done
