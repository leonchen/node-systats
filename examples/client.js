var Client = new require("../lib").Client;
var options = {
  processes:{
    postgres: {
      interval: 1000
    },
    firefox: {
      interval: 2000
    }
  }
};
var c = new Client(options);
