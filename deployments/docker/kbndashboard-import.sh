#!/bin/bash
#
# importing the kibana-based dashbaord

[ "$1" == "" ] || [ "$2" == "" ] || [ ! -e $2 ] && echo need the target kibana host as 1st argument, and dashboard json file to upload as 2nd argument && exit 1

host=$1
dashboard=$(cat $2)
command -v curl >/dev/null 2>&1 || { echo the required curl command is not available && exit 1 ;}

while ! curl -fsS ${host}:5605 -o /dev/null; do
  echo cannot connect to ${host}:5605, will retry in 5 sec ..
  sleep 5
done

echo -n installing kibana dashboard to ${host}:5605 .. && \
curl -fsS -o /dev/null -X POST "http://${host}:5605/api/kibana/dashboards/import?force=true" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d "$dashboard"  && \
echo done. && \
echo -n setting default index to siem_alarms .. && \
curl -fsS -o /dev/null -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: true" ${host}:5605/api/kibana/settings/defaultIndex -d '{"value": "siem_alarms"}'  && \
echo done && \
echo dashboard installed successfully.

# now for the extra siem_alarm_events idx pattern

patternfile="$(dirname $2)/idxpattern-siem_alarm_events.json"
[ ! -e "$patternfile" ] && echo "skip installing siem_alarm_events index pattern, $patternfile doesnt exist" && exit 0

echo -n "Installing index pattern siem-alarm_events from $patternfile .. "
idxpattern=$(cat $patternfile)
curl -fsS -o /dev/null -X POST "http://${host}:5605/api/saved_objects/index-pattern/siem_alarm_events" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d "$idxpattern" && \
echo done || echo "failed to install, perhaps object already exist?"
Cannot exec 'localhost': No such file or directory
