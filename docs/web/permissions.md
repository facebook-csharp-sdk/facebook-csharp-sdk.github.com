---
layout: default
title: Requesting Permissons
---

##Requesting Permissions with Facebook's Javascript SDK
When using the Javascript SDK built in Login just add the parameter "scope" and add a comma seperated list of the permissions that you would like to request frmo the user.

    	FB.login(function (response) {
    	    if (response.authResponse) {
                // user sucessfully logged in
    	        var accessToken = response.authResponse.accessToken;
    	    }
    	}, { scope: 'email,publish_stream,email,rsvp_event,read_stream,user_likes,user_birthday' });

##Requesting Permissions using server side Redirect
With the server side redirect just add the parameter "scope" in the url with a comma seperated list of the permissions that you are requesting.  The "response_type" parameter can also be added here.  response_type Determines whether the response data included when the redirect back to the app occurs is in URL parameters or fragments.  There are 3 options for the response_type:

       response_type=code : Response data is included as URL parameters and contains code parameter (an encrypted string unique to each login request). This is the default behaviour if this parameter is not                                                        specified. It's most useful when your server will be handling the token.
       response_type=token : Response data is included as a URL fragment and contains an access token. Desktop apps must use this setting for response_type. This is most useful when the client will be handling the token.
       response_type=code%20token : Response data is included as a URL fragment and contains both an access token and the code parameter.


            return Redirect("https://www.facebook.com/dialog/oauth?" +
                   "client_id=" + "{your app id}" +
                   "&redirect_uri=" + "{url for Facebook to send access token}" +
                   "&scope=email,publish_stream,email,rsvp_event,read_stream,user_likes,user_birthday"
                   "&response_type=token" );

If you chose response_type=token then the access token will be in the url when Facebook sends a response to the redirect_uri

            http://www.myurl.com?access_token=adlkfnaskldghiwgliawcblksdfklasdlfkjsavcbkjlasdfdk

If you did not specificy response_type or chose "code" then you need exchange code for an access token

            FacebookClient client = new FacebookClient();
            dynamic result = client.Get("oauth/access_token", new
            {
                client_id = "{app-id}",
                redirect_uri = "{redirect-uri}",
                client_secret = "{app-secret}",
                code = "{code-parameter}"
            });






{% include web-see-also.md %}