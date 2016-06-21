module.exports = (robot) ->
  robot.on 'github_deployment_event', (deploy) ->
    robot.send "Deployment started. Status: #{deploy.statuses_url}"