# Interview Task for BvTech/BetVictor

This is a ruby/sinatra and react.js combo project

## Getting Started

The project use node.js/npm and ruby/sinatra softwares/packages and Redis for caching.

### Prerequisites

For node.js/react you can download it here: https://nodejs.org/en/download/
For ruby please follow the instructions here: https://www.ruby-lang.org/en/documentation/installation/
For Redis you can download the app from here: https://redis.io/download

## The directory tree of the app
    interview_task/api
        - services
        - tests
        - utils
    interview_task/interview-task-react-app
        - public
        - src

## Running the app
For ruby rest api there is a config.yml file where you can set the url of the json file and if it is necessary you can set the proxy server's url and for caching the redis server's url. 
The app has two parts:
    1. rest api in ruby: you can run from interview_task/api folder with **ruby myapp.rb command**
    2. the frontend in react.js: you can run from interview_task/interview-task-react-app folder with **npm start interview-task-react-app** command

## Authors

* **Orsolya Kerner**
