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
#   hubot deploy <branch> to <environment> - merges master into production to trigger a delpoy to Heroku
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   maletor (original version)
#   arnlen (customized version)

module.exports = (robot) ->
  github  = require("githubot")(robot)
  app     = 'liftoff-team/sarce-trainer-admin'

  # http://rubular.com/r/vnnwHvt75L
  robot.respond /deploy ([a-zA-Z]*)\s?to ([a-zA-Z]*)/i, (msg) ->
    head    = msg.match[1] || 'master'
    base    = msg.match[2]

    msg.send "Roger! Merging #{head} to #{base}."

    github.branches(app).merge head, { base: base }, (merge) ->
      if merge.message
        msg.send merge.message
      else
        msg.send "Braches merged. Deploy should begin soon."