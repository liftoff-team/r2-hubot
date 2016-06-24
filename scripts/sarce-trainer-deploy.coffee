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
#   hubot deploy <branch> to <environment> - merges master into production to trigger a deploy to Heroku
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

  robot.respond /deploy ([a-zA-Z]*)\s?to ([a-zA-Z]*)/i, (msg) ->
    head    = msg.match[1] || 'master'
    base    = msg.match[2]

    unless head is 'master' and base is 'production'
      msg.reply "I'm sorry, I actually can only deploy `master` to `production`."
      return

    msg.send "Roger! I will try to deploy `#{head}` into `#{base}`. :robot_face:"

    # ----------------------------------------
    # STEP 1: Check master build status

    msg.send "First, let me check the branch's build status."
    lastKnownMasterBuild = robot.brain.get('lastKnownMasterBuild') || process.env.CODESHIP_LAST_MASTER_BUILD

    try
      build = JSON.parse(lastKnownMasterBuild).build
    catch error
      msg.reply: "Error: #{error}"
      return

    unless build
      msg.reply "Error: I don't know the last `#{head}` build. Please push to `#{head}` to trigger a build."
      return

    console.log lastKnownMasterBuild
    console.log build

    unless build.status is 'success'
      msg.reply "Sorry, but `#{head}` is *red*. You know we *can't deploy* on red. Please fix the `#{head}` branch before trying to deploy again (Last build id: #{build.id}, status: #{build.status})"
      return

    msg.send "Good news: `#{head}` is green!"

    # ----------------------------------------
    # STEP 2: Merge master into production

    github  = require("githubot")(robot)
    app     = 'liftoff-team/sarce-trainer-admin'

    msg.send "Give me a minute to merge the `#{head}` branch into `#{base}`."

    github.branches(app).merge head, { base: base }, (merge) ->
      if merge.message
        msg.send "Here is the GitHub's API response: \"#{merge.message}\""
      else
        msg.send "Branches have been successfully merged!"

  # ----------------------------------------
  # STEP 3: Waiting for Codeship notification on build succeed

  robot.router.post '/hubot/builds/codeship', (req, res) ->
    build   = JSON.parse(req.body).build
    branch = build.branch
    status = build.status

    if branch is 'production'
      if status is 'success'
        robot.messageRoom 'ci', "And we're live! Sarce-Trainer-Admin is deployed to production! :rocket:"
      else
        robot.messageRoom 'ci', "Error! The Codeship build of the `production` branch failed. Please check it asap!"

    if branch is 'master'
      robot.brain.set('lastKnownMasterBuild', build)
      robot.messageRoom 'ci' "Updated last known build for `master` branch with this one (id: #{build.id}, status: #{build.status})."

#
# TODO (Arnaud Lenglet): activate the following with a promise
#
getLastMasterBuild = () ->
  codeshipApiKey = process.env.CODESHIP_API_KEY
  codeshipApiURL = "https://codeship.com/api/v1/projects/159694.json?api_key=#{codeshipApiKey}"

  unless codeshipApiKey
    msg.reply "Please set the CODESHIP_API_KEY"
    return

  robot.http(codeshipApiURL)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      try
        parsedBody = JSON.parse body
      catch error
        msg.reply "Grrrr, error: \"#{error}\""
        return

      builds = parsedBody.builds
      masterIsGreen = false

      for build in builds
        branch = build.branch
        status = build.status

        if branch is 'master'
          if status is 'success'
            masterIsGreen = true
          else
            msg.reply "Master is red, please fix it before trying to deploy again. Last build id: #{build['id']}, status: #{build['status']}"
            return

      unless masterIsGreen is true
        msg.reply "Master is red, please fix it before trying to deploy again."
        return

      msg.send "Master is green, continuing deployment process."