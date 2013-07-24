// Generated by CoffeeScript 1.6.3
(function() {
  var CHECK_INTERVAL, LiveChart, REFRESH_INTERVAL, TICKS, TIME_RANGE, deepMerge, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  TIME_RANGE = 10 * 60 * 1000;

  TICKS = 10;

  REFRESH_INTERVAL = 1000;

  CHECK_INTERVAL = 5000;

  deepMerge = function() {
    var o, p, ret, _i, _len;
    ret = {};
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      o = arguments[_i];
      for (p in o) {
        if (!o.hasOwnProperty(p)) {
          continue;
        }
        if ((typeof ret[p] === 'object') && (typeof o[p] === 'object') && !(ret[p] instanceof Array) && !(o[p] instanceof Array)) {
          ret[p] = deepMerge(ret[p], o[p]);
        } else {
          ret[p] = o[p];
        }
      }
    }
    return ret;
  };

  LiveChart = (function() {
    function LiveChart(options) {
      var _ref, _ref1, _ref2, _ref3;
      this.ele = options.ele;
      this.dataUrl = options.dataUrl;
      this.checkInterval = (_ref = options.checkInterval) != null ? _ref : CHECK_INTERVAL;
      this.timeRange = (_ref1 = options.timeRange) != null ? _ref1 : TIME_RANGE;
      this.ticks = (_ref2 = options.ticks) != null ? _ref2 : TICKS;
      this.refreshInterval = (_ref3 = options.refreshInterval) != null ? _ref3 : REFRESH_INTERVAL;
      this.percentage = options.percentage;
      this.chartOptions = this.getChartOptions(options.chartOptions || {});
      this.data = [];
      this._data = {};
      this.plot = null;
      this.fetching = false;
      this.showing = false;
      if (this.dataUrl) {
        this.fetchData();
      }
      this.showData();
    }

    LiveChart.prototype.getChartOptions = function(options) {
      var defaultOptions,
        _this = this;
      defaultOptions = {
        series: {
          shadowSize: 0,
          lines: {
            show: true
          }
        },
        legend: {
          position: 'nw'
        },
        xaxis: {
          mode: "time",
          tickSize: [parseInt(this.timeRange / 1000 / this.ticks), "second"],
          timeformat: "%H:%M",
          timezone: "browser"
        }
      };
      if (this.percentage) {
        defaultOptions.yaxis = {
          min: 0,
          max: 100,
          tickFormatter: function(v) {
            return v + "%";
          }
        };
      }
      return deepMerge(defaultOptions, options);
    };

    LiveChart.prototype.getOptions = function(time) {
      return deepMerge(this.chartOptions, {
        xaxis: {
          min: time - this.timeRange,
          max: time
        }
      });
    };

    LiveChart.prototype.showData = function() {
      if (this.showing) {
        return;
      }
      this.showing = true;
      return this._showData();
    };

    LiveChart.prototype._showData = function() {
      var now,
        _this = this;
      now = Date.now();
      this.plot = this.ele.plot(this.data, this.getOptions(now)).data("plot");
      this.plot.setData(this.data);
      this.plot.setupGrid();
      this.plot.draw();
      return setTimeout(function() {
        return _this._showData();
      }, this.refreshInterval);
    };

    LiveChart.prototype.fetchData = function() {
      if (this.fetching) {
        return;
      }
      this.fetching = true;
      return this._fetchData();
    };

    LiveChart.prototype._fetchData = function() {
      var _this = this;
      $.getJSON(this.dataUrl, function(data) {
        return _this.setData(data);
      });
      return setTimeout(function() {
        return _this._fetchData();
      }, this.checkInterval);
    };

    LiveChart.prototype.setData = function(data) {
      var k, key, label, min, v, val, vals, _base, _i, _len, _ref, _ref1, _results;
      min = Date.now() - this.timeRange;
      for (key in data) {
        val = data[key];
        if ((_base = this._data)[key] == null) {
          _base[key] = [];
        }
        this._data[key].push(val);
      }
      _ref = this._data;
      for (vals = _i = 0, _len = _ref.length; _i < _len; vals = ++_i) {
        label = _ref[vals];
        while (vals[0] && vals[0][0] < min) {
          vals.shift();
        }
        if (vals.length === 0) {
          delete this._data[label];
        }
      }
      this.data = [];
      _ref1 = this._data;
      _results = [];
      for (k in _ref1) {
        v = _ref1[k];
        _results.push(this.data.push({
          data: v,
          label: k
        }));
      }
      return _results;
    };

    return LiveChart;

  })();

  root.LiveChart = LiveChart;

}).call(this);