# Description:
#   Few interactions for R2
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Author:
#   arnlen

module.exports = (robot) ->
  you_welcome = ['You welcome.', 'My pleasure.', 'No problem.', 'It is an honor to help you.', 'Always a pleasure.', 'Happy to serve.']

  robot.respond /thank?|thx?/i, (res) ->
    res.reply res.random you_welcome