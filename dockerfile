# Use an official Ballerina runtime as a parent image
FROM ballerina/ballerina:2201.3.1

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy Ballerina project files to the working directory
COPY . .

# Compile the Ballerina project
RUN bal build

# Expose the default port that the Ballerina service listens to
EXPOSE 9090

# Command to run the Ballerina executable
CMD ["bal", "run", "target/bin/Assignment1.jar"]
