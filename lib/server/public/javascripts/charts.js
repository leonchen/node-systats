function createLoadChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 30*60000,
    ticks: 30
  });
};

function createCpuChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 5*60000,
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
    timeRange: 5*60000,
    ticks: 30,
    percentage: true
  });
}

function createMemoryChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 5*60000,
    ticks: 30
  });
}

function createSocketsChart($ele) {
  return new LiveChart({
    ele: $ele,
    timeRange: 5*60000,
    ticks: 30
  });
}
