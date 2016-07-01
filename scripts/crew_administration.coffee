# Description:
#   Help on administrative tasks
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   None
#
# Commands:
#   hubot send invoice reminder - returns the last know build status for a specific branch.
#
# Author:
#   arnlen
#

robot.respond /send invoice reminder/i, (msg) ->
  robot.messageRoom 'crew-administration', "@channel: Hi crew! Please don't forget to send your invoice to @maxlen for this month."