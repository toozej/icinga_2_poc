#!/bin/bash

ICINGA_HOSTNAME="icinga.lab.test"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/blahblahblah"
SLACK_CHANNEL="#icinga-poc"
SLACK_BOTNAME="icinga"

if [ "$NOTIFICATIONTYPE" = "ACKNOWLEDGEMENT" ] || [ "$NOTIFICATIONTYPE" = "DOWNTIMESTART" ] || [ "$NOTIFICATIONTYPE" = "DOWNTIMEEND" ]
then
  COLOR="#33FFE3"
#Send message to Slack
read -d '' PAYLOAD << EOF
{
  "channel": "${SLACK_CHANNEL}",
  "username": "${SLACK_BOTNAME}",
  "attachments": [
    {
      "fallback": "${NOTIFICATIONTYPE} ${HOSTSTATE}: ${HOSTDISPLAYNAME}",
      "color": "${COLOR}",
      "fields": [
        {
          "title": "${NOTIFICATIONTYPE}",
          "value": "${NOTIFICATIONCOMMENT} - ${NOTIFICATIONAUTHORNAME}"
        },
        {
          "title": "Info",
          "value": "${HOSTOUTPUT}",
          "short": false
        },
        {
          "title": "Host",
          "value": "<${ICINGA_HOSTNAME}/monitoring/host/services?host=${HOSTNAME}|${HOSTDISPLAYNAME}>",
          "short": true
        },
        {
          "title": "State",
          "value": "${HOSTSTATE}",
          "short": true
        }
      ]
    }
  ]
}
EOF
else


#Set the message icon based on ICINGA Host state
if [ "$HOSTSTATE" = "DOWN" ]
then
    COLOR="danger"
elif [ "$HOSTSTATE" = "UP" ]
then
    COLOR="good"
else
    COLOR=""
fi

#Send message to Slack
read -d '' PAYLOAD << EOF
{
  "channel": "${SLACK_CHANNEL}",
  "username": "${SLACK_BOTNAME}",
  "attachments": [
    {
      "fallback": "${HOSTSTATE}: ${HOSTDISPLAYNAME}",
      "color": "${COLOR}",
      "fields": [
        {
          "title": "Info",
          "value": "${HOSTOUTPUT}",
          "short": false
        },
        {
          "title": "Host",
          "value": "<${ICINGA_HOSTNAME}/monitoring/host/services?host=${HOSTNAME}|${HOSTDISPLAYNAME}>",
          "short": true
        },
        {
          "title": "State",
          "value": "${HOSTSTATE}",
          "short": true
        }
      ]
    }
  ]
}
EOF

fi

curl --connect-timeout 30 --max-time 60 -s -S -X POST -H 'Content-type: application/json' --data "${PAYLOAD}" "${SLACK_WEBHOOK_URL}"
