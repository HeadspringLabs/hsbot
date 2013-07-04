# Description:
#   Let hubot tell you where to go for lunch.
#
# Commands:
#   hubot lunch me - find a place to eat
#   hubot lunch me tacos - find what you are in the mood for
#   hubot houston lunch me - find a place in Houston, too!

radius = 5
austinOffice = '10415 Morado Circle, Austin, TX 78759'
houstonOffice = '10111 Richmond Ave, Houston, TX 77042'
limit = 20
category = 'food'

yelpApiKey = "Jk8TwgtdkAhGL1-1jeVokg"

barks = [
  "How about {0}?",
  "Are you in the mood for {0}?",
  "When's the last time you had {0}?",
  "If I was not an artificial intellegence, I would eat at {0}.",
  "You should get {0}. (awwyeah)",
  "Perhaps you would like something from {0}.",
  "Have you ever tried {0}?"
]

module.exports = (robot) ->
  robot.respond /(?:(austin|houston)[- ])?lunch me([- ](.+))?/i, (msg) ->
    term = msg.match[3] or 'lunch';
    q = term: term, ywsid: yelpApiKey
    q.limit = limit
    q.location = if msg.match[1] == 'houston' then houstonOffice else austinOffice
    q.radius = radius
    q.category = category
    msg.http("http://api.yelp.com/business_review_search")
      .query(q)
      .get() (err, res, body) ->
        places = JSON.parse(body).businesses;
        if places.length == 0
          msg.send "I can't find any lunch places that are #{term}. (shrug)"
        else
          place = msg.random places
          bark = msg.random barks
          msg.send bark.replace("{0}", place.name) + " " + place.url