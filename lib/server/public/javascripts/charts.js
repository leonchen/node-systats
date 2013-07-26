function createLoadChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 10*60000,
    ticks: 10
  });
};

function createCpuChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 10*60000,
    ticks: 10,
    chartOptions: {
      xaxis: {
        timeformat: "%H:%M:%S"
      }
    },
    percentage: true
  });
};

function createMemUsageChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 10*60000,
    ticks: 10,
    percentage: true
  });
}

function createMemoryChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 10*60000,
    ticks: 10,
    chartOptions: {
      yaxis: {
        tickFormatter: function (d) {return humanSize(d, 1);}
      }
    }
  });
}

function createSocketsChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 10*60000,
    ticks: 10
  });
}


function humanSize(bytes, sizeOffset) {
  sizeOffset = sizeOffset || 0;
  if (bytes == 0) return 'n/a';
  var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
  return Math.round(bytes / Math.pow(1024, i), 2) + sizes[i+sizeOffset];
}
