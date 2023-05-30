FROM ruby:3.2.2 AS rails-toolbox

# Default directory
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

WORKDIR /opt/app
COPY Gemfile* .
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rake","db:migrate"]

