
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.afterSave("Question", function(request) {
  // Push Notifications should be fired when others do something

  // does the current user have the new highest score or streak?
  var userQuery = new Parse.Query(Parse.User);

  // query all of the users, sorted by high score or streak
  // send a notification to the user with the second highest score

  var questionNumber = request.object.get('questionNumber');
  var correct = request.object.get('answeredCorrectly');

  // identify a new high score for today!

  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios');
  
  /*
  Parse.Push.send({
    where: pushQuery, // Set our Installation query
    data: {
      alert: "Question #" + questionNumber + " answered " + (correct ? "correctly!": "incorrectly!")
    }
  }, {
    success: function() {
      // Push was successful
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
  */
});