#!/usr/bin/env bash

BE='bundle exec'
RU='rvm'

RVM_ENVIR=/etc/profile.d/rvm.sh
#RVM_ENVIR=~/.rvm/scripts/rvm
RUBY_VERS=2.7.6

# If this is a "do more" goal, then you must convert it to Custom and be sure
# to manually disable the Beeminder API setting "goal_kyoom"
   API="https://www.beeminder.com/api/v1"
  JSON="goals/ob-mirror/datapoints.json"
  TOKEN="auth_token=${AUTH_TOKEN}"

curl -s "$API/users/yebyenw/$JSON?$TOKEN" > ob-mirror.json

 .  $RVM_ENVIR
$RU $RUBY_VERS
$BE ./obgraph.rb

# deis_token(){ cat ~/.deis/client.json |jq .token -r ; }
# curl https://deis.xyz/v2/apps/ob-mirror/builds/ -H "Authorization: token $(deis_token)"
# curl -X POST https://deis.team.hephy.rocks/v2/apps/ob-mirror/builds/ \
#   -H "Authorization: token $(deis_token)" \
#   -H "Content-Type: application/json" \
#   -d '{ "image": "kingdonb/kate-ob-book:latest", "dockerfile": "false",
#         "procfile": { "cron": "./README; sleep $((15 * 60 * 4 * 4))" } }'
