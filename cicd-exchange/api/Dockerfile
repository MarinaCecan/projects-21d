FROM node:10

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

#EXPOSE 5432
EXPOSE 80

CMD npm start
