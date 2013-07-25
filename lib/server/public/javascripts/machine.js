var loadChart = new LiveChart({
  ele: $("#load"),
  timeRange: 30*60000,
  ticks: 30
});
var cpuavgChart = new LiveChart({
  ele: $("#cpuavg"),
  timeRange: 5*60000,
  ticks: 10,
  chartOptions: {
    xaxis: {
      timeformat: "%H:%M:%S"
    }
  },
  percentage: true
});
var memUsageChart = new LiveChart({
  ele: $("#memUsage"),
  timeRange: 5*60000,
  ticks: 30,
  percentage: true
});
var socksChart = new LiveChart({
  ele: $("#socks"),
  timeRange: 5*60000,
  ticks: 30
});



function show(data) {
  loadChart.setData(data.load);

  cpuavgChart.setData({avg: data.cpu.avg});
  for(var c in data.cpu) {
    if (c == "avg") continue;
    var d = {};
    d[c] = data.cpu[c]
    getCPUChart(c).setData(d);
  }

  $("#totalmem").html(humanSize(data.memory.total));
  memUsageChart.setData({usage: data.memory.usage});

  socksChart.setData(data.socket);
}

function getCPUChart(c) {
  if (!window[c+"Chart"]) {
    var $ele = $('<div id="'+c+'" class="floatLeft w400 h100"></div>');
    $("#cpus").append($ele);
    window[c+"Chart"] = new LiveChart({
      ele: $("#"+c),
      timeRange: 5*60000,
      ticks: 5,
      percentage: true
    });
  }
  return window[c+"Chart"];
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
