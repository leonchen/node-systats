var Client = new require("../lib").Client;
var options = {
  apps: {
          redis: {
                   sensors: {
                              cpu: {
                                     interval: 1000
                                   },
                              memory: {
                                        interval: 1000
                                      },
                              socket: {
                                        interval: 1000
                                      }
                            }
                 }, 
          node: {
                  sensors: {
                             cpu: {
                                    interval: 1000
                                  },
                             memory: {
                                       interval: 1000
                                     },
                             socket: {
                                       interval: 1000
                                     }
                           }
                }
        }
};
var c = new Client(options);
c.start();
