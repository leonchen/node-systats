function show(data) {
  if (data.load) {
    loadChart = window.loadChart || createLoadChart($("#load"));
    loadChart.setData(data.load);
  }

  if (data.cpu) {
    cpuChart = window.cpuChart || createCpuChart($("#cpus"));
    cpuChart.setData(data.cpu);
  }

  if (data.memory) {
    $("#totalmem").html(humanSize(data.memory.total));
    memUsageChart = window.memUsageChart || createMemUsageChart($("#memUsage"));
    memUsageChart.setData({usage: data.memory.usage});
  }

  if (data.socket) {
    socketsChart = window.socketsChart || createSocketsChart($("#sockets"));
    socketsChart.setData(data.socket);
  }

  if (data.apps) {
    for (var name in data.apps) {
      showAppCharts(name, data.apps[name]);
    }
  }

}

var $apps = $("#apps");
var appTemplate = $("#appTemplate").html();
function showAppCharts(name, config) {
  var key = name+"Charts";
  if (!window[key]) {
    var $app = $(appTemplate);
    $apps.append($app);
    $app.find(".appName").html(name);
    window[key] = $app;
  }
  if (config.cpu) {
    window[key].cpu = window[key].cpu || createCpuChart(window[key].find(".cpu"));
    window[key].cpu.setData({cpu:config.cpu});
  }
  if (config.memory) {
    window[key].memory = window[key].memory || createMemoryChart(window[key].find(".mem"));
    window[key].memory.setData({memory: config.memory});
  }
  if (config.socket) {
    window[key].socket = window[key].socket || createSocketsChart(window[key].find(".socket"));
    window[key].socket.setData({sockets: config.socket});
  }
}


function fetch() {
  var url = window.location.origin+"/status/"+window.machine;
  $.getJSON(url, function (data) {
    show(data);
    setTimeout(fetch, 5000);
  });
};

function humanSize(bytes) {
  if (bytes == 0) return 'n/a';
  var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
  return Math.round(bytes / Math.pow(1024, i), 2) + sizes[i];
}

fetch();
