var Client = new require("../lib").Client;
var options = {
  apps: {
          redis: {
                   sensors: {
                              cpu: {
                                     interval: 5000
                                   },
                              memory: {
                                        interval: 5000
                                      },
                              socket: {
                                        interval: 5000
                                      }
                            }
                 }, 
          node: {
                  sensors: {
                             cpu: {
                                    interval: 5000
                                  },
                             memory: {
                                       interval: 5000
                                     },
                             socket: {
                                       interval: 5000
                                     }
                           }
                }
        },
  system: {
            cpu: true,
            load: true,
            memory: true,
            socket: true
          }
};
var c = new Client(options);
c.start();
