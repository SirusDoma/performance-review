FROM ruby:2.7.2-alpine

# Install dependencies
RUN apk --update add --no-cache build-base git  mysql-dev  tzdata 

# Copy application to working directory
WORKDIR /performance-review-api
COPY . /performance-review-api

# Install gems (without development and test gems)
RUN bundle config set without 'development test'
RUN bundle install

# Run application at port 8000
EXPOSE 8000
ENTRYPOINT ["bundle", "exec", "puma", "-C", "config/puma.rb", "config.ru"]
