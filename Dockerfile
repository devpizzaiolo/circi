FROM ruby:1.9.3-p551

# Create app directory
RUN mkdir -p /app

WORKDIR /app

ENV RAILS_ENV=production
COPY . /app/
COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -qq -y build-essential nodejs npm && apt-get install -qq -y zip

RUN bundle install
RUN mkdir -p log
RUN touch $RAILS_ENV.log
RUN cp /usr/share/zoneinfo/America/Toronto /etc/localtime
#RUN bundle exec sidekiq -d -e $RAILS_ENV -C config/sidekiq.yml -L log/$RAILS_ENV.log

ENTRYPOINT ["bundle", "exec"]
EXPOSE 3000
