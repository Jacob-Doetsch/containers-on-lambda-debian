FROM node:14-buster

# Q: Why do we need this?
# A: In package.json, there is a package called aws-lambda-ric.
#    That package is the Lambda Runtime Interface Client which
#    is what interacts between the Lambda backend and our code
#    in app.js. That Runtime Interface Client is build using CMake
#    and the Debian Buster base image we are using doesn't have it
#    preinstalled. 
RUN apt update && apt install -y cmake libtool

# Q: Why do we need this?
# A: We are going to put all our code in /var/task and we will
#    need to run some commands against that code and so we want
#    to work relative to that directory to make our lives easier.
WORKDIR /var/task

# Q: What is this?
# A: We need to install the Lambda Runtime Interface Client which
#    is declared as a dependency in package.json.
ADD src/package.json /var/task/
RUN npm install

# Q: Why are these separate from from the ADD command above?
# A: The Lambda Runtime Interface Client takes a while to build
#    during the npm install above. We can leverage the layer cache
#    to prevent the npm install above having to change when we
#    tweak something minor in our codebase (app.js).
ADD src/app.js /var/task/
ADD src/entry_script.sh /var/task/

# Q: What is this?
# A: This downloads the Lambda Runtime Interface Emulator (RIE) and
#    writes it to disk. The RIE acts as a proxy to our Lambda
#    function handler in app.js, and listens for traffic on port 8080
#    and invokes our function handler when it receives a POST request.
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Q: What is this for?
# A: We need to make the entry script and the RIE binary executable.
RUN chmod +x /usr/local/bin/aws-lambda-rie
RUN chmod +x /var/task/entry_script.sh

# Q: What is this for?
# A: Whenever our Docker image is invoked, whether in Lambda or on
#    our local machine, our entry script will help us use the RIE
#    proxy when necessary (e.g., on our local machine).
ENTRYPOINT [ "/var/task/entry_script.sh" ]

# Q: What is this for?
# A: This is the default Lambda function handler. It maps to our
#    app.js file and the `handler` export.
CMD [ "app.handler" ]
