 # Use Ubuntu as the base image
FROM ubuntu:24.04

# Expose port 5001
EXPOSE 5001

# Set the work directory
WORKDIR /usr/src/app

# Send requests to backend. THIS NEEDS TO BE PRIOR TO BUILD/INSTALL STEPS
ENV REACT_APP_BACKEND_URL=http://localhost:8080

# Copy te project files into the image
COPY . .

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install node. 16 is EOL but is specifically used for this problem set
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && apt install -y nodejs

# Verify the install. If node did not install successfully, node -v will return a non-zero exit code causing the shell to stop immediately, crash the build and docker will not save this final layer
RUN node -v && npm -v

# Install all dependencies and libraries required by package.json
RUN npm install

# Take source code and turn it into "static files", the build folder. create the folder before you serve it
RUN npm run build

# Install serve package so you can run a web server
RUN npm install -g serve

# Start the server and host the content of the build folder on port 5001
CMD ["serve", "-s", "-l", "5001", "build"]
