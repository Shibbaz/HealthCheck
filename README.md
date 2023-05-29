# Readme

HealthCheck is an API of application to post about health mentaly and physicaly. Users can follow users and congratulate on the progress that was made or encourage to do better through comment section and likes.

Application features :
* Authentication
* Posting, deleting editing posts and messages under certain post, like/unlike feature.
* Posting images
* Following users, Recent Following users activities/individual user activities wall
* Filtering posts by cattegories
* Searching users



If you wish to build docker container. I'm guiding you through build:
* setting up ENV vars in file '.env'.
```
S3_Endpoint=http://localhost:9000 
#S3_Endpoint=http://minio:9000 If using docker uncomment it
S3_BUCKET=files
S3_User_Name=minioadmin
S3_SECRET_KEY=minioadmin
GMAIL_MAIL=
GMAIL_PASSWORD=
SECRET_TOKEN=
POSTGRES_USERNAME=
POSTGRES_PASSWORD=
# 
#DATABASE_URL=postgresql://postgresusername:@postgres:5432/project_development?encoding=utf8&pool=5&timeout=5000
DATABASE_URL=postgres://postgresusername:@localhost/project_development # If You want no dockerized
#REDIS_URL=redis://redis:6379/1
REDIS_URL=redis://localhost:6379/1 # If you want no dockerized
REDIS_HOST=redis # must be equal to the name of the redis service in docker-compose.yml
REDIS_PORT=6379

```
* To connect database
  * Replace **postgresusername** with your postgres user.
  * Replace **project** with you amazing project name.
* To send mails
  * log in to yours gmail account
  * https://myaccount.google.com/signinoptions/two-step-verification
  * apps passwords
  * generate password
  * set GMAIL_MAIL with yours email
  * set GMAIL_PASSWORD with newly generated password
* docker conpose up
