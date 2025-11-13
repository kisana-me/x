FROM ruby:3.4.4
RUN apt-get update && apt-get upgrade -y
RUN gem i -v 8.0.1 rails
