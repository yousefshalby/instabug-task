# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things i want to cover:

* clone project: -> git clone https://github.com/yousefshalby/instabug-task.git

* after cloning: -> cd instabug-task/

* Configuration: -> add .env fields  you will find example data in .env.example

* start project: -> docker compose -f local.yml up --build  (it will take time)
  
* Database Migration: run this command -> docker exec -it instabug-task-web-1 bash   then  ----> run : rails db:migrate  to add migration

* After running: you will find rails service,  go-lang service,  my-sql database, redis, elasticsreach 

* to try rails endpoint must stare with -> http://0.0.0.0:3000/applications/<applications_token>/chats/<chat_id>/messages
  
* to try golang endpoint must start with -> http://localhost:8080/api/v1/applications/<applications_token>/chats/<chat_id>/messages

* to check job queues task dashboard: -> http://0.0.0.0:3000/sidekiq


