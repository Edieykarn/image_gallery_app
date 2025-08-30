# Simple Rails development Dockerfile for easy testing
FROM ruby:3.2.2

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      postgresql-client \
      libpq-dev \
      nodejs \
      npm \
      imagemagick \
      libvips42 \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Create uploads directory for images
RUN mkdir -p storage

# Expose port 3000
EXPOSE 3000

# Make entrypoint executable
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]