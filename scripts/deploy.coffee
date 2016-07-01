# Description:
#   Deploy Sarce Trainer Admin app
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   CODESHIP_API_KEY
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#
# Commands:
#   hubot last build status for <branch> - returns the last know build status for a specific branch.
#   hubot deploy <branch> to <environment> - merges master into production to trigger a deploy to Heroku.
#   hubot last build status for <branch> - display the last build data for the given branch.
#
# Author:
#   arnlen
#
# Process:
#   1. Check build status for Codeship project
#   2. Merge master into production: gm master --no-ff
#   3. (todo) Tag version
#
module.exports = (robot) ->

  #
  # ======================= "LAST BUILD STATUS FOR" COMMAND =======================
  #

  robot.hear /last build status for ([a-zA-Z]+)/i, (msg) ->
    branch = msg.match[1]

    unless branch is 'master'
      msg.reply "Sorry, my brain is tiny: I can only remind build for the `master` branch."
      return

    try
      build = getLastKnownMasterBuild(robot)
    catch error
      msg.reply "Error: #{error}"
      return

    if build is -1
      msg.reply "I don't know the last `#{branch}` build."
      return

    msg.reply "Last know build status for master: #{build.status}"

  #
  # ======================= "DEPLOY" COMMAND =======================
  #

  robot.respond /deploy ([a-zA-Z]*)\s?to ([a-zA-Z]*)/i, (msg) ->
    head    = msg.match[1] || 'master'
    target  = msg.match[2]

    unless head is 'master' and target is 'production'
      msg.reply "I'm sorry, I actually can only deploy `master` to `production`."
      return

    msg.send "Roger! I will try to deploy `#{head}` into `#{target}`."

    # ----------------------------------------
    # STEP 1: Check master build status

    try
      build = getLastKnownMasterBuild(robot)
    catch error
      msg.reply ":x: Error: #{error}"
      return

    if build is -1
      msg.reply ":x: Error: I don't know the last `#{head}` build. Please push to `#{head}` to trigger a build."
      return

    unless build.status is 'success'
      msg.reply ":x: Sorry, but `#{head}` is *red*. You know we *can't deploy* on red. Please fix the `#{head}` branch before trying to deploy again (Last build id: #{build.id}, status: #{build.status})"
      return

    msg.send ":white_check_mark: Good! Last build is green."

    # ----------------------------------------
    # STEP 2: Merge master into production

    app     = 'user/repo'
    github  = require("githubot")(robot)
    github.handleErrors (callback) ->
      msg.reply ":x: Error during merge process: #{callback.error.toLowerCase()}."

    github.branches(app).merge head, into: target, (mergeCommit) ->
      msg.send ":white_check_mark: the #{head} branch have been merged into #{target}!"
      msg.send "Codeship is now deploying our app. I'll post update in the #ci channel."

  # ----------------------------------------
  # STEP 3: Waiting for Codeship notification on build succeed

  robot.router.post '/hubot/builds/codeship', (req, res) ->
    try
      build = JSON.parse(req.body).build
    catch
      build = req.body.build

    branch = build.branch
    status = build.status

    if branch is 'production'
      if status is 'success'
        robot.messageRoom 'ci', ":white_check_mark: And we're live! Sarce-Trainer-Admin is deployed to production! :rocket:"
      else if status is 'testing'
        robot.messageRoom 'ci', ":warning: Sarce-Trainer-Admin app deployment to production started via Codeship."
      else if status is 'error'
        robot.messageRoom 'ci', ":x: Error! The Codeship build of the `production` branch failed. Please check it asap!"
      else
        robot.messageRoom 'ci', "New Codeship build event: #{build}"

    if branch is 'master' and status in ['success', 'error']
      robot.brain.set 'lastKnownMasterBuild', build
      robot.messageRoom 'ci', "Last known build status for `master` is now: #{build.status}."

    res.send 'OK'


#
# ======================= Private methods =======================
#

getLastKnownMasterBuild = (robot) ->
  lastKnownMasterBuild = robot.brain.get('lastKnownMasterBuild') || process.env.CODESHIP_LAST_MASTER_BUILD

  try
    build = JSON.parse(lastKnownMasterBuild).build || JSON.parse(lastKnownMasterBuild)
  catch
    build = lastKnownMasterBuild.build || lastKnownMasterBuild

  console.log build

  return -1 unless build
  return build
