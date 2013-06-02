
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("register", function(request, response) {
    var mailgun = require('mailgun');
    mailgun.initialize('tc.mailgun.org', 'key-4sj2w-318ym1r5dtj035yqzzqjh21f62');
     
    mailgun.sendEmail({
        to: request.params.toEmail,
        from: request.params.fromEmail,
        subject: "This is a test email!",
        text:request.params.text,
 
 
    }, {
        success: function(httpResponse) {
        console.log(httpResponse);
        response.success("Email sent!");
    },
        error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
    }
});
 
});

var twilio = require("twilio");
twilio.initialize("AC9f78c2267201422757faf2bbcb468a8e","6312489885eecb09ed3d1154145db05a");
 
// Create the Cloud Function
Parse.Cloud.define("inviteWithTwilio", function(request, response) {
  // Use the Twilio Cloud Module to send an SMS
  twilio.sendSMS({
    From: "17542640139",
    To: request.params.toNumber,
    Body: request.params.text
  }, {
    success: function(httpResponse) { response.success("SMS sent!"); },
    error: function(httpResponse) { response.error("Uh oh, something went wrong"); }
  });
});