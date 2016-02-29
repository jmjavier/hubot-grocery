module.exports = (robot) ->
  robot.hear /(.*)/i, (res) ->
    if (res.message.room != 'groceries' || (res.message.room == 'groceries' && res.message.text == "get list") || (res.message.room == 'groceries' && res.message.text == "start over"))
      return false

    list = if robot.brain.get('list') then robot.brain.get('list') else []

    if (res.message.text.indexOf('@') == 0)
      formattedList = list.map (item) ->
        '- ' + item
      listString = formattedList.join("\n")
      userRoom = res.message.text.split(' ')[0].replace('@','')
      robot.send({room: userRoom}, "time to go shopping!")
      robot.send({room: userRoom}, listString)
    else
      list.push(res.match[1])
      robot.brain.set 'list', list
      formattedList = list.map (item) ->
        if (item == res.match[1])
          '- *' + item + '*'
        else
          '- ' + item
      listString = formattedList.join("\n")
      res.send "I've added it to the list! \n#{listString}\n\n"

  robot.hear /get list/i, (res) ->
    list = if robot.brain.get('list') then robot.brain.get('list') else []
    if list.length > 0
      formattedList = list.map (item) ->
        '- ' + item
      listString = formattedList.join("\n")
      response = "Here's your shopping list\n#{listString}"
    else
      response = "Your list is empty."
    res.send(response)

  robot.hear /start over/i, (res) ->
    robot.brain.set 'list', []
    res.send "shopping list deleted"