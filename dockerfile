FROM postgres:latest

# Install jq (for processing JSON) and bash
RUN apt-get update && apt-get install -y jq bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables (if necessary)
# ENV POSTGRES_USER=your_username
# ENV POSTGRES_PASSWORD=your_password
# ENV POSTGRES_DB=your_database

# Copy initialization scripts
COPY init /docker-entrypoint-initdb.d/.

# Do NOT override CMD or ENTRYPOINT