ARG RVM_RUBY_VERSIONS="3.0.6"
FROM kingdonb/docker-rvm
LABEL maintainer="Kingdon Barrett <kingdon.b@nd.edu>"
ENV APPDIR="/home/${RVM_USER}/ob-mirror"
ENV SCHEMA="sqlite.schema"
ENV STATE="beegraph.sqlite"

# install 'ex' to do some manhandling of the schema file for loading
RUN apt-get update && apt-get install -y --no-install-recommends \
  vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists/*

# set the time zone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "America/New_York" > /etc/timezone
RUN unlink /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# migrate the database
RUN mkdir ${APPDIR}
WORKDIR ${APPDIR}
COPY ${SCHEMA} /tmp/
RUN touch /tmp/${SCHEMA} && ex -c '1d2|$d|x' /tmp/${SCHEMA}
RUN sqlite3 ${STATE} < /tmp/${SCHEMA}

# RVM_USER is permitted to create files and may write to $STATE
RUN chown ${RVM_USER} ${APPDIR}/${STATE} ${APPDIR}
USER ${RVM_USER}
ENV RUBY=3.0.6

# include the ruby-version and Gemfile for bundle install
ADD Gemfile Gemfile.lock .ruby-version ${APPDIR}/
RUN  bash --login -c 'bundle install'

# include the app source code
ADD --chown=rvm .   ${APPDIR}

# web.rb for default health checking on Proctype "cmd"
CMD  bundle exec ruby ./web.rb
EXPOSE 5000
