# build environment // REACT application based on Node.js
FROM node:8-alpine as react-build 
#adds a working directory
WORKDIR /app
#copies all the app files    
COPY . ./    
RUN yarn   #yarn is the package manager used for Node.js
RUN yarn build #builds the application

# server environment // NGINX will serve the image 
FROM nginx:alpine 
#this adds the nginx.conf file from the repo into the container
COPY nginx.conf /etc/nginx/conf.d/configfile.template
ENV PORT 8080
ENV HOST 0.0.0.0
RUN sh -c "envsubst '\$PORT'  < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf"
#from the build stage - we'll copy the files into /usr/share/nginx/html
COPY --from=react-build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
