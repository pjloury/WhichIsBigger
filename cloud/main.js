
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.afterSave("Question", function(request) {
  // Our "Comment" class has a "text" key with the body of the comment itself
  var questionNumber = request.object.get('questionNumber');
  var correct = request.object.get('answeredCorrectly');

  // identify a new high score for today!

  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios');
    
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
});