# Stars

A Ruby on Rails API REST application to keep track of the stars that a given user has in its Github repositories.

Main endpoint receives a Github username and in the background searches user's public repositories using Github's
REST API, persisting repository name and how many stars it has.
_____________________
### Ruby version and system dependencies

* ruby -v: `3.2.1`
* rails -v: `7.0.4.2`
* database: `postgresql`
* job processor: `sidekiq`
* test handler: `rspec`

- Make sure to have server running: `rails s`
- Make sure to have Sidekiq running: `bundle exec sidekiq`
_______________________

![WorkingDemo](https://github.com/danniemag/stars/blob/main/demos/working-demo.gif)

_______________________

### Endpoint Overview

| HTTP METHOD | PATH                    | USAGE                                                                                              |
|-------------|-------------------------|----------------------------------------------------------------------------------------------------|
| GET         | /star_tracks            | Accepts an username parameter and calls a worker which will look for repository data on Github API |

### HTTP Statuses
- 200 OK: The request has succeeded
- 400 Bad Request: The informed username parameter is either invalid or incorrect
- 404 Not Found: The username is missing
_________________

# Endpoints

### GET /star_tracks
- Accepts an username parameter and calls a worker which will look for repository data on Github API.

##### Required parameters:
```json
{
  "username": "danniemag"
}
```

##### Response:

![](https://s3.sa-east-1.amazonaws.com/daniellemagalhaes.com.br/stars-img/1.png)

`STATUS: 200`
```json
{
  "success": true,
  "message": "Checking stars from user danniemag"
}
```

```text
When username is deemed valid, the endpoint calls a job which will look for repository
information on Github API. The service to sanitize and persist data is called then.
```

_________________

### Edge Cases:

- Username parameter is blank
  ![](https://s3.sa-east-1.amazonaws.com/daniellemagalhaes.com.br/stars-img/2.png)

`STATUS: 404`
```json
{
  "success": false,
  "message": "No user found"
}
```

- Abnormal username informed
  ![](https://s3.sa-east-1.amazonaws.com/daniellemagalhaes.com.br/stars-img/3.png)

`STATUS: 400`
```json
{
  "success": false,
  "message": "Abnormal username"
}
```

```text
This sanitization prevents against injections and/or undesirable characters 
(I am married to a Security guy and he made me a neurotic person :) ). 

Plus, according to Github's naming convention, usernames are allowed to contain only 
alphanumeric characters, dashes and underscores.
```

- Inexisting user

`STATUS: 200`
```json
{
  "success": true,
  "message": "Checking stars from user danniemag"
}
```

```text
This validation happens in the context of the worker since it's only possible 
to check it when the 3rd party endpoint is touched. 

So, although the endpoint returns a "success: true" message, case user does not exist,
a RestClient::NotFound is raised, returning nil and aborting the call of the service.
```

- Inexisting user

`STATUS: 200`
```json
{
  "success": true,
  "message": "Checking stars from user danniemag"
}
```

```text
This validation happens in the context of the service since it's only possible 
to check it when the 3rd party endpoint is touched. 

So, although the endpoint returns a "success: true" message, case user has no repos,
the service ends its execution earlier without persisting any data.
```
___
