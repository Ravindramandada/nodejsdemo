# Specify a base image
# FROM node:alpine 
FROM public.ecr.aws/docker/library/node:alpine
WORKDIR /usr/app
# Install some depenendencies
COPY ./package.json ./ 
RUN npm install 
COPY ./ ./
# Default command
CMD ["npm", "start"]
EXPOSE 8000
