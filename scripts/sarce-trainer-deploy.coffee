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
#   hubot deploy - merges master into production to trigger a delpoy to Heroku
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
  robot.respond /deploy to ([a-zA-Z])*/i, (msg) ->
    head    = 'master'
    base    = 'production'

    msg.send "Deploying master into production"

    # github.branches(app).merge head, { base: base }, (merge) ->
    #   if merge.message
    #     msg.send merge.message
    #   else
    #     msg.send "Merged the crap out of it"