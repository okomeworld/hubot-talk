# Description
#   hubotとお話できます
#
# Configuration:
#   HUBOT_DOCOMO_API_KEY
#
# Commands:
#   hubot ... - <what the respond trigger does>
#
# Author:
#   okomeworld <rwmh0209@gmail.com>

PLACE       = '大阪'
STYLE       = 20
REQUEST_URL = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'

module.exports = (robot) ->
  robot.brain.data.dialogue = {}

  robot.respond /(.+)$/i, (res) ->

    params = {
      utt: res.match[0],
      nickname: res.message.user.name
      place: PLACE
      t: STYLE
    }

    room = res.message.user.room

    if dialogue_data = robot.brain.data.dialogue[room]
      params.context = dialogue_data.context

    res
      .http(REQUEST_URL)
      .header('Content-Type', 'application/json')
      .query({ APIKEY: process.env.HUBOT_DOCOMO_API_KEY })
      .post(JSON.stringify(params)) (err, _, body) ->
        if err?
          robot.logger.error e
          res.send 'なんか調子が良くないみたい'
        else
          data = JSON.parse(body)
          res.send data.utt
          robot.brain.data.dialogue[room] = { context: data.context }
