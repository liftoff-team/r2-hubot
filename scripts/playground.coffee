# Description:
#   Integrate with GitHub merge API
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_USER
#
# Commands:
#   hubot merge project_name/<head> into <base> - merges the selected branches or SHA commits
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   arnlen

module.exports = (robot) ->

  # robot.respond /pomodoro (.*)/i, (res) ->
  #   command = res.match[1]
  #   status = "stopped"

  #   if command is "start"
  #     status = "running"
  #     res.reply 'Pomodoro started.'
  #   else if command is "stop"
  #     status = "stopped"
  #     res.reply 'Pomodoro stopped.'
  #   else if command is "status"
  #     res.reply "Pomodoro is #{status}"
  #   else
  #     res.reply 'You can ask me `pomodo [start|stop|status]`'

  #     url = require('url')
  #     querystring = require('querystring')

  # robot.hear /build status/i, (msg) ->
  #   data = JSON.stringify({github_token: '527465e40a753ec67f7f256f7b9cd9f8b65fe4a8'})

  #   msg.http("https://api.travis-ci.org/auth/github")
  #     .header('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36')
  #     .header('Accept', 'application/vnd.travis-ci.2+json')
  #     .header('Host', 'api.travis-ci.org')
  #     .header('Content-Type', 'application/json')
  #     .header('Content-Length', 37)
  #     .post(data) (err, res, body) ->
  #       if err
  #         msg.send err
  #         return

  #       try
  #         response = JSON.parse(body)
  #         msg.send response
  #       catch error
  #         msg.send "Woops, error: #{error}"
  #         return

    # msg.http("https://api.travis-ci.org/repos/liftoff-team/sarce-trainer-admin")
    #   .header('Accept', 'application/vnd.travis-ci.2+json')
    #   .header('User-Agent', 'MyClient/1.0.0')
    #   .header('Host', 'api.travis-ci.org')
    #   .get() (err, res, body) ->
    #     if err
    #       msg.send err
    #       return

    #     try
    #       response = JSON.parse(body)
    #     catch error
    #       msg.send "Woops, error: #{error}"
    #       return

    #     if response.last_build_status == 0
    #       msg.send "Build status for #{project}: Passing"
    #     else if response.last_build_status == 1
    #       msg.send "Build status for #{project}: Failing"
    #     else
    #       msg.send "Build status for #{project}: Unknown"