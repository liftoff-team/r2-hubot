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

  hello = ['Hello!', 'Hi!', 'Nice to see you again. :smiley:']
  robot.respond /hello?|hi?/i, (res) ->
    res.reply res.random hello

  noProb = ['No problem bro.', 'No prob!', 'Forget about that. :smile:', "Errare humanum est (that's the good part of being a robot)."]
  robot.respond /sorry?|my bad?|apologize?/i, (res) ->
    res.reply res.random noProb