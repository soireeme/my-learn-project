/*
 Highcharts JS v7.2.0 (2019-09-03)

 (c) 2009-2018 Torstein Honsi

 License: www.highcharts.com/license
*/
(function (v) {
    "object" === typeof module && module.exports ? (v["default"] = v, module.exports = v) : "function" === typeof define && define.amd ? define("highcharts/highcharts-more", ["highcharts"], function (z) {
        v(z);
        v.Highcharts = z;
        return v
    }) : v("undefined" !== typeof Highcharts ? Highcharts : void 0)
})(function (v) {
    function z(a, c, l, g) {
        a.hasOwnProperty(c) || (a[c] = g.apply(null, l))
    }

    v = v ? v._modules : {};
    z(v, "parts-more/Pane.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        function l(b, e) {
            this.init(b, e)
        }

        var g = c.splat,
            k = a.CenteredSeriesMixin, b = a.extend, f = a.merge;
        b(l.prototype, {
            coll: "pane",
            init: function (b, e) {
                this.chart = e;
                this.background = [];
                e.pane.push(this);
                this.setOptions(b)
            },
            setOptions: function (b) {
                this.options = f(this.defaultOptions, this.chart.angular ? {background: {}} : void 0, b)
            },
            render: function () {
                var b = this.options, e = this.options.background, a = this.chart.renderer;
                this.group || (this.group = a.g("pane-group").attr({zIndex: b.zIndex || 0}).add());
                this.updateCenter();
                if (e) for (e = g(e), b = Math.max(e.length, this.background.length ||
                    0), a = 0; a < b; a++) e[a] && this.axis ? this.renderBackground(f(this.defaultBackgroundOptions, e[a]), a) : this.background[a] && (this.background[a] = this.background[a].destroy(), this.background.splice(a, 1))
            },
            renderBackground: function (a, e) {
                var c = "animate", f = {"class": "highcharts-pane " + (a.className || "")};
                this.chart.styledMode || b(f, {
                    fill: a.backgroundColor,
                    stroke: a.borderColor,
                    "stroke-width": a.borderWidth
                });
                this.background[e] || (this.background[e] = this.chart.renderer.path().add(this.group), c = "attr");
                this.background[e][c]({
                    d: this.axis.getPlotBandPath(a.from,
                        a.to, a)
                }).attr(f)
            },
            defaultOptions: {center: ["50%", "50%"], size: "85%", startAngle: 0},
            defaultBackgroundOptions: {
                shape: "circle",
                borderWidth: 1,
                borderColor: "#cccccc",
                backgroundColor: {
                    linearGradient: {x1: 0, y1: 0, x2: 0, y2: 1},
                    stops: [[0, "#ffffff"], [1, "#e6e6e6"]]
                },
                from: -Number.MAX_VALUE,
                innerRadius: 0,
                to: Number.MAX_VALUE,
                outerRadius: "105%"
            },
            updateCenter: function (b) {
                this.center = (b || this.axis || {}).center = k.getCenter.call(this)
            },
            update: function (b, e) {
                f(!0, this.options, b);
                f(!0, this.chart.options.pane, b);
                this.setOptions(this.options);
                this.render();
                this.chart.axes.forEach(function (b) {
                    b.pane === this && (b.pane = null, b.update({}, e))
                }, this)
            }
        });
        a.Pane = l
    });
    z(v, "parts-more/RadialAxis.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.pInt;
        c = a.addEvent;
        var g = a.Axis, k = a.extend, b = a.merge, f = a.noop, u = a.pick, e = a.Tick, p = a.wrap, q = a.correctFloat,
            x = g.prototype, m = e.prototype;
        var t = {
            getOffset: f, redraw: function () {
                this.isDirty = !1
            }, render: function () {
                this.isDirty = !1
            }, createLabelCollector: function () {
                return !1
            }, setScale: f, setCategories: f,
            setTitle: f
        };
        var y = {
            defaultRadialGaugeOptions: {
                labels: {align: "center", x: 0, y: null},
                minorGridLineWidth: 0,
                minorTickInterval: "auto",
                minorTickLength: 10,
                minorTickPosition: "inside",
                minorTickWidth: 1,
                tickLength: 10,
                tickPosition: "inside",
                tickWidth: 2,
                title: {rotation: 0},
                zIndex: 2
            },
            defaultRadialXOptions: {
                gridLineWidth: 1,
                labels: {align: null, distance: 15, x: 0, y: null, style: {textOverflow: "none"}},
                maxPadding: 0,
                minPadding: 0,
                showLastLabel: !1,
                tickLength: 0
            },
            defaultRadialYOptions: {
                gridLineInterpolation: "circle", labels: {
                    align: "right",
                    x: -3, y: -2
                }, showLastLabel: !1, title: {x: 4, text: null, rotation: 90}
            },
            setOptions: function (d) {
                d = this.options = b(this.defaultOptions, this.defaultRadialOptions, d);
                d.plotBands || (d.plotBands = []);
                a.fireEvent(this, "afterSetOptions")
            },
            getOffset: function () {
                x.getOffset.call(this);
                this.chart.axisOffset[this.side] = 0
            },
            getLinePath: function (d, n) {
                d = this.center;
                var h = this.chart, r = u(n, d[2] / 2 - this.offset);
                this.isCircular || void 0 !== n ? (n = this.chart.renderer.symbols.arc(this.left + d[0], this.top + d[1], r, r, {
                    start: this.startAngleRad,
                    end: this.endAngleRad, open: !0, innerR: 0
                }), n.xBounds = [this.left + d[0]], n.yBounds = [this.top + d[1] - r]) : (n = this.postTranslate(this.angleRad, r), n = ["M", d[0] + h.plotLeft, d[1] + h.plotTop, "L", n.x, n.y]);
                return n
            },
            setAxisTranslation: function () {
                x.setAxisTranslation.call(this);
                this.center && (this.transA = this.isCircular ? (this.endAngleRad - this.startAngleRad) / (this.max - this.min || 1) : this.center[2] / 2 / (this.max - this.min || 1), this.minPixelPadding = this.isXAxis ? this.transA * this.minPointOffset : 0)
            },
            beforeSetTickPositions: function () {
                if (this.autoConnect =
                    this.isCircular && void 0 === u(this.userMax, this.options.max) && q(this.endAngleRad - this.startAngleRad) === q(2 * Math.PI)) this.max += this.categories && 1 || this.pointRange || this.closestPointRange || 0
            },
            setAxisSize: function () {
                x.setAxisSize.call(this);
                this.isRadial && (this.pane.updateCenter(this), this.isCircular && (this.sector = this.endAngleRad - this.startAngleRad), this.len = this.width = this.height = this.center[2] * u(this.sector, 1) / 2)
            },
            getPosition: function (d, n) {
                return this.postTranslate(this.isCircular ? this.translate(d) :
                    this.angleRad, u(this.isCircular ? n : this.translate(d), this.center[2] / 2) - this.offset)
            },
            postTranslate: function (d, n) {
                var h = this.chart, r = this.center;
                d = this.startAngleRad + d;
                return {x: h.plotLeft + r[0] + Math.cos(d) * n, y: h.plotTop + r[1] + Math.sin(d) * n}
            },
            getPlotBandPath: function (d, n, h) {
                var r = this.center, w = this.startAngleRad, b = r[2] / 2,
                    e = [u(h.outerRadius, "100%"), h.innerRadius, u(h.thickness, 10)], a = Math.min(this.offset, 0),
                    c = /%$/;
                var f = this.isCircular;
                if ("polygon" === this.options.gridLineInterpolation) e = this.getPlotLinePath({value: d}).concat(this.getPlotLinePath({
                    value: n,
                    reverse: !0
                })); else {
                    d = Math.max(d, this.min);
                    n = Math.min(n, this.max);
                    f || (e[0] = this.translate(d), e[1] = this.translate(n));
                    e = e.map(function (d) {
                        c.test(d) && (d = l(d, 10) * b / 100);
                        return d
                    });
                    if ("circle" !== h.shape && f) d = w + this.translate(d), n = w + this.translate(n); else {
                        d = -Math.PI / 2;
                        n = 1.5 * Math.PI;
                        var m = !0
                    }
                    e[0] -= a;
                    e[2] -= a;
                    e = this.chart.renderer.symbols.arc(this.left + r[0], this.top + r[1], e[0], e[0], {
                        start: Math.min(d, n),
                        end: Math.max(d, n),
                        innerR: u(e[1], e[0] - e[2]),
                        open: m
                    });
                    f && (f = (n + d) / 2, a = this.left + r[0] + r[2] / 2 * Math.cos(f), e.xBounds =
                        f > -Math.PI / 2 && f < Math.PI / 2 ? [a, this.chart.plotWidth] : [0, a], e.yBounds = [this.top + r[1] + r[2] / 2 * Math.sin(f)], e.yBounds[0] += f > -Math.PI && 0 > f || f > Math.PI ? -10 : 10)
                }
                return e
            },
            getPlotLinePath: function (d) {
                var n = this, h = n.center, r = n.chart, w = d.value;
                d = d.reverse;
                var b = n.getPosition(w), e, a;
                if (n.isCircular) var f = ["M", h[0] + r.plotLeft, h[1] + r.plotTop, "L", b.x, b.y]; else "circle" === n.options.gridLineInterpolation ? (w = n.translate(w), f = n.getLinePath(0, w)) : (r.xAxis.forEach(function (d) {
                    d.pane === n.pane && (e = d)
                }), f = [], w = n.translate(w),
                    h = e.tickPositions, e.autoConnect && (h = h.concat([h[0]])), d && (h = [].concat(h).reverse()), h.forEach(function (d, h) {
                    a = e.getPosition(d, w);
                    f.push(h ? "L" : "M", a.x, a.y)
                }));
                return f
            },
            getTitlePosition: function () {
                var d = this.center, n = this.chart, h = this.options.title;
                return {
                    x: n.plotLeft + d[0] + (h.x || 0),
                    y: n.plotTop + d[1] - {high: .5, middle: .25, low: 0}[h.align] * d[2] + (h.y || 0)
                }
            },
            createLabelCollector: function () {
                var d = this;
                return function () {
                    if (d.isRadial && d.tickPositions && !0 !== d.options.labels.allowOverlap) return d.tickPositions.map(function (n) {
                        return d.ticks[n] &&
                            d.ticks[n].label
                    }).filter(function (d) {
                        return !!d
                    })
                }
            }
        };
        c(g, "init", function (d) {
            var n = this.chart, h = n.angular, r = n.polar, w = this.isXAxis, e = h && w, a, f = n.options;
            d = d.userOptions.pane || 0;
            d = this.pane = n.pane && n.pane[d];
            if ("colorAxis" === this.coll) this.isRadial = !1; else {
                if (h) {
                    if (k(this, e ? t : y), a = !w) this.defaultRadialOptions = this.defaultRadialGaugeOptions
                } else r && (k(this, y), this.defaultRadialOptions = (a = w) ? this.defaultRadialXOptions : b(this.defaultYAxisOptions, this.defaultRadialYOptions));
                h || r ? (this.isRadial = !0, n.inverted =
                    !1, f.chart.zoomType = null, this.labelCollector || (this.labelCollector = this.createLabelCollector()), this.labelCollector && n.labelCollectors.push(this.labelCollector)) : this.isRadial = !1;
                d && a && (d.axis = this);
                this.isCircular = a
            }
        });
        c(g, "afterInit", function () {
            var d = this.chart, n = this.options, h = this.pane, r = h && h.options;
            d.angular && this.isXAxis || !h || !d.angular && !d.polar || (this.angleRad = (n.angle || 0) * Math.PI / 180, this.startAngleRad = (r.startAngle - 90) * Math.PI / 180, this.endAngleRad = (u(r.endAngle, r.startAngle + 360) - 90) * Math.PI /
                180, this.offset = n.offset || 0)
        });
        c(g, "autoLabelAlign", function (d) {
            this.isRadial && (d.align = void 0, d.preventDefault())
        });
        c(g, "destroy", function () {
            if (this.chart && this.chart.labelCollectors) {
                var d = this.chart.labelCollectors.indexOf(this.labelCollector);
                0 <= d && this.chart.labelCollectors.splice(d, 1)
            }
        });
        c(e, "afterGetPosition", function (d) {
            this.axis.getPosition && k(d.pos, this.axis.getPosition(this.pos))
        });
        c(e, "afterGetLabelPosition", function (d) {
            var n = this.axis, h = this.label, r = h.getBBox(), w = n.options.labels, b = w.y,
                e = 20, f = w.align, c = (n.translate(this.pos) + n.startAngleRad + Math.PI / 2) / Math.PI * 180 % 360,
                m = Math.round(c), g = "end", t = 0 > m ? m + 360 : m, q = t, k = 0, p = 0,
                x = null === w.y ? .3 * -r.height : 0;
            if (n.isRadial) {
                var l = n.getPosition(this.pos, n.center[2] / 2 + a.relativeLength(u(w.distance, -25), n.center[2] / 2, -n.center[2] / 2));
                "auto" === w.rotation ? h.attr({rotation: c}) : null === b && (b = n.chart.renderer.fontMetrics(h.styles && h.styles.fontSize).b - r.height / 2);
                null === f && (n.isCircular ? (r.width > n.len * n.tickInterval / (n.max - n.min) && (e = 0), f = c > e && c < 180 - e ?
                    "left" : c > 180 + e && c < 360 - e ? "right" : "center") : f = "center", h.attr({align: f}));
                if ("auto" === f && 2 === n.tickPositions.length && n.isCircular) {
                    90 < t && 180 > t ? t = 180 - t : 270 < t && 360 >= t && (t = 540 - t);
                    180 < q && 360 >= q && (q = 360 - q);
                    if (n.pane.options.startAngle === m || n.pane.options.startAngle === m + 360 || n.pane.options.startAngle === m - 360) g = "start";
                    f = -90 <= m && 90 >= m || -360 <= m && -270 >= m || 270 <= m && 360 >= m ? "start" === g ? "right" : "left" : "start" === g ? "left" : "right";
                    70 < q && 110 > q && (f = "center");
                    15 > t || 180 <= t && 195 > t ? k = .3 * r.height : 15 <= t && 35 >= t ? k = "start" ===
                    g ? 0 : .75 * r.height : 195 <= t && 215 >= t ? k = "start" === g ? .75 * r.height : 0 : 35 < t && 90 >= t ? k = "start" === g ? .25 * -r.height : r.height : 215 < t && 270 >= t && (k = "start" === g ? r.height : .25 * -r.height);
                    15 > q ? p = "start" === g ? .15 * -r.height : .15 * r.height : 165 < q && 180 >= q && (p = "start" === g ? .15 * r.height : .15 * -r.height);
                    h.attr({align: f});
                    h.translate(p, k + x)
                }
                d.pos.x = l.x + w.x;
                d.pos.y = l.y + b
            }
        });
        p(m, "getMarkPath", function (d, n, h, r, w, e, b) {
            var a = this.axis;
            a.isRadial ? (d = a.getPosition(this.pos, a.center[2] / 2 + r), n = ["M", n, h, "L", d.x, d.y]) : n = d.call(this, n, h, r, w, e, b);
            return n
        })
    });
    z(v, "parts-more/AreaRangeSeries.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.defined, g = c.isArray, k = c.isNumber, b = a.pick, f = a.extend;
        c = a.seriesType;
        var u = a.seriesTypes, e = a.Series.prototype, p = a.Point.prototype;
        c("arearange", "area", {
                lineWidth: 1,
                threshold: null,
                tooltip: {pointFormat: '<span style="color:{series.color}">\u25cf</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'},
                trackByArea: !0,
                dataLabels: {
                    align: null, verticalAlign: null, xLow: 0, xHigh: 0,
                    yLow: 0, yHigh: 0
                }
            }, {
                pointArrayMap: ["low", "high"], pointValKey: "low", deferTranslatePolar: !0, toYData: function (e) {
                    return [e.low, e.high]
                }, highToXY: function (e) {
                    var b = this.chart, a = this.xAxis.postTranslate(e.rectPlotX, this.yAxis.len - e.plotHigh);
                    e.plotHighX = a.x - b.plotLeft;
                    e.plotHigh = a.y - b.plotTop;
                    e.plotLowX = e.plotX
                }, translate: function () {
                    var e = this, b = e.yAxis, a = !!e.modifyValue;
                    u.area.prototype.translate.apply(e);
                    e.points.forEach(function (f) {
                        var c = f.high, d = f.plotY;
                        f.isNull ? f.plotY = null : (f.plotLow = d, f.plotHigh = b.translate(a ?
                            e.modifyValue(c, f) : c, 0, 1, 0, 1), a && (f.yBottom = f.plotHigh))
                    });
                    this.chart.polar && this.points.forEach(function (b) {
                        e.highToXY(b);
                        b.tooltipPos = [(b.plotHighX + b.plotLowX) / 2, (b.plotHigh + b.plotLow) / 2]
                    })
                }, getGraphPath: function (e) {
                    var a = [], f = [], c, g = u.area.prototype.getGraphPath;
                    var d = this.options;
                    var n = this.chart.polar && !1 !== d.connectEnds, h = d.connectNulls, r = d.step;
                    e = e || this.points;
                    for (c = e.length; c--;) {
                        var w = e[c];
                        w.isNull || n || h || e[c + 1] && !e[c + 1].isNull || f.push({
                            plotX: w.plotX,
                            plotY: w.plotY,
                            doCurve: !1
                        });
                        var A = {
                            polarPlotY: w.polarPlotY,
                            rectPlotX: w.rectPlotX,
                            yBottom: w.yBottom,
                            plotX: b(w.plotHighX, w.plotX),
                            plotY: w.plotHigh,
                            isNull: w.isNull
                        };
                        f.push(A);
                        a.push(A);
                        w.isNull || n || h || e[c - 1] && !e[c - 1].isNull || f.push({
                            plotX: w.plotX,
                            plotY: w.plotY,
                            doCurve: !1
                        })
                    }
                    e = g.call(this, e);
                    r && (!0 === r && (r = "left"), d.step = {left: "right", center: "center", right: "left"}[r]);
                    a = g.call(this, a);
                    f = g.call(this, f);
                    d.step = r;
                    d = [].concat(e, a);
                    this.chart.polar || "M" !== f[0] || (f[0] = "L");
                    this.graphPath = d;
                    this.areaPath = e.concat(f);
                    d.isArea = !0;
                    d.xMap = e.xMap;
                    this.areaPath.xMap = e.xMap;
                    return d
                }, drawDataLabels: function () {
                    var b = this.points, a = b.length, c, k = [], p = this.options.dataLabels, d, n = this.chart.inverted;
                    if (g(p)) if (1 < p.length) {
                        var h = p[0];
                        var r = p[1]
                    } else h = p[0], r = {enabled: !1}; else h = f({}, p), h.x = p.xHigh, h.y = p.yHigh, r = f({}, p), r.x = p.xLow, r.y = p.yLow;
                    if (h.enabled || this._hasPointLabels) {
                        for (c = a; c--;) if (d = b[c]) {
                            var w = h.inside ? d.plotHigh < d.plotLow : d.plotHigh > d.plotLow;
                            d.y = d.high;
                            d._plotY = d.plotY;
                            d.plotY = d.plotHigh;
                            k[c] = d.dataLabel;
                            d.dataLabel = d.dataLabelUpper;
                            d.below = w;
                            n ? h.align || (h.align =
                                w ? "right" : "left") : h.verticalAlign || (h.verticalAlign = w ? "top" : "bottom")
                        }
                        this.options.dataLabels = h;
                        e.drawDataLabels && e.drawDataLabels.apply(this, arguments);
                        for (c = a; c--;) if (d = b[c]) d.dataLabelUpper = d.dataLabel, d.dataLabel = k[c], delete d.dataLabels, d.y = d.low, d.plotY = d._plotY
                    }
                    if (r.enabled || this._hasPointLabels) {
                        for (c = a; c--;) if (d = b[c]) w = r.inside ? d.plotHigh < d.plotLow : d.plotHigh > d.plotLow, d.below = !w, n ? r.align || (r.align = w ? "left" : "right") : r.verticalAlign || (r.verticalAlign = w ? "bottom" : "top");
                        this.options.dataLabels =
                            r;
                        e.drawDataLabels && e.drawDataLabels.apply(this, arguments)
                    }
                    if (h.enabled) for (c = a; c--;) if (d = b[c]) d.dataLabels = [d.dataLabelUpper, d.dataLabel].filter(function (d) {
                        return !!d
                    });
                    this.options.dataLabels = p
                }, alignDataLabel: function () {
                    u.column.prototype.alignDataLabel.apply(this, arguments)
                }, drawPoints: function () {
                    var b = this.points.length, f;
                    e.drawPoints.apply(this, arguments);
                    for (f = 0; f < b;) {
                        var c = this.points[f];
                        c.origProps = {
                            plotY: c.plotY,
                            plotX: c.plotX,
                            isInside: c.isInside,
                            negative: c.negative,
                            zone: c.zone,
                            y: c.y
                        };
                        c.lowerGraphic =
                            c.graphic;
                        c.graphic = c.upperGraphic;
                        c.plotY = c.plotHigh;
                        l(c.plotHighX) && (c.plotX = c.plotHighX);
                        c.y = c.high;
                        c.negative = c.high < (this.options.threshold || 0);
                        c.zone = this.zones.length && c.getZone();
                        this.chart.polar || (c.isInside = c.isTopInside = void 0 !== c.plotY && 0 <= c.plotY && c.plotY <= this.yAxis.len && 0 <= c.plotX && c.plotX <= this.xAxis.len);
                        f++
                    }
                    e.drawPoints.apply(this, arguments);
                    for (f = 0; f < b;) c = this.points[f], c.upperGraphic = c.graphic, c.graphic = c.lowerGraphic, a.extend(c, c.origProps), delete c.origProps, f++
                }, setStackedPoints: a.noop
            },
            {
                setState: function () {
                    var e = this.state, b = this.series, c = b.chart.polar;
                    l(this.plotHigh) || (this.plotHigh = b.yAxis.toPixels(this.high, !0));
                    l(this.plotLow) || (this.plotLow = this.plotY = b.yAxis.toPixels(this.low, !0));
                    b.stateMarkerGraphic && (b.lowerStateMarkerGraphic = b.stateMarkerGraphic, b.stateMarkerGraphic = b.upperStateMarkerGraphic);
                    this.graphic = this.upperGraphic;
                    this.plotY = this.plotHigh;
                    c && (this.plotX = this.plotHighX);
                    p.setState.apply(this, arguments);
                    this.state = e;
                    this.plotY = this.plotLow;
                    this.graphic = this.lowerGraphic;
                    c && (this.plotX = this.plotLowX);
                    b.stateMarkerGraphic && (b.upperStateMarkerGraphic = b.stateMarkerGraphic, b.stateMarkerGraphic = b.lowerStateMarkerGraphic, b.lowerStateMarkerGraphic = void 0);
                    p.setState.apply(this, arguments)
                }, haloPath: function () {
                    var b = this.series.chart.polar, e = [];
                    this.plotY = this.plotLow;
                    b && (this.plotX = this.plotLowX);
                    this.isInside && (e = p.haloPath.apply(this, arguments));
                    this.plotY = this.plotHigh;
                    b && (this.plotX = this.plotHighX);
                    this.isTopInside && (e = e.concat(p.haloPath.apply(this, arguments)));
                    return e
                },
                destroyElements: function () {
                    ["lowerGraphic", "upperGraphic"].forEach(function (e) {
                        this[e] && (this[e] = this[e].destroy())
                    }, this);
                    this.graphic = null;
                    return p.destroyElements.apply(this, arguments)
                }, isValid: function () {
                    return k(this.low) && k(this.high)
                }
            });
        ""
    });
    z(v, "parts-more/AreaSplineRangeSeries.js", [v["parts/Globals.js"]], function (a) {
        var c = a.seriesType;
        c("areasplinerange", "arearange", null, {getPointSpline: a.seriesTypes.spline.prototype.getPointSpline});
        ""
    });
    z(v, "parts-more/ColumnRangeSeries.js", [v["parts/Globals.js"]],
        function (a) {
            var c = a.defaultPlotOptions, l = a.merge, g = a.noop, k = a.pick, b = a.seriesType,
                f = a.seriesTypes.column.prototype;
            b("columnrange", "arearange", l(c.column, c.arearange, {
                pointRange: null,
                marker: null,
                states: {hover: {halo: !1}}
            }), {
                translate: function () {
                    var b = this, e = b.yAxis, c = b.xAxis, a = c.startAngleRad, g, l = b.chart, t = b.xAxis.isRadial,
                        y = Math.max(l.chartWidth, l.chartHeight) + 999, d;
                    f.translate.apply(b);
                    b.points.forEach(function (n) {
                        var h = n.shapeArgs, r = b.options.minPointLength;
                        n.plotHigh = d = Math.min(Math.max(-y, e.translate(n.high,
                            0, 1, 0, 1)), y);
                        n.plotLow = Math.min(Math.max(-y, n.plotY), y);
                        var w = d;
                        var f = k(n.rectPlotY, n.plotY) - d;
                        Math.abs(f) < r ? (r -= f, f += r, w -= r / 2) : 0 > f && (f *= -1, w -= f);
                        t ? (g = n.barX + a, n.shapeType = "path", n.shapeArgs = {d: b.polarArc(w + f, w, g, g + n.pointWidth)}) : (h.height = f, h.y = w, n.tooltipPos = l.inverted ? [e.len + e.pos - l.plotLeft - w - f / 2, c.len + c.pos - l.plotTop - h.x - h.width / 2, f] : [c.left - l.plotLeft + h.x + h.width / 2, e.pos - l.plotTop + w + f / 2, f])
                    })
                },
                directTouch: !0,
                trackerGroups: ["group", "dataLabelsGroup"],
                drawGraph: g,
                getSymbol: g,
                crispCol: function () {
                    return f.crispCol.apply(this,
                        arguments)
                },
                drawPoints: function () {
                    return f.drawPoints.apply(this, arguments)
                },
                drawTracker: function () {
                    return f.drawTracker.apply(this, arguments)
                },
                getColumnMetrics: function () {
                    return f.getColumnMetrics.apply(this, arguments)
                },
                pointAttribs: function () {
                    return f.pointAttribs.apply(this, arguments)
                },
                animate: function () {
                    return f.animate.apply(this, arguments)
                },
                polarArc: function () {
                    return f.polarArc.apply(this, arguments)
                },
                translate3dPoints: function () {
                    return f.translate3dPoints.apply(this, arguments)
                },
                translate3dShapes: function () {
                    return f.translate3dShapes.apply(this,
                        arguments)
                }
            }, {setState: f.pointClass.prototype.setState});
            ""
        });
    z(v, "parts-more/ColumnPyramidSeries.js", [v["parts/Globals.js"]], function (a) {
        var c = a.pick, l = a.seriesType, g = a.seriesTypes.column.prototype;
        l("columnpyramid", "column", {}, {
            translate: function () {
                var a = this, b = a.chart, f = a.options, l = a.dense = 2 > a.closestPointRange * a.xAxis.transA;
                l = a.borderWidth = c(f.borderWidth, l ? 0 : 1);
                var e = a.yAxis, p = f.threshold, q = a.translatedThreshold = e.getThreshold(p),
                    x = c(f.minPointLength, 5), m = a.getColumnMetrics(), t = m.width, y = a.barW =
                        Math.max(t, 1 + 2 * l), d = a.pointXOffset = m.offset;
                b.inverted && (q -= .5);
                f.pointPadding && (y = Math.ceil(y));
                g.translate.apply(a);
                a.points.forEach(function (n) {
                    var h = c(n.yBottom, q), r = 999 + Math.abs(h), w = Math.min(Math.max(-r, n.plotY), e.len + r);
                    r = n.plotX + d;
                    var A = y / 2, g = Math.min(w, h);
                    h = Math.max(w, h) - g;
                    n.barX = r;
                    n.pointWidth = t;
                    n.tooltipPos = b.inverted ? [e.len + e.pos - b.plotLeft - w, a.xAxis.len - r - A, h] : [r + A, w + e.pos - b.plotTop, h];
                    w = p + (n.total || n.y);
                    "percent" === f.stacking && (w = p + (0 > n.y) ? -100 : 100);
                    w = e.toPixels(w, !0);
                    var k = b.plotHeight -
                        w - (b.plotHeight - q);
                    var l = A * (g - w) / k;
                    var m = A * (g + h - w) / k;
                    k = r - l + A;
                    l = r + l + A;
                    var u = r + m + A;
                    m = r - m + A;
                    var B = g - x;
                    var C = g + h;
                    0 > n.y && (B = g, C = g + h + x);
                    b.inverted && (u = b.plotWidth - g, k = w - (b.plotWidth - q), l = A * (w - u) / k, m = A * (w - (u - h)) / k, k = r + A + l, l = k - 2 * l, u = r - m + A, m = r + m + A, B = g, C = g + h - x, 0 > n.y && (C = g + h + x));
                    n.shapeType = "path";
                    n.shapeArgs = {x: k, y: B, width: l - k, height: h, d: ["M", k, B, "L", l, B, u, C, m, C, "Z"]}
                })
            }
        });
        ""
    });
    z(v, "parts-more/GaugeSeries.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.isNumber, g = c.pInt, k = a.merge,
            b = a.pick, f = a.Series;
        c = a.seriesType;
        var u = a.TrackerMixin;
        c("gauge", "line", {
            dataLabels: {
                borderColor: "#cccccc",
                borderRadius: 3,
                borderWidth: 1,
                crop: !1,
                defer: !1,
                enabled: !0,
                verticalAlign: "top",
                y: 15,
                zIndex: 2
            }, dial: {}, pivot: {}, tooltip: {headerFormat: ""}, showInLegend: !1
        }, {
            angular: !0,
            directTouch: !0,
            drawGraph: a.noop,
            fixedBox: !0,
            forceDL: !0,
            noSharedTooltip: !0,
            trackerGroups: ["group", "dataLabelsGroup"],
            translate: function () {
                var e = this.yAxis, c = this.options, a = e.center;
                this.generatePoints();
                this.points.forEach(function (f) {
                    var p =
                            k(c.dial, f.dial), t = g(b(p.radius, "80%")) * a[2] / 200,
                        u = g(b(p.baseLength, "70%")) * t / 100, d = g(b(p.rearLength, "10%")) * t / 100,
                        n = p.baseWidth || 3, h = p.topWidth || 1, r = c.overshoot,
                        w = e.startAngleRad + e.translate(f.y, null, null, null, !0);
                    l(r) ? (r = r / 180 * Math.PI, w = Math.max(e.startAngleRad - r, Math.min(e.endAngleRad + r, w))) : !1 === c.wrap && (w = Math.max(e.startAngleRad, Math.min(e.endAngleRad, w)));
                    w = 180 * w / Math.PI;
                    f.shapeType = "path";
                    f.shapeArgs = {
                        d: p.path || ["M", -d, -n / 2, "L", u, -n / 2, t, -h / 2, t, h / 2, u, n / 2, -d, n / 2, "z"],
                        translateX: a[0],
                        translateY: a[1],
                        rotation: w
                    };
                    f.plotX = a[0];
                    f.plotY = a[1]
                })
            },
            drawPoints: function () {
                var e = this, c = e.chart, a = e.yAxis.center, f = e.pivot, g = e.options, l = g.pivot, u = c.renderer;
                e.points.forEach(function (d) {
                    var b = d.graphic, h = d.shapeArgs, r = h.d, w = k(g.dial, d.dial);
                    b ? (b.animate(h), h.d = r) : d.graphic = u[d.shapeType](h).attr({
                        rotation: h.rotation,
                        zIndex: 1
                    }).addClass("highcharts-dial").add(e.group);
                    if (!c.styledMode) d.graphic[b ? "animate" : "attr"]({
                        stroke: w.borderColor || "none",
                        "stroke-width": w.borderWidth || 0,
                        fill: w.backgroundColor || "#000000"
                    })
                });
                f ? f.animate({
                    translateX: a[0],
                    translateY: a[1]
                }) : (e.pivot = u.circle(0, 0, b(l.radius, 5)).attr({zIndex: 2}).addClass("highcharts-pivot").translate(a[0], a[1]).add(e.group), c.styledMode || e.pivot.attr({
                    "stroke-width": l.borderWidth || 0,
                    stroke: l.borderColor || "#cccccc",
                    fill: l.backgroundColor || "#000000"
                }))
            },
            animate: function (b) {
                var e = this;
                b || (e.points.forEach(function (b) {
                    var c = b.graphic;
                    c && (c.attr({rotation: 180 * e.yAxis.startAngleRad / Math.PI}), c.animate({rotation: b.shapeArgs.rotation}, e.options.animation))
                }), e.animate =
                    null)
            },
            render: function () {
                this.group = this.plotGroup("group", "series", this.visible ? "visible" : "hidden", this.options.zIndex, this.chart.seriesGroup);
                f.prototype.render.call(this);
                this.group.clip(this.chart.clipRect)
            },
            setData: function (e, c) {
                f.prototype.setData.call(this, e, !1);
                this.processData();
                this.generatePoints();
                b(c, !0) && this.chart.redraw()
            },
            hasData: function () {
                return !!this.points.length
            },
            drawTracker: u && u.drawTrackerPoint
        }, {
            setState: function (b) {
                this.state = b
            }
        });
        ""
    });
    z(v, "parts-more/BoxPlotSeries.js", [v["parts/Globals.js"]],
        function (a) {
            var c = a.noop, l = a.pick, g = a.seriesType, k = a.seriesTypes;
            g("boxplot", "column", {
                threshold: null,
                tooltip: {pointFormat: '<span style="color:{point.color}">\u25cf</span> <b> {series.name}</b><br/>Maximum: {point.high}<br/>Upper quartile: {point.q3}<br/>Median: {point.median}<br/>Lower quartile: {point.q1}<br/>Minimum: {point.low}<br/>'},
                whiskerLength: "50%",
                fillColor: "#ffffff",
                lineWidth: 1,
                medianWidth: 2,
                whiskerWidth: 2
            }, {
                pointArrayMap: ["low", "q1", "median", "q3", "high"], toYData: function (b) {
                    return [b.low,
                        b.q1, b.median, b.q3, b.high]
                }, pointValKey: "high", pointAttribs: function () {
                    return {}
                }, drawDataLabels: c, translate: function () {
                    var b = this.yAxis, c = this.pointArrayMap;
                    k.column.prototype.translate.apply(this);
                    this.points.forEach(function (a) {
                        c.forEach(function (e) {
                            null !== a[e] && (a[e + "Plot"] = b.translate(a[e], 0, 1, 0, 1))
                        })
                    })
                }, drawPoints: function () {
                    var b = this, c = b.options, a = b.chart, e = a.renderer, g, k, x, m, t, y, d = 0, n, h, r, w,
                        A = !1 !== b.doQuartiles, E, D = b.options.whiskerLength;
                    b.points.forEach(function (f) {
                        var p = f.graphic, u = p ? "animate" :
                            "attr", I = f.shapeArgs, q = {}, F = {}, G = {}, H = {}, v = f.color || b.color;
                        void 0 !== f.plotY && (n = I.width, h = Math.floor(I.x), r = h + n, w = Math.round(n / 2), g = Math.floor(A ? f.q1Plot : f.lowPlot), k = Math.floor(A ? f.q3Plot : f.lowPlot), x = Math.floor(f.highPlot), m = Math.floor(f.lowPlot), p || (f.graphic = p = e.g("point").add(b.group), f.stem = e.path().addClass("highcharts-boxplot-stem").add(p), D && (f.whiskers = e.path().addClass("highcharts-boxplot-whisker").add(p)), A && (f.box = e.path(void 0).addClass("highcharts-boxplot-box").add(p)), f.medianShape =
                            e.path(void 0).addClass("highcharts-boxplot-median").add(p)), a.styledMode || (F.stroke = f.stemColor || c.stemColor || v, F["stroke-width"] = l(f.stemWidth, c.stemWidth, c.lineWidth), F.dashstyle = f.stemDashStyle || c.stemDashStyle, f.stem.attr(F), D && (G.stroke = f.whiskerColor || c.whiskerColor || v, G["stroke-width"] = l(f.whiskerWidth, c.whiskerWidth, c.lineWidth), f.whiskers.attr(G)), A && (q.fill = f.fillColor || c.fillColor || v, q.stroke = c.lineColor || v, q["stroke-width"] = c.lineWidth || 0, f.box.attr(q)), H.stroke = f.medianColor || c.medianColor ||
                            v, H["stroke-width"] = l(f.medianWidth, c.medianWidth, c.lineWidth), f.medianShape.attr(H)), y = f.stem.strokeWidth() % 2 / 2, d = h + w + y, f.stem[u]({d: ["M", d, k, "L", d, x, "M", d, g, "L", d, m]}), A && (y = f.box.strokeWidth() % 2 / 2, g = Math.floor(g) + y, k = Math.floor(k) + y, h += y, r += y, f.box[u]({d: ["M", h, k, "L", h, g, "L", r, g, "L", r, k, "L", h, k, "z"]})), D && (y = f.whiskers.strokeWidth() % 2 / 2, x += y, m += y, E = /%$/.test(D) ? w * parseFloat(D) / 100 : D / 2, f.whiskers[u]({d: ["M", d - E, x, "L", d + E, x, "M", d - E, m, "L", d + E, m]})), t = Math.round(f.medianPlot), y = f.medianShape.strokeWidth() %
                            2 / 2, t += y, f.medianShape[u]({d: ["M", h, t, "L", r, t]}))
                    })
                }, setStackedPoints: c
            });
            ""
        });
    z(v, "parts-more/ErrorBarSeries.js", [v["parts/Globals.js"]], function (a) {
        var c = a.noop, l = a.seriesType, g = a.seriesTypes;
        l("errorbar", "boxplot", {
            color: "#000000",
            grouping: !1,
            linkedTo: ":previous",
            tooltip: {pointFormat: '<span style="color:{point.color}">\u25cf</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'},
            whiskerWidth: null
        }, {
            type: "errorbar", pointArrayMap: ["low", "high"], toYData: function (c) {
                return [c.low, c.high]
            },
            pointValKey: "high", doQuartiles: !1, drawDataLabels: g.arearange ? function () {
                var c = this.pointValKey;
                g.arearange.prototype.drawDataLabels.call(this);
                this.data.forEach(function (b) {
                    b.y = b[c]
                })
            } : c, getColumnMetrics: function () {
                return this.linkedParent && this.linkedParent.columnMetrics || g.column.prototype.getColumnMetrics.call(this)
            }
        });
        ""
    });
    z(v, "parts-more/WaterfallSeries.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.isNumber, g = c.objectEach, k = a.correctFloat, b = a.pick, f = a.arrayMin, u = a.arrayMax;
        c = a.addEvent;
        var e = a.Axis, p = a.Chart, q = a.Point, x = a.Series, m = a.StackItem, t = a.seriesType, y = a.seriesTypes;
        c(e, "afterInit", function () {
            this.isXAxis || (this.waterfallStacks = {changed: !1})
        });
        c(p, "beforeRedraw", function () {
            for (var d = this.axes, b = this.series, h = b.length; h--;) b[h].options.stacking && (d.forEach(function (d) {
                d.isXAxis || (d.waterfallStacks.changed = !0)
            }), h = 0)
        });
        c(e, "afterRender", function () {
            var d = this.options.stackLabels;
            d && d.enabled && this.waterfallStacks && this.renderWaterfallStackTotals()
        });
        e.prototype.renderWaterfallStackTotals =
            function () {
                var d = this.waterfallStacks, b = this.stackTotalGroup,
                    h = new m(this, this.options.stackLabels, !1, 0, void 0);
                this.dummyStackItem = h;
                g(d, function (d) {
                    g(d, function (d) {
                        h.total = d.stackTotal;
                        d.label && (h.label = d.label);
                        m.prototype.render.call(h, b);
                        d.label = h.label;
                        delete h.label
                    })
                });
                h.total = null
            };
        t("waterfall", "column", {
            dataLabels: {inside: !0},
            lineWidth: 1,
            lineColor: "#333333",
            dashStyle: "Dot",
            borderColor: "#333333",
            states: {hover: {lineWidthPlus: 0}}
        }, {
            pointValKey: "y", showLine: !0, generatePoints: function () {
                var d;
                y.column.prototype.generatePoints.apply(this);
                var b = 0;
                for (d = this.points.length; b < d; b++) {
                    var h = this.points[b];
                    var r = this.processedYData[b];
                    if (h.isIntermediateSum || h.isSum) h.y = k(r)
                }
            }, translate: function () {
                var d = this.options, e = this.yAxis, h, r = b(d.minPointLength, 5), c = r / 2, f = d.threshold,
                    a = d.stacking, g = e.waterfallStacks[this.stackKey];
                y.column.prototype.translate.apply(this);
                var k = h = f;
                var l = this.points;
                var p = 0;
                for (d = l.length; p < d; p++) {
                    var t = l[p];
                    var u = this.processedYData[p];
                    var m = t.shapeArgs;
                    var q = [0, u];
                    var x =
                        t.y;
                    if (a) {
                        if (g) {
                            q = g[p];
                            if ("overlap" === a) {
                                var v = q.stackState[q.stateIndex--];
                                v = 0 <= x ? v : v - x;
                                Object.hasOwnProperty.call(q, "absolutePos") && delete q.absolutePos;
                                Object.hasOwnProperty.call(q, "absoluteNeg") && delete q.absoluteNeg
                            } else 0 <= x ? (v = q.threshold + q.posTotal, q.posTotal -= x) : (v = q.threshold + q.negTotal, q.negTotal -= x, v -= x), !q.posTotal && Object.hasOwnProperty.call(q, "absolutePos") && (q.posTotal = q.absolutePos, delete q.absolutePos), !q.negTotal && Object.hasOwnProperty.call(q, "absoluteNeg") && (q.negTotal = q.absoluteNeg,
                                delete q.absoluteNeg);
                            t.isSum || (q.connectorThreshold = q.threshold + q.stackTotal);
                            e.reversed ? (u = 0 <= x ? v - x : v + x, x = v) : (u = v, x = v - x);
                            t.below = u <= b(f, 0);
                            m.y = e.translate(u, 0, 1, 0, 1);
                            m.height = Math.abs(m.y - e.translate(x, 0, 1, 0, 1))
                        }
                        if (x = e.dummyStackItem) x.x = p, x.label = g[p].label, x.setOffset(this.pointXOffset || 0, this.barW || 0, this.stackedYNeg[p], this.stackedYPos[p])
                    } else v = Math.max(k, k + x) + q[0], m.y = e.translate(v, 0, 1, 0, 1), t.isSum ? (m.y = e.translate(q[1], 0, 1, 0, 1), m.height = Math.min(e.translate(q[0], 0, 1, 0, 1), e.len) - m.y) : t.isIntermediateSum ?
                        (0 <= x ? (u = q[1] + h, x = h) : (u = h, x = q[1] + h), e.reversed && (u ^= x, x ^= u, u ^= x), m.y = e.translate(u, 0, 1, 0, 1), m.height = Math.abs(m.y - Math.min(e.translate(x, 0, 1, 0, 1), e.len)), h += q[1]) : (m.height = 0 < u ? e.translate(k, 0, 1, 0, 1) - m.y : e.translate(k, 0, 1, 0, 1) - e.translate(k - u, 0, 1, 0, 1), k += u, t.below = k < b(f, 0)), 0 > m.height && (m.y += m.height, m.height *= -1);
                    t.plotY = m.y = Math.round(m.y) - this.borderWidth % 2 / 2;
                    m.height = Math.max(Math.round(m.height), .001);
                    t.yBottom = m.y + m.height;
                    m.height <= r && !t.isNull ? (m.height = r, m.y -= c, t.plotY = m.y, t.minPointLengthOffset =
                        0 > t.y ? -c : c) : (t.isNull && (m.width = 0), t.minPointLengthOffset = 0);
                    m = t.plotY + (t.negative ? m.height : 0);
                    this.chart.inverted ? t.tooltipPos[0] = e.len - m : t.tooltipPos[1] = m
                }
            }, processData: function (d) {
                var b = this.options, h = this.yData, e = b.data, c = h.length, f = b.threshold || 0, a, g, t, l, p;
                for (p = g = a = t = l = 0; p < c; p++) {
                    var m = h[p];
                    var q = e && e[p] ? e[p] : {};
                    "sum" === m || q.isSum ? h[p] = k(g) : "intermediateSum" === m || q.isIntermediateSum ? (h[p] = k(a), a = 0) : (g += m, a += m);
                    t = Math.min(g, t);
                    l = Math.max(g, l)
                }
                x.prototype.processData.call(this, d);
                b.stacking ||
                (this.dataMin = t + f, this.dataMax = l)
            }, toYData: function (d) {
                return d.isSum ? 0 === d.x ? null : "sum" : d.isIntermediateSum ? 0 === d.x ? null : "intermediateSum" : d.y
            }, pointAttribs: function (d, b) {
                var h = this.options.upColor;
                h && !d.options.color && (d.color = 0 < d.y ? h : null);
                d = y.column.prototype.pointAttribs.call(this, d, b);
                delete d.dashstyle;
                return d
            }, getGraphPath: function () {
                return ["M", 0, 0]
            }, getCrispPath: function () {
                var d = this.data, b = this.yAxis, h = d.length, e = Math.round(this.graph.strokeWidth()) % 2 / 2,
                    c = Math.round(this.borderWidth) % 2 /
                        2, f = this.xAxis.reversed, a = this.yAxis.reversed, g = this.options.stacking, k = [], t;
                for (t = 1; t < h; t++) {
                    var p = d[t].shapeArgs;
                    var l = d[t - 1];
                    var m = d[t - 1].shapeArgs;
                    var q = b.waterfallStacks[this.stackKey];
                    var u = 0 < l.y ? -m.height : 0;
                    if (q) {
                        q = q[t - 1];
                        g ? (q = q.connectorThreshold, u = Math.round(b.translate(q, 0, 1, 0, 1) + (a ? u : 0)) - e) : u = m.y + l.minPointLengthOffset + c - e;
                        var x = ["M", m.x + (f ? 0 : m.width), u, "L", p.x + (f ? p.width : 0), u]
                    }
                    if (!g && 0 > l.y && !a || 0 < l.y && a) x[2] += m.height, x[5] += m.height;
                    k = k.concat(x)
                }
                return k
            }, drawGraph: function () {
                x.prototype.drawGraph.call(this);
                this.graph.attr({d: this.getCrispPath()})
            }, setStackedPoints: function () {
                function d(d, h, b, e) {
                    if (z) for (b; b < z; b++) u.stackState[b] += e; else u.stackState[0] = d, z = u.stackState.length;
                    u.stackState.push(u.stackState[z - 1] + h)
                }

                var b = this.options, h = this.yAxis.waterfallStacks, e = b.threshold, c = e || 0, f = c,
                    a = this.stackKey, g = this.xData, t = g.length, k, l;
                this.yAxis.usePercentage = !1;
                var p = k = l = c;
                if (this.visible || !this.chart.options.chart.ignoreHiddenSeries) {
                    h[a] || (h[a] = {});
                    a = h[a];
                    for (var m = 0; m < t; m++) {
                        var q = g[m];
                        if (!a[q] || h.changed) a[q] =
                            {
                                negTotal: 0,
                                posTotal: 0,
                                stackTotal: 0,
                                threshold: 0,
                                stateIndex: 0,
                                stackState: [],
                                label: h.changed && a[q] ? a[q].label : void 0
                            };
                        var u = a[q];
                        var x = this.yData[m];
                        0 <= x ? u.posTotal += x : u.negTotal += x;
                        var y = b.data[m];
                        q = u.absolutePos = u.posTotal;
                        var v = u.absoluteNeg = u.negTotal;
                        u.stackTotal = q + v;
                        var z = u.stackState.length;
                        y && y.isIntermediateSum ? (d(l, k, 0, l), l = k, k = e, c ^= f, f ^= c, c ^= f) : y && y.isSum ? (d(e, p, z), c = e) : (d(c, x, 0, p), y && (p += x, k += x));
                        u.stateIndex++;
                        u.threshold = c;
                        c += u.stackTotal
                    }
                    h.changed = !1
                }
            }, getExtremes: function () {
                var d = this.options.stacking;
                if (d) {
                    var b = this.yAxis;
                    b = b.waterfallStacks;
                    var h = this.stackedYNeg = [];
                    var e = this.stackedYPos = [];
                    "overlap" === d ? g(b[this.stackKey], function (d) {
                        h.push(f(d.stackState));
                        e.push(u(d.stackState))
                    }) : g(b[this.stackKey], function (d) {
                        h.push(d.negTotal + d.threshold);
                        e.push(d.posTotal + d.threshold)
                    });
                    this.dataMin = f(h);
                    this.dataMax = u(e)
                }
            }
        }, {
            getClassName: function () {
                var d = q.prototype.getClassName.call(this);
                this.isSum ? d += " highcharts-sum" : this.isIntermediateSum && (d += " highcharts-intermediate-sum");
                return d
            }, isValid: function () {
                return l(this.y) ||
                    this.isSum || this.isIntermediateSum
            }
        });
        ""
    });
    z(v, "parts-more/PolygonSeries.js", [v["parts/Globals.js"]], function (a) {
        var c = a.Series, l = a.seriesType, g = a.seriesTypes;
        l("polygon", "scatter", {
            marker: {enabled: !1, states: {hover: {enabled: !1}}},
            stickyTracking: !1,
            tooltip: {followPointer: !0, pointFormat: ""},
            trackByArea: !0
        }, {
            type: "polygon",
            getGraphPath: function () {
                for (var a = c.prototype.getGraphPath.call(this), b = a.length + 1; b--;) (b === a.length || "M" === a[b]) && 0 < b && a.splice(b, 0, "z");
                return this.areaPath = a
            },
            drawGraph: function () {
                this.options.fillColor =
                    this.color;
                g.area.prototype.drawGraph.call(this)
            },
            drawLegendSymbol: a.LegendSymbolMixin.drawRectangle,
            drawTracker: c.prototype.drawTracker,
            setStackedPoints: a.noop
        });
        ""
    });
    z(v, "parts-more/BubbleLegend.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.isNumber, g = c.objectEach;
        c = a.Series;
        var k = a.Legend, b = a.Chart, f = a.addEvent, u = a.wrap, e = a.color, p = a.numberFormat, q = a.merge,
            x = a.noop, m = a.pick, t = a.stableSort, y = a.setOptions, d = a.arrayMin, n = a.arrayMax;
        y({
            legend: {
                bubbleLegend: {
                    borderColor: void 0,
                    borderWidth: 2,
                    className: void 0,
                    color: void 0,
                    connectorClassName: void 0,
                    connectorColor: void 0,
                    connectorDistance: 60,
                    connectorWidth: 1,
                    enabled: !1,
                    labels: {
                        className: void 0,
                        allowOverlap: !1,
                        format: "",
                        formatter: void 0,
                        align: "right",
                        style: {fontSize: 10, color: void 0},
                        x: 0,
                        y: 0
                    },
                    maxSize: 60,
                    minSize: 10,
                    legendIndex: 0,
                    ranges: {value: void 0, borderColor: void 0, color: void 0, connectorColor: void 0},
                    sizeBy: "area",
                    sizeByAbsoluteValue: !1,
                    zIndex: 1,
                    zThreshold: 0
                }
            }
        });
        a.BubbleLegend = function (d, b) {
            this.init(d, b)
        };
        a.BubbleLegend.prototype =
            {
                init: function (d, b) {
                    this.options = d;
                    this.visible = !0;
                    this.chart = b.chart;
                    this.legend = b
                }, setState: x, addToLegend: function (d) {
                    d.splice(this.options.legendIndex, 0, this)
                }, drawLegendSymbol: function (d) {
                    var b = this.chart, e = this.options, h = m(d.options.itemDistance, 20), c = e.ranges;
                    var a = e.connectorDistance;
                    this.fontMetrics = b.renderer.fontMetrics(e.labels.style.fontSize.toString() + "px");
                    c && c.length && l(c[0].value) ? (t(c, function (d, b) {
                        return b.value - d.value
                    }), this.ranges = c, this.setOptions(), this.render(), b = this.getMaxLabelSize(),
                        c = this.ranges[0].radius, d = 2 * c, a = a - c + b.width, a = 0 < a ? a : 0, this.maxLabel = b, this.movementX = "left" === e.labels.align ? a : 0, this.legendItemWidth = d + a + h, this.legendItemHeight = d + this.fontMetrics.h / 2) : d.options.bubbleLegend.autoRanges = !0
                }, setOptions: function () {
                    var d = this.ranges, b = this.options, c = this.chart.series[b.seriesIndex],
                        a = this.legend.baseline, f = {"z-index": b.zIndex, "stroke-width": b.borderWidth},
                        n = {"z-index": b.zIndex, "stroke-width": b.connectorWidth}, g = this.getLabelStyles(),
                        t = c.options.marker.fillOpacity, l =
                            this.chart.styledMode;
                    d.forEach(function (h, r) {
                        l || (f.stroke = m(h.borderColor, b.borderColor, c.color), f.fill = m(h.color, b.color, 1 !== t ? e(c.color).setOpacity(t).get("rgba") : c.color), n.stroke = m(h.connectorColor, b.connectorColor, c.color));
                        d[r].radius = this.getRangeRadius(h.value);
                        d[r] = q(d[r], {center: d[0].radius - d[r].radius + a});
                        l || q(!0, d[r], {bubbleStyle: q(!1, f), connectorStyle: q(!1, n), labelStyle: g})
                    }, this)
                }, getLabelStyles: function () {
                    var d = this.options, b = {}, e = "left" === d.labels.align, c = this.legend.options.rtl;
                    g(d.labels.style, function (d, e) {
                        "color" !== e && "fontSize" !== e && "z-index" !== e && (b[e] = d)
                    });
                    return q(!1, b, {
                        "font-size": d.labels.style.fontSize,
                        fill: m(d.labels.style.color, "#000000"),
                        "z-index": d.zIndex,
                        align: c || e ? "right" : "left"
                    })
                }, getRangeRadius: function (d) {
                    var b = this.options;
                    return this.chart.series[this.options.seriesIndex].getRadius.call(this, b.ranges[b.ranges.length - 1].value, b.ranges[0].value, b.minSize, b.maxSize, d)
                }, render: function () {
                    var d = this.chart.renderer, b = this.options.zThreshold;
                    this.symbols ||
                    (this.symbols = {connectors: [], bubbleItems: [], labels: []});
                    this.legendSymbol = d.g("bubble-legend");
                    this.legendItem = d.g("bubble-legend-item");
                    this.legendSymbol.translateX = 0;
                    this.legendSymbol.translateY = 0;
                    this.ranges.forEach(function (d) {
                        d.value >= b && this.renderRange(d)
                    }, this);
                    this.legendSymbol.add(this.legendItem);
                    this.legendItem.add(this.legendGroup);
                    this.hideOverlappingLabels()
                }, renderRange: function (d) {
                    var b = this.options, e = b.labels, c = this.chart.renderer, h = this.symbols, a = h.labels,
                        f = d.center, n = Math.abs(d.radius),
                        g = b.connectorDistance, t = e.align, l = e.style.fontSize;
                    g = this.legend.options.rtl || "left" === t ? -g : g;
                    e = b.connectorWidth;
                    var p = this.ranges[0].radius, k = f - n - b.borderWidth / 2 + e / 2;
                    l = l / 2 - (this.fontMetrics.h - l) / 2;
                    var m = c.styledMode;
                    "center" === t && (g = 0, b.connectorDistance = 0, d.labelStyle.align = "center");
                    t = k + b.labels.y;
                    var u = p + g + b.labels.x;
                    h.bubbleItems.push(c.circle(p, f + ((k % 1 ? 1 : .5) - (e % 2 ? 0 : .5)), n).attr(m ? {} : d.bubbleStyle).addClass((m ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-symbol " +
                        (b.className || "")).add(this.legendSymbol));
                    h.connectors.push(c.path(c.crispLine(["M", p, k, "L", p + g, k], b.connectorWidth)).attr(m ? {} : d.connectorStyle).addClass((m ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-connectors " + (b.connectorClassName || "")).add(this.legendSymbol));
                    d = c.text(this.formatLabel(d), u, t + l).attr(m ? {} : d.labelStyle).addClass("highcharts-bubble-legend-labels " + (b.labels.className || "")).add(this.legendSymbol);
                    a.push(d);
                    d.placed = !0;
                    d.alignAttr = {x: u, y: t + l}
                },
                getMaxLabelSize: function () {
                    var d, b;
                    this.symbols.labels.forEach(function (e) {
                        b = e.getBBox(!0);
                        d = d ? b.width > d.width ? b : d : b
                    });
                    return d || {}
                }, formatLabel: function (d) {
                    var b = this.options, e = b.labels.formatter;
                    return (b = b.labels.format) ? a.format(b, d) : e ? e.call(d) : p(d.value, 1)
                }, hideOverlappingLabels: function () {
                    var d = this.chart, b = this.symbols;
                    !this.options.labels.allowOverlap && b && (d.hideOverlappingLabels(b.labels), b.labels.forEach(function (d, e) {
                        d.newOpacity ? d.newOpacity !== d.oldOpacity && b.connectors[e].show() : b.connectors[e].hide()
                    }))
                },
                getRanges: function () {
                    var b = this.legend.bubbleLegend, e = b.options.ranges, c, a = Number.MAX_VALUE,
                        f = -Number.MAX_VALUE;
                    b.chart.series.forEach(function (b) {
                        b.isBubble && !b.ignoreSeries && (c = b.zData.filter(l), c.length && (a = m(b.options.zMin, Math.min(a, Math.max(d(c), !1 === b.options.displayNegative ? b.options.zThreshold : -Number.MAX_VALUE))), f = m(b.options.zMax, Math.max(f, n(c)))))
                    });
                    var g = a === f ? [{value: f}] : [{value: a}, {value: (a + f) / 2}, {value: f, autoRanges: !0}];
                    e.length && e[0].radius && g.reverse();
                    g.forEach(function (d, b) {
                        e &&
                        e[b] && (g[b] = q(!1, e[b], d))
                    });
                    return g
                }, predictBubbleSizes: function () {
                    var d = this.chart, b = this.fontMetrics, e = d.legend.options, c = "horizontal" === e.layout,
                        a = c ? d.legend.lastLineHeight : 0, f = d.plotSizeX, n = d.plotSizeY,
                        g = d.series[this.options.seriesIndex];
                    d = Math.ceil(g.minPxSize);
                    var t = Math.ceil(g.maxPxSize);
                    g = g.options.maxSize;
                    var l = Math.min(n, f);
                    if (e.floating || !/%$/.test(g)) b = t; else if (g = parseFloat(g), b = (l + a - b.h / 2) * g / 100 / (g / 100 + 1), c && n - b >= f || !c && f - b >= n) b = t;
                    return [d, Math.ceil(b)]
                }, updateRanges: function (d, b) {
                    var e =
                        this.legend.options.bubbleLegend;
                    e.minSize = d;
                    e.maxSize = b;
                    e.ranges = this.getRanges()
                }, correctSizes: function () {
                    var d = this.legend, b = this.chart.series[this.options.seriesIndex];
                    1 < Math.abs(Math.ceil(b.maxPxSize) - this.options.maxSize) && (this.updateRanges(this.options.minSize, b.maxPxSize), d.render())
                }
            };
        f(a.Legend, "afterGetAllItems", function (d) {
            var b = this.bubbleLegend, e = this.options, c = e.bubbleLegend,
                f = this.chart.getVisibleBubbleSeriesIndex();
            b && b.ranges && b.ranges.length && (c.ranges.length && (c.autoRanges = !!c.ranges[0].autoRanges),
                this.destroyItem(b));
            0 <= f && e.enabled && c.enabled && (c.seriesIndex = f, this.bubbleLegend = new a.BubbleLegend(c, this), this.bubbleLegend.addToLegend(d.allItems))
        });
        b.prototype.getVisibleBubbleSeriesIndex = function () {
            for (var d = this.series, b = 0; b < d.length;) {
                if (d[b] && d[b].isBubble && d[b].visible && d[b].zData.length) return b;
                b++
            }
            return -1
        };
        k.prototype.getLinesHeights = function () {
            var d = this.allItems, b = [], e = d.length, c, a = 0;
            for (c = 0; c < e; c++) if (d[c].legendItemHeight && (d[c].itemHeight = d[c].legendItemHeight), d[c] === d[e - 1] ||
            d[c + 1] && d[c]._legendItemPos[1] !== d[c + 1]._legendItemPos[1]) {
                b.push({height: 0});
                var f = b[b.length - 1];
                for (a; a <= c; a++) d[a].itemHeight > f.height && (f.height = d[a].itemHeight);
                f.step = c
            }
            return b
        };
        k.prototype.retranslateItems = function (d) {
            var b, e, c, a = this.options.rtl, f = 0;
            this.allItems.forEach(function (h, n) {
                b = h.legendGroup.translateX;
                e = h._legendItemPos[1];
                if ((c = h.movementX) || a && h.ranges) c = a ? b - h.options.maxSize / 2 : b + c, h.legendGroup.attr({translateX: c});
                n > d[f].step && f++;
                h.legendGroup.attr({
                    translateY: Math.round(e +
                        d[f].height / 2)
                });
                h._legendItemPos[1] = e + d[f].height / 2
            })
        };
        f(c, "legendItemClick", function () {
            var d = this.chart, b = this.visible, e = this.chart.legend;
            e && e.bubbleLegend && (this.visible = !b, this.ignoreSeries = b, d = 0 <= d.getVisibleBubbleSeriesIndex(), e.bubbleLegend.visible !== d && (e.update({bubbleLegend: {enabled: d}}), e.bubbleLegend.visible = d), this.visible = b)
        });
        u(b.prototype, "drawChartBox", function (d, b, e) {
            var c = this.legend, a = 0 <= this.getVisibleBubbleSeriesIndex();
            if (c && c.options.enabled && c.bubbleLegend && c.options.bubbleLegend.autoRanges &&
                a) {
                var f = c.bubbleLegend.options;
                a = c.bubbleLegend.predictBubbleSizes();
                c.bubbleLegend.updateRanges(a[0], a[1]);
                f.placed || (c.group.placed = !1, c.allItems.forEach(function (d) {
                    d.legendGroup.translateY = null
                }));
                c.render();
                this.getMargins();
                this.axes.forEach(function (d) {
                    d.visible && d.render();
                    f.placed || (d.setScale(), d.updateNames(), g(d.ticks, function (d) {
                        d.isNew = !0;
                        d.isNewLabel = !0
                    }))
                });
                f.placed = !0;
                this.getMargins();
                d.call(this, b, e);
                c.bubbleLegend.correctSizes();
                c.retranslateItems(c.getLinesHeights())
            } else d.call(this,
                b, e), c && c.options.enabled && c.bubbleLegend && (c.render(), c.retranslateItems(c.getLinesHeights()))
        })
    });
    z(v, "parts-more/BubbleSeries.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.isNumber, g = c.pInt, k = a.arrayMax, b = a.arrayMin;
        c = a.Axis;
        var f = a.color, u = a.noop, e = a.pick, p = a.Point, q = a.Series, x = a.seriesType, m = a.seriesTypes;
        x("bubble", "scatter", {
            dataLabels: {
                formatter: function () {
                    return this.point.z
                }, inside: !0, verticalAlign: "middle"
            },
            animationLimit: 250,
            marker: {
                lineColor: null, lineWidth: 1,
                fillOpacity: .5, radius: null, states: {hover: {radiusPlus: 0}}, symbol: "circle"
            },
            minSize: 8,
            maxSize: "20%",
            softThreshold: !1,
            states: {hover: {halo: {size: 5}}},
            tooltip: {pointFormat: "({point.x}, {point.y}), Size: {point.z}"},
            turboThreshold: 0,
            zThreshold: 0,
            zoneAxis: "z"
        }, {
            pointArrayMap: ["y", "z"],
            parallelArrays: ["x", "y", "z"],
            trackerGroups: ["group", "dataLabelsGroup"],
            specialGroup: "group",
            bubblePadding: !0,
            zoneAxis: "z",
            directTouch: !0,
            isBubble: !0,
            pointAttribs: function (b, e) {
                var d = this.options.marker.fillOpacity;
                b = q.prototype.pointAttribs.call(this,
                    b, e);
                1 !== d && (b.fill = f(b.fill).setOpacity(d).get("rgba"));
                return b
            },
            getRadii: function (b, e, d) {
                var c = this.zData, a = this.yData, f = d.minPxSize, g = d.maxPxSize, l = [];
                var t = 0;
                for (d = c.length; t < d; t++) {
                    var p = c[t];
                    l.push(this.getRadius(b, e, f, g, p, a[t]))
                }
                this.radii = l
            },
            getRadius: function (b, e, d, c, a, f) {
                var h = this.options, n = "width" !== h.sizeBy, g = h.zThreshold, r = e - b, p = .5;
                if (null === f || null === a) return null;
                if (l(a)) {
                    h.sizeByAbsoluteValue && (a = Math.abs(a - g), r = Math.max(e - g, Math.abs(b - g)), b = 0);
                    if (a < b) return d / 2 - 1;
                    0 < r && (p = (a - b) /
                        r)
                }
                n && 0 <= p && (p = Math.sqrt(p));
                return Math.ceil(d + p * (c - d)) / 2
            },
            animate: function (b) {
                !b && this.points.length < this.options.animationLimit && (this.points.forEach(function (b) {
                    var d = b.graphic;
                    if (d && d.width) {
                        var e = {x: d.x, y: d.y, width: d.width, height: d.height};
                        d.attr({x: b.plotX, y: b.plotY, width: 1, height: 1});
                        d.animate(e, this.options.animation)
                    }
                }, this), this.animate = null)
            },
            hasData: function () {
                return !!this.processedXData.length
            },
            translate: function () {
                var b, e = this.data, d = this.radii;
                m.scatter.prototype.translate.call(this);
                for (b = e.length; b--;) {
                    var c = e[b];
                    var f = d ? d[b] : 0;
                    l(f) && f >= this.minPxSize / 2 ? (c.marker = a.extend(c.marker, {
                        radius: f,
                        width: 2 * f,
                        height: 2 * f
                    }), c.dlBox = {
                        x: c.plotX - f,
                        y: c.plotY - f,
                        width: 2 * f,
                        height: 2 * f
                    }) : c.shapeArgs = c.plotY = c.dlBox = void 0
                }
            },
            alignDataLabel: m.column.prototype.alignDataLabel,
            buildKDTree: u,
            applyZones: u
        }, {
            haloPath: function (b) {
                return p.prototype.haloPath.call(this, 0 === b ? 0 : (this.marker ? this.marker.radius || 0 : 0) + b)
            }, ttBelow: !1
        });
        c.prototype.beforePadding = function () {
            var c = this, a = this.len, d = this.chart, f =
                    0, h = a, r = this.isXAxis, p = r ? "xData" : "yData", m = this.min, u = {},
                q = Math.min(d.plotWidth, d.plotHeight), x = Number.MAX_VALUE, v = -Number.MAX_VALUE, z = this.max - m,
                B = a / z, C = [];
            this.series.forEach(function (a) {
                var f = a.options;
                !a.bubblePadding || !a.visible && d.options.chart.ignoreHiddenSeries || (c.allowZoomOutside = !0, C.push(a), r && (["minSize", "maxSize"].forEach(function (d) {
                    var b = f[d], e = /%$/.test(b);
                    b = g(b);
                    u[d] = e ? q * b / 100 : b
                }), a.minPxSize = u.minSize, a.maxPxSize = Math.max(u.maxSize, u.minSize), a = a.zData.filter(l), a.length && (x = e(f.zMin,
                    Math.min(x, Math.max(b(a), !1 === f.displayNegative ? f.zThreshold : -Number.MAX_VALUE))), v = e(f.zMax, Math.max(v, k(a))))))
            });
            C.forEach(function (d) {
                var b = d[p], e = b.length;
                r && d.getRadii(x, v, d);
                if (0 < z) for (; e--;) if (l(b[e]) && c.dataMin <= b[e] && b[e] <= c.dataMax) {
                    var a = d.radii ? d.radii[e] : 0;
                    f = Math.min((b[e] - m) * B - a, f);
                    h = Math.max((b[e] - m) * B + a, h)
                }
            });
            C.length && 0 < z && !this.isLog && (h -= a, B *= (a + Math.max(0, f) - Math.min(h, a)) / a, [["min", "userMin", f], ["max", "userMax", h]].forEach(function (d) {
                void 0 === e(c.options[d[0]], c[d[1]]) && (c[d[0]] +=
                    d[2] / B)
            }))
        };
        ""
    });
    z(v, "modules/networkgraph/integrations.js", [v["parts/Globals.js"]], function (a) {
        a.networkgraphIntegrations = {
            verlet: {
                attractiveForceFunction: function (c, a) {
                    return (a - c) / c
                }, repulsiveForceFunction: function (c, a) {
                    return (a - c) / c * (a > c ? 1 : 0)
                }, barycenter: function () {
                    var c = this.options.gravitationalConstant, a = this.barycenter.xFactor,
                        g = this.barycenter.yFactor;
                    a = (a - (this.box.left + this.box.width) / 2) * c;
                    g = (g - (this.box.top + this.box.height) / 2) * c;
                    this.nodes.forEach(function (c) {
                        c.fixedPosition || (c.plotX -=
                            a / c.mass / c.degree, c.plotY -= g / c.mass / c.degree)
                    })
                }, repulsive: function (c, a, g) {
                    a = a * this.diffTemperature / c.mass / c.degree;
                    c.fixedPosition || (c.plotX += g.x * a, c.plotY += g.y * a)
                }, attractive: function (c, a, g) {
                    var l = c.getMass(), b = -g.x * a * this.diffTemperature;
                    a = -g.y * a * this.diffTemperature;
                    c.fromNode.fixedPosition || (c.fromNode.plotX -= b * l.fromNode / c.fromNode.degree, c.fromNode.plotY -= a * l.fromNode / c.fromNode.degree);
                    c.toNode.fixedPosition || (c.toNode.plotX += b * l.toNode / c.toNode.degree, c.toNode.plotY += a * l.toNode / c.toNode.degree)
                },
                integrate: function (c, a) {
                    var g = -c.options.friction, k = c.options.maxSpeed, b = (a.plotX + a.dispX - a.prevX) * g;
                    g *= a.plotY + a.dispY - a.prevY;
                    var f = Math.abs, u = f(b) / (b || 1);
                    f = f(g) / (g || 1);
                    b = u * Math.min(k, Math.abs(b));
                    g = f * Math.min(k, Math.abs(g));
                    a.prevX = a.plotX + a.dispX;
                    a.prevY = a.plotY + a.dispY;
                    a.plotX += b;
                    a.plotY += g;
                    a.temperature = c.vectorLength({x: b, y: g})
                }, getK: function (c) {
                    return Math.pow(c.box.width * c.box.height / c.nodes.length, .5)
                }
            }, euler: {
                attractiveForceFunction: function (c, a) {
                    return c * c / a
                }, repulsiveForceFunction: function (c,
                                                     a) {
                    return a * a / c
                }, barycenter: function () {
                    var c = this.options.gravitationalConstant, a = this.barycenter.xFactor,
                        g = this.barycenter.yFactor;
                    this.nodes.forEach(function (k) {
                        if (!k.fixedPosition) {
                            var b = k.getDegree();
                            b *= 1 + b / 2;
                            k.dispX += (a - k.plotX) * c * b / k.degree;
                            k.dispY += (g - k.plotY) * c * b / k.degree
                        }
                    })
                }, repulsive: function (c, a, g, k) {
                    c.dispX += g.x / k * a / c.degree;
                    c.dispY += g.y / k * a / c.degree
                }, attractive: function (c, a, g, k) {
                    var b = c.getMass(), f = g.x / k * a;
                    a *= g.y / k;
                    c.fromNode.fixedPosition || (c.fromNode.dispX -= f * b.fromNode / c.fromNode.degree,
                        c.fromNode.dispY -= a * b.fromNode / c.fromNode.degree);
                    c.toNode.fixedPosition || (c.toNode.dispX += f * b.toNode / c.toNode.degree, c.toNode.dispY += a * b.toNode / c.toNode.degree)
                }, integrate: function (c, a) {
                    a.dispX += a.dispX * c.options.friction;
                    a.dispY += a.dispY * c.options.friction;
                    var g = a.temperature = c.vectorLength({x: a.dispX, y: a.dispY});
                    0 !== g && (a.plotX += a.dispX / g * Math.min(Math.abs(a.dispX), c.temperature), a.plotY += a.dispY / g * Math.min(Math.abs(a.dispY), c.temperature))
                }, getK: function (a) {
                    return Math.pow(a.box.width * a.box.height /
                        a.nodes.length, .3)
                }
            }
        }
    });
    z(v, "modules/networkgraph/QuadTree.js", [v["parts/Globals.js"]], function (a) {
        var c = a.QuadTreeNode = function (a) {
            this.box = a;
            this.boxSize = Math.min(a.width, a.height);
            this.nodes = [];
            this.body = this.isInternal = !1;
            this.isEmpty = !0
        };
        a.extend(c.prototype, {
            insert: function (a, k) {
                this.isInternal ? this.nodes[this.getBoxPosition(a)].insert(a, k - 1) : (this.isEmpty = !1, this.body ? k ? (this.isInternal = !0, this.divideBox(), !0 !== this.body && (this.nodes[this.getBoxPosition(this.body)].insert(this.body, k - 1), this.body =
                    !0), this.nodes[this.getBoxPosition(a)].insert(a, k - 1)) : (k = new c({
                    top: a.plotX,
                    left: a.plotY,
                    width: .1,
                    height: .1
                }), k.body = a, k.isInternal = !1, this.nodes.push(k)) : (this.isInternal = !1, this.body = a))
            }, updateMassAndCenter: function () {
                var a = 0, c = 0, b = 0;
                this.isInternal ? (this.nodes.forEach(function (f) {
                    f.isEmpty || (a += f.mass, c += f.plotX * f.mass, b += f.plotY * f.mass)
                }), c /= a, b /= a) : this.body && (a = this.body.mass, c = this.body.plotX, b = this.body.plotY);
                this.mass = a;
                this.plotX = c;
                this.plotY = b
            }, divideBox: function () {
                var a = this.box.width /
                    2, k = this.box.height / 2;
                this.nodes[0] = new c({left: this.box.left, top: this.box.top, width: a, height: k});
                this.nodes[1] = new c({left: this.box.left + a, top: this.box.top, width: a, height: k});
                this.nodes[2] = new c({left: this.box.left + a, top: this.box.top + k, width: a, height: k});
                this.nodes[3] = new c({left: this.box.left, top: this.box.top + k, width: a, height: k})
            }, getBoxPosition: function (a) {
                var c = a.plotY < this.box.top + this.box.height / 2;
                return a.plotX < this.box.left + this.box.width / 2 ? c ? 0 : 3 : c ? 1 : 2
            }
        });
        var l = a.QuadTree = function (a, k, b, f) {
            this.box =
                {left: a, top: k, width: b, height: f};
            this.maxDepth = 25;
            this.root = new c(this.box, "0");
            this.root.isInternal = !0;
            this.root.isRoot = !0;
            this.root.divideBox()
        };
        a.extend(l.prototype, {
            insertNodes: function (a) {
                a.forEach(function (a) {
                    this.root.insert(a, this.maxDepth)
                }, this)
            }, visitNodeRecursive: function (a, c, b) {
                var f;
                a || (a = this.root);
                a === this.root && c && (f = c(a));
                !1 !== f && (a.nodes.forEach(function (a) {
                    if (a.isInternal) {
                        c && (f = c(a));
                        if (!1 === f) return;
                        this.visitNodeRecursive(a, c, b)
                    } else a.body && c && c(a.body);
                    b && b(a)
                }, this), a === this.root &&
                b && b(a))
            }, calculateMassAndCenter: function () {
                this.visitNodeRecursive(null, null, function (a) {
                    a.updateMassAndCenter()
                })
            }
        })
    });
    z(v, "modules/networkgraph/layouts.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.defined, g = a.pick;
        c = a.addEvent;
        var k = a.Chart;
        a.layouts = {
            "reingold-fruchterman": function () {
            }
        };
        a.extend(a.layouts["reingold-fruchterman"].prototype, {
            init: function (b) {
                this.options = b;
                this.nodes = [];
                this.links = [];
                this.series = [];
                this.box = {x: 0, y: 0, width: 0, height: 0};
                this.setInitialRendering(!0);
                this.integration = a.networkgraphIntegrations[b.integration];
                this.attractiveForce = g(b.attractiveForce, this.integration.attractiveForceFunction);
                this.repulsiveForce = g(b.repulsiveForce, this.integration.repulsiveForceFunction);
                this.approximation = b.approximation
            }, start: function () {
                var b = this.series, a = this.options;
                this.currentStep = 0;
                this.forces = b[0] && b[0].forces || [];
                this.initialRendering && (this.initPositions(), b.forEach(function (b) {
                    b.render()
                }));
                this.setK();
                this.resetSimulation(a);
                a.enableSimulation && this.step()
            },
            step: function () {
                var b = this, c = this.series, g = this.options;
                b.currentStep++;
                "barnes-hut" === b.approximation && (b.createQuadTree(), b.quadTree.calculateMassAndCenter());
                b.forces.forEach(function (a) {
                    b[a + "Forces"](b.temperature)
                });
                b.applyLimits(b.temperature);
                b.temperature = b.coolDown(b.startTemperature, b.diffTemperature, b.currentStep);
                b.prevSystemTemperature = b.systemTemperature;
                b.systemTemperature = b.getSystemTemperature();
                g.enableSimulation && (c.forEach(function (b) {
                    b.chart && b.render()
                }), b.maxIterations-- && isFinite(b.temperature) &&
                !b.isStable() ? (b.simulation && a.win.cancelAnimationFrame(b.simulation), b.simulation = a.win.requestAnimationFrame(function () {
                    b.step()
                })) : b.simulation = !1)
            }, stop: function () {
                this.simulation && a.win.cancelAnimationFrame(this.simulation)
            }, setArea: function (b, a, c, e) {
                this.box = {left: b, top: a, width: c, height: e}
            }, setK: function () {
                this.k = this.options.linkLength || this.integration.getK(this)
            }, addElementsToCollection: function (b, a) {
                b.forEach(function (b) {
                    -1 === a.indexOf(b) && a.push(b)
                })
            }, removeElementFromCollection: function (b,
                                                      a) {
                b = a.indexOf(b);
                -1 !== b && a.splice(b, 1)
            }, clear: function () {
                this.nodes.length = 0;
                this.links.length = 0;
                this.series.length = 0;
                this.resetSimulation()
            }, resetSimulation: function () {
                this.forcedStop = !1;
                this.systemTemperature = 0;
                this.setMaxIterations();
                this.setTemperature();
                this.setDiffTemperature()
            }, setMaxIterations: function (b) {
                this.maxIterations = g(b, this.options.maxIterations)
            }, setTemperature: function () {
                this.temperature = this.startTemperature = Math.sqrt(this.nodes.length)
            }, setDiffTemperature: function () {
                this.diffTemperature =
                    this.startTemperature / (this.options.maxIterations + 1)
            }, setInitialRendering: function (b) {
                this.initialRendering = b
            }, createQuadTree: function () {
                this.quadTree = new a.QuadTree(this.box.left, this.box.top, this.box.width, this.box.height);
                this.quadTree.insertNodes(this.nodes)
            }, initPositions: function () {
                var b = this.options.initialPositions;
                a.isFunction(b) ? (b.call(this), this.nodes.forEach(function (b) {
                    l(b.prevX) || (b.prevX = b.plotX);
                    l(b.prevY) || (b.prevY = b.plotY);
                    b.dispX = 0;
                    b.dispY = 0
                })) : "circle" === b ? this.setCircularPositions() :
                    this.setRandomPositions()
            }, setCircularPositions: function () {
                function b(a) {
                    a.linksFrom.forEach(function (a) {
                        k[a.toNode.id] || (k[a.toNode.id] = !0, q.push(a.toNode), b(a.toNode))
                    })
                }

                var a = this.box, c = this.nodes, e = 2 * Math.PI / (c.length + 1), p = c.filter(function (b) {
                    return 0 === b.linksTo.length
                }), q = [], k = {}, m = this.options.initialPositionRadius;
                p.forEach(function (a) {
                    q.push(a);
                    b(a)
                });
                q.length ? c.forEach(function (b) {
                    -1 === q.indexOf(b) && q.push(b)
                }) : q = c;
                q.forEach(function (b, c) {
                    b.plotX = b.prevX = g(b.plotX, a.width / 2 + m * Math.cos(c *
                        e));
                    b.plotY = b.prevY = g(b.plotY, a.height / 2 + m * Math.sin(c * e));
                    b.dispX = 0;
                    b.dispY = 0
                })
            }, setRandomPositions: function () {
                function b(b) {
                    b = b * b / Math.PI;
                    return b -= Math.floor(b)
                }

                var a = this.box, c = this.nodes, e = c.length + 1;
                c.forEach(function (c, f) {
                    c.plotX = c.prevX = g(c.plotX, a.width * b(f));
                    c.plotY = c.prevY = g(c.plotY, a.height * b(e + f));
                    c.dispX = 0;
                    c.dispY = 0
                })
            }, force: function (b) {
                this.integration[b].apply(this, Array.prototype.slice.call(arguments, 1))
            }, barycenterForces: function () {
                this.getBarycenter();
                this.force("barycenter")
            }, getBarycenter: function () {
                var b =
                    0, a = 0, c = 0;
                this.nodes.forEach(function (e) {
                    a += e.plotX * e.mass;
                    c += e.plotY * e.mass;
                    b += e.mass
                });
                return this.barycenter = {x: a, y: c, xFactor: a / b, yFactor: c / b}
            }, barnesHutApproximation: function (b, a) {
                var c = this.getDistXY(b, a), e = this.vectorLength(c);
                if (b !== a && 0 !== e) if (a.isInternal) if (a.boxSize / e < this.options.theta && 0 !== e) {
                    var f = this.repulsiveForce(e, this.k);
                    this.force("repulsive", b, f * a.mass, c, e);
                    var g = !1
                } else g = !0; else f = this.repulsiveForce(e, this.k), this.force("repulsive", b, f * a.mass, c, e);
                return g
            }, repulsiveForces: function () {
                var b =
                    this;
                "barnes-hut" === b.approximation ? b.nodes.forEach(function (a) {
                    b.quadTree.visitNodeRecursive(null, function (c) {
                        return b.barnesHutApproximation(a, c)
                    })
                }) : b.nodes.forEach(function (a) {
                    b.nodes.forEach(function (c) {
                        if (a !== c && !a.fixedPosition) {
                            var e = b.getDistXY(a, c);
                            var f = b.vectorLength(e);
                            if (0 !== f) {
                                var g = b.repulsiveForce(f, b.k);
                                b.force("repulsive", a, g * c.mass, e, f)
                            }
                        }
                    })
                })
            }, attractiveForces: function () {
                var b = this, a, c, e;
                b.links.forEach(function (f) {
                    f.fromNode && f.toNode && (a = b.getDistXY(f.fromNode, f.toNode), c = b.vectorLength(a),
                    0 !== c && (e = b.attractiveForce(c, b.k), b.force("attractive", f, e, a, c)))
                })
            }, applyLimits: function () {
                var b = this;
                b.nodes.forEach(function (a) {
                    a.fixedPosition || (b.integration.integrate(b, a), b.applyLimitBox(a, b.box), a.dispX = 0, a.dispY = 0)
                })
            }, applyLimitBox: function (b, a) {
                var c = b.radius;
                b.plotX = Math.max(Math.min(b.plotX, a.width - c), a.left + c);
                b.plotY = Math.max(Math.min(b.plotY, a.height - c), a.top + c)
            }, coolDown: function (b, a, c) {
                return b - a * c
            }, isStable: function () {
                return .00001 > Math.abs(this.systemTemperature - this.prevSystemTemperature) ||
                    0 >= this.temperature
            }, getSystemTemperature: function () {
                return this.nodes.reduce(function (b, a) {
                    return b + a.temperature
                }, 0)
            }, vectorLength: function (b) {
                return Math.sqrt(b.x * b.x + b.y * b.y)
            }, getDistR: function (b, a) {
                b = this.getDistXY(b, a);
                return this.vectorLength(b)
            }, getDistXY: function (b, a) {
                var c = b.plotX - a.plotX;
                b = b.plotY - a.plotY;
                return {x: c, y: b, absX: Math.abs(c), absY: Math.abs(b)}
            }
        });
        c(k, "predraw", function () {
            this.graphLayoutsLookup && this.graphLayoutsLookup.forEach(function (a) {
                a.stop()
            })
        });
        c(k, "render", function () {
            function b(a) {
                a.maxIterations-- &&
                isFinite(a.temperature) && !a.isStable() && !a.options.enableSimulation && (a.beforeStep && a.beforeStep(), a.step(), g = !1, c = !0)
            }

            var c = !1;
            if (this.graphLayoutsLookup) {
                a.setAnimation(!1, this);
                for (this.graphLayoutsLookup.forEach(function (a) {
                    a.start()
                }); !g;) {
                    var g = !0;
                    this.graphLayoutsLookup.forEach(b)
                }
                c && this.series.forEach(function (a) {
                    a && a.layout && a.render()
                })
            }
        })
    });
    z(v, "modules/networkgraph/draggable-nodes.js", [v["parts/Globals.js"]], function (a) {
        var c = a.Chart, l = a.addEvent;
        a.dragNodesMixin = {
            onMouseDown: function (a,
                                   c) {
                c = this.chart.pointer.normalize(c);
                a.fixedPosition = {chartX: c.chartX, chartY: c.chartY, plotX: a.plotX, plotY: a.plotY};
                a.inDragMode = !0
            }, onMouseMove: function (a, c) {
                if (a.fixedPosition && a.inDragMode) {
                    var b = this.chart, f = b.pointer.normalize(c);
                    c = a.fixedPosition.chartX - f.chartX;
                    f = a.fixedPosition.chartY - f.chartY;
                    if (5 < Math.abs(c) || 5 < Math.abs(f)) c = a.fixedPosition.plotX - c, f = a.fixedPosition.plotY - f, b.isInsidePlot(c, f) && (a.plotX = c, a.plotY = f, a.hasDragged = !0, this.redrawHalo(a), this.layout.simulation ? this.layout.resetSimulation() :
                        (this.layout.setInitialRendering(!1), this.layout.enableSimulation ? this.layout.start() : this.layout.setMaxIterations(1), this.chart.redraw(), this.layout.setInitialRendering(!0)))
                }
            }, onMouseUp: function (a, c) {
                a.fixedPosition && a.hasDragged && (this.layout.enableSimulation ? this.layout.start() : this.chart.redraw(), a.inDragMode = a.hasDragged = !1, this.options.fixedDraggable || delete a.fixedPosition)
            }, redrawHalo: function (a) {
                a && this.halo && this.halo.attr({d: a.haloPath(this.options.states.hover.halo.size)})
            }
        };
        l(c, "load",
            function () {
                var a = this, c, b, f;
                a.container && (c = l(a.container, "mousedown", function (c) {
                    var e = a.hoverPoint;
                    e && e.series && e.series.hasDraggableNodes && e.series.options.draggable && (e.series.onMouseDown(e, c), b = l(a.container, "mousemove", function (a) {
                        return e && e.series && e.series.onMouseMove(e, a)
                    }), f = l(a.container.ownerDocument, "mouseup", function (a) {
                        b();
                        f();
                        return e && e.series && e.series.onMouseUp(e, a)
                    }))
                }));
                l(a, "destroy", function () {
                    c()
                })
            })
    });
    z(v, "parts-more/PackedBubbleSeries.js", [v["parts/Globals.js"], v["parts/Utilities.js"]],
        function (a, c) {
            var l = c.defined, g = c.isArray, k = c.isNumber;
            c = a.seriesType;
            var b = a.Series, f = a.Point, u = a.pick, e = a.addEvent, p = a.fireEvent, q = a.Chart, x = a.Color,
                m = a.layouts["reingold-fruchterman"], t = a.seriesTypes.bubble.prototype.pointClass,
                v = a.dragNodesMixin;
            a.networkgraphIntegrations.packedbubble = {
                repulsiveForceFunction: function (d, a, b, c) {
                    return Math.min(d, (b.marker.radius + c.marker.radius) / 2)
                }, barycenter: function () {
                    var d = this, a = d.options.gravitationalConstant, b = d.box, c = d.nodes, e, f;
                    c.forEach(function (h) {
                        d.options.splitSeries &&
                        !h.isParentNode ? (e = h.series.parentNode.plotX, f = h.series.parentNode.plotY) : (e = b.width / 2, f = b.height / 2);
                        h.fixedPosition || (h.plotX -= (h.plotX - e) * a / (h.mass * Math.sqrt(c.length)), h.plotY -= (h.plotY - f) * a / (h.mass * Math.sqrt(c.length)))
                    })
                }, repulsive: function (d, a, b, c) {
                    var e = a * this.diffTemperature / d.mass / d.degree;
                    a = b.x * e;
                    b = b.y * e;
                    d.fixedPosition || (d.plotX += a, d.plotY += b);
                    c.fixedPosition || (c.plotX -= a, c.plotY -= b)
                }, integrate: a.networkgraphIntegrations.verlet.integrate, getK: a.noop
            };
            a.layouts.packedbubble = a.extendClass(m,
                {
                    beforeStep: function () {
                        this.options.marker && this.series.forEach(function (d) {
                            d && d.calculateParentRadius()
                        })
                    }, setCircularPositions: function () {
                        var d = this, a = d.box, b = d.nodes, c = 2 * Math.PI / (b.length + 1), e, f,
                            g = d.options.initialPositionRadius;
                        b.forEach(function (b, h) {
                            d.options.splitSeries && !b.isParentNode ? (e = b.series.parentNode.plotX, f = b.series.parentNode.plotY) : (e = a.width / 2, f = a.height / 2);
                            b.plotX = b.prevX = u(b.plotX, e + g * Math.cos(b.index || h * c));
                            b.plotY = b.prevY = u(b.plotY, f + g * Math.sin(b.index || h * c));
                            b.dispX = 0;
                            b.dispY =
                                0
                        })
                    }, repulsiveForces: function () {
                        var d = this, a, b, c, e = d.options.bubblePadding;
                        d.nodes.forEach(function (f) {
                            f.degree = f.mass;
                            f.neighbours = 0;
                            d.nodes.forEach(function (h) {
                                a = 0;
                                f === h || f.fixedPosition || !d.options.seriesInteraction && f.series !== h.series || (c = d.getDistXY(f, h), b = d.vectorLength(c) - (f.marker.radius + h.marker.radius + e), 0 > b && (f.degree += .01, f.neighbours++, a = d.repulsiveForce(-b / Math.sqrt(f.neighbours), d.k, f, h)), d.force("repulsive", f, a * h.mass, c, h, b))
                            })
                        })
                    }, applyLimitBox: function (a) {
                        if (this.options.splitSeries &&
                            !a.isParentNode && this.options.parentNodeLimit) {
                            var d = this.getDistXY(a, a.series.parentNode);
                            var b = a.series.parentNodeRadius - a.marker.radius - this.vectorLength(d);
                            0 > b && b > -2 * a.marker.radius && (a.plotX -= .01 * d.x, a.plotY -= .01 * d.y)
                        }
                        m.prototype.applyLimitBox.apply(this, arguments)
                    }, isStable: function () {
                        return .00001 > Math.abs(this.systemTemperature - this.prevSystemTemperature) || 0 >= this.temperature || 0 < this.systemTemperature && .02 > this.systemTemperature / this.nodes.length && this.enableSimulation
                    }
                });
            c("packedbubble",
                "bubble", {
                    minSize: "10%",
                    maxSize: "50%",
                    sizeBy: "area",
                    zoneAxis: "y",
                    tooltip: {pointFormat: "Value: {point.value}"},
                    draggable: !0,
                    useSimulation: !0,
                    dataLabels: {
                        formatter: function () {
                            return this.point.value
                        }, parentNodeFormatter: function () {
                            return this.name
                        }, parentNodeTextPath: {enabled: !0}, padding: 0
                    },
                    layoutAlgorithm: {
                        initialPositions: "circle",
                        initialPositionRadius: 20,
                        bubblePadding: 5,
                        parentNodeLimit: !1,
                        seriesInteraction: !0,
                        dragBetweenSeries: !1,
                        parentNodeOptions: {
                            maxIterations: 400,
                            gravitationalConstant: .03,
                            maxSpeed: 50,
                            initialPositionRadius: 100,
                            seriesInteraction: !0,
                            marker: {fillColor: null, fillOpacity: 1, lineWidth: 1, lineColor: null, symbol: "circle"}
                        },
                        enableSimulation: !0,
                        type: "packedbubble",
                        integration: "packedbubble",
                        maxIterations: 1E3,
                        splitSeries: !1,
                        maxSpeed: 5,
                        gravitationalConstant: .01,
                        friction: -.981
                    }
                }, {
                    hasDraggableNodes: !0,
                    forces: ["barycenter", "repulsive"],
                    pointArrayMap: ["value"],
                    pointValKey: "value",
                    isCartesian: !1,
                    axisTypes: [],
                    noSharedTooltip: !0,
                    accumulateAllPoints: function (a) {
                        var d = a.chart, b = [], c, e;
                        for (c = 0; c < d.series.length; c++) if (a =
                            d.series[c], a.visible || !d.options.chart.ignoreHiddenSeries) for (e = 0; e < a.yData.length; e++) b.push([null, null, a.yData[e], a.index, e, {
                            id: e,
                            marker: {radius: 0}
                        }]);
                        return b
                    },
                    init: function () {
                        b.prototype.init.apply(this, arguments);
                        e(this, "updatedData", function () {
                            this.chart.series.forEach(function (a) {
                                a.type === this.type && (a.isDirty = !0)
                            }, this)
                        });
                        return this
                    },
                    render: function () {
                        var a = [];
                        b.prototype.render.apply(this, arguments);
                        this.options.dataLabels.allowOverlap || (this.data.forEach(function (d) {
                            g(d.dataLabels) && d.dataLabels.forEach(function (d) {
                                a.push(d)
                            })
                        }),
                            this.chart.hideOverlappingLabels(a))
                    },
                    setVisible: function () {
                        var a = this;
                        b.prototype.setVisible.apply(a, arguments);
                        a.parentNodeLayout && a.graph ? a.visible ? (a.graph.show(), a.parentNode.dataLabel && a.parentNode.dataLabel.show()) : (a.graph.hide(), a.parentNodeLayout.removeElementFromCollection(a.parentNode, a.parentNodeLayout.nodes), a.parentNode.dataLabel && a.parentNode.dataLabel.hide()) : a.layout && (a.visible ? a.layout.addElementsToCollection(a.points, a.layout.nodes) : a.points.forEach(function (b) {
                            a.layout.removeElementFromCollection(b,
                                a.layout.nodes)
                        }))
                    },
                    drawDataLabels: function () {
                        var a = this.options.dataLabels.textPath, c = this.points;
                        b.prototype.drawDataLabels.apply(this, arguments);
                        this.parentNode && (this.parentNode.formatPrefix = "parentNode", this.points = [this.parentNode], this.options.dataLabels.textPath = this.options.dataLabels.parentNodeTextPath, b.prototype.drawDataLabels.apply(this, arguments), this.points = c, this.options.dataLabels.textPath = a)
                    },
                    seriesBox: function () {
                        var a = this.chart, b = Math.max, c = Math.min, e, f = [a.plotLeft, a.plotLeft +
                        a.plotWidth, a.plotTop, a.plotTop + a.plotHeight];
                        this.data.forEach(function (a) {
                            l(a.plotX) && l(a.plotY) && a.marker.radius && (e = a.marker.radius, f[0] = c(f[0], a.plotX - e), f[1] = b(f[1], a.plotX + e), f[2] = c(f[2], a.plotY - e), f[3] = b(f[3], a.plotY + e))
                        });
                        return k(f.width / f.height) ? f : null
                    },
                    calculateParentRadius: function () {
                        var a = this.seriesBox();
                        this.parentNodeRadius = Math.min(Math.max(Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20, 20), a ? Math.max(Math.sqrt(Math.pow(a.width, 2) + Math.pow(a.height, 2)) / 2 + 20, 20) : Math.sqrt(2 * this.parentNodeMass /
                            Math.PI) + 20);
                        this.parentNode && (this.parentNode.marker.radius = this.parentNode.radius = this.parentNodeRadius)
                    },
                    drawGraph: function () {
                        if (this.layout && this.layout.options.splitSeries) {
                            var b = this.chart, c = this.layout.options.parentNodeOptions.marker;
                            c = {
                                fill: c.fillColor || x(this.color).brighten(.4).get(),
                                opacity: c.fillOpacity,
                                stroke: c.lineColor || this.color,
                                "stroke-width": c.lineWidth
                            };
                            var e = this.visible ? "inherit" : "hidden";
                            this.parentNodesGroup || (this.parentNodesGroup = this.plotGroup("parentNodesGroup", "parentNode",
                                e, .1, b.seriesGroup), this.group.attr({zIndex: 2}));
                            this.calculateParentRadius();
                            e = a.merge({
                                x: this.parentNode.plotX - this.parentNodeRadius,
                                y: this.parentNode.plotY - this.parentNodeRadius,
                                width: 2 * this.parentNodeRadius,
                                height: 2 * this.parentNodeRadius
                            }, c);
                            this.parentNode.graphic || (this.graph = this.parentNode.graphic = b.renderer.symbol(c.symbol).add(this.parentNodesGroup));
                            this.parentNode.graphic.attr(e)
                        }
                    },
                    createParentNodes: function () {
                        var a = this, b = a.chart, c = a.parentNodeLayout, e, f = a.parentNode;
                        a.parentNodeMass =
                            0;
                        a.points.forEach(function (b) {
                            a.parentNodeMass += Math.PI * Math.pow(b.marker.radius, 2)
                        });
                        a.calculateParentRadius();
                        c.nodes.forEach(function (b) {
                            b.seriesIndex === a.index && (e = !0)
                        });
                        c.setArea(0, 0, b.plotWidth, b.plotHeight);
                        e || (f || (f = (new t).init(this, {
                            mass: a.parentNodeRadius / 2,
                            marker: {radius: a.parentNodeRadius},
                            dataLabels: {inside: !1},
                            dataLabelOnNull: !0,
                            degree: a.parentNodeRadius,
                            isParentNode: !0,
                            seriesIndex: a.index
                        })), a.parentNode && (f.plotX = a.parentNode.plotX, f.plotY = a.parentNode.plotY), a.parentNode = f, c.addElementsToCollection([a],
                            c.series), c.addElementsToCollection([f], c.nodes))
                    },
                    addSeriesLayout: function () {
                        var b = this.options.layoutAlgorithm, c = this.chart.graphLayoutsStorage,
                            e = this.chart.graphLayoutsLookup,
                            f = a.merge(b, b.parentNodeOptions, {enableSimulation: this.layout.options.enableSimulation});
                        var g = c[b.type + "-series"];
                        g || (c[b.type + "-series"] = g = new a.layouts[b.type], g.init(f), e.splice(g.index, 0, g));
                        this.parentNodeLayout = g;
                        this.createParentNodes()
                    },
                    addLayout: function () {
                        var b = this.options.layoutAlgorithm, c = this.chart.graphLayoutsStorage,
                            e = this.chart.graphLayoutsLookup, f = this.chart.options.chart;
                        c || (this.chart.graphLayoutsStorage = c = {}, this.chart.graphLayoutsLookup = e = []);
                        var g = c[b.type];
                        g || (b.enableSimulation = l(f.forExport) ? !f.forExport : b.enableSimulation, c[b.type] = g = new a.layouts[b.type], g.init(b), e.splice(g.index, 0, g));
                        this.layout = g;
                        this.points.forEach(function (a) {
                            a.mass = 2;
                            a.degree = 1;
                            a.collisionNmb = 1
                        });
                        g.setArea(0, 0, this.chart.plotWidth, this.chart.plotHeight);
                        g.addElementsToCollection([this], g.series);
                        g.addElementsToCollection(this.points,
                            g.nodes)
                    },
                    deferLayout: function () {
                        var a = this.options.layoutAlgorithm;
                        this.visible && (this.addLayout(), a.splitSeries && this.addSeriesLayout())
                    },
                    translate: function () {
                        var b = this.chart, c = this.data, e = this.index, f, g = this.options.useSimulation;
                        this.processedXData = this.xData;
                        this.generatePoints();
                        l(b.allDataPoints) || (b.allDataPoints = this.accumulateAllPoints(this), this.getPointRadius());
                        if (g) var m = b.allDataPoints; else m = this.placeBubbles(b.allDataPoints), this.options.draggable = !1;
                        for (f = 0; f < m.length; f++) if (m[f][3] ===
                            e) {
                            var t = c[m[f][4]];
                            var q = m[f][2];
                            g || (t.plotX = m[f][0] - b.plotLeft + b.diffX, t.plotY = m[f][1] - b.plotTop + b.diffY);
                            t.marker = a.extend(t.marker, {radius: q, width: 2 * q, height: 2 * q});
                            t.radius = q
                        }
                        g && this.deferLayout();
                        p(this, "afterTranslate")
                    },
                    checkOverlap: function (a, b) {
                        var c = a[0] - b[0], d = a[1] - b[1];
                        return -.001 > Math.sqrt(c * c + d * d) - Math.abs(a[2] + b[2])
                    },
                    positionBubble: function (a, b, c) {
                        var d = Math.sqrt, e = Math.asin, f = Math.acos, h = Math.pow, g = Math.abs;
                        d = d(h(a[0] - b[0], 2) + h(a[1] - b[1], 2));
                        f = f((h(d, 2) + h(c[2] + b[2], 2) - h(c[2] + a[2],
                            2)) / (2 * (c[2] + b[2]) * d));
                        e = e(g(a[0] - b[0]) / d);
                        a = (0 > a[1] - b[1] ? 0 : Math.PI) + f + e * (0 > (a[0] - b[0]) * (a[1] - b[1]) ? 1 : -1);
                        return [b[0] + (b[2] + c[2]) * Math.sin(a), b[1] - (b[2] + c[2]) * Math.cos(a), c[2], c[3], c[4]]
                    },
                    placeBubbles: function (a) {
                        var b = this.checkOverlap, c = this.positionBubble, d = [], e = 1, f = 0, g = 0;
                        var m = [];
                        var p;
                        a = a.sort(function (a, b) {
                            return b[2] - a[2]
                        });
                        if (a.length) {
                            d.push([[0, 0, a[0][2], a[0][3], a[0][4]]]);
                            if (1 < a.length) for (d.push([[0, 0 - a[1][2] - a[0][2], a[1][2], a[1][3], a[1][4]]]), p = 2; p < a.length; p++) a[p][2] = a[p][2] || 1, m = c(d[e][f],
                                d[e - 1][g], a[p]), b(m, d[e][0]) ? (d.push([]), g = 0, d[e + 1].push(c(d[e][f], d[e][0], a[p])), e++, f = 0) : 1 < e && d[e - 1][g + 1] && b(m, d[e - 1][g + 1]) ? (g++, d[e].push(c(d[e][f], d[e - 1][g], a[p])), f++) : (f++, d[e].push(m));
                            this.chart.stages = d;
                            this.chart.rawPositions = [].concat.apply([], d);
                            this.resizeRadius();
                            m = this.chart.rawPositions
                        }
                        return m
                    },
                    resizeRadius: function () {
                        var a = this.chart, b = a.rawPositions, c = Math.min, e = Math.max, f = a.plotLeft,
                            g = a.plotTop, m = a.plotHeight, p = a.plotWidth, t, q, k;
                        var l = t = Number.POSITIVE_INFINITY;
                        var x = q = Number.NEGATIVE_INFINITY;
                        for (k = 0; k < b.length; k++) {
                            var u = b[k][2];
                            l = c(l, b[k][0] - u);
                            x = e(x, b[k][0] + u);
                            t = c(t, b[k][1] - u);
                            q = e(q, b[k][1] + u)
                        }
                        k = [x - l, q - t];
                        c = c.apply([], [(p - f) / k[0], (m - g) / k[1]]);
                        if (1e-10 < Math.abs(c - 1)) {
                            for (k = 0; k < b.length; k++) b[k][2] *= c;
                            this.placeBubbles(b)
                        } else a.diffY = m / 2 + g - t - (q - t) / 2, a.diffX = p / 2 + f - l - (x - l) / 2
                    },
                    calculateZExtremes: function () {
                        var a = this.options.zMin, b = this.options.zMax, c = Infinity, e = -Infinity;
                        if (a && b) return [a, b];
                        this.chart.series.forEach(function (a) {
                            a.yData.forEach(function (a) {
                                l(a) && (a > e && (e = a), a < c && (c = a))
                            })
                        });
                        a = u(a, c);
                        b = u(b, e);
                        return [a, b]
                    },
                    getPointRadius: function () {
                        var a = this, b = a.chart, c = a.options, e = c.useSimulation,
                            f = Math.min(b.plotWidth, b.plotHeight), g = {}, m = [], p = b.allDataPoints, t, q, k, l;
                        ["minSize", "maxSize"].forEach(function (a) {
                            var b = parseInt(c[a], 10), d = /%$/.test(c[a]);
                            g[a] = d ? f * b / 100 : b * Math.sqrt(p.length)
                        });
                        b.minRadius = t = g.minSize / Math.sqrt(p.length);
                        b.maxRadius = q = g.maxSize / Math.sqrt(p.length);
                        var x = e ? a.calculateZExtremes() : [t, q];
                        (p || []).forEach(function (b, c) {
                            k = e ? Math.max(Math.min(b[2], x[1]), x[0]) : b[2];
                            l = a.getRadius(x[0], x[1], t, q, k);
                            0 === l && (l = null);
                            p[c][2] = l;
                            m.push(l)
                        });
                        a.radii = m
                    },
                    redrawHalo: v.redrawHalo,
                    onMouseDown: v.onMouseDown,
                    onMouseMove: v.onMouseMove,
                    onMouseUp: function (b) {
                        if (b.fixedPosition && !b.removed) {
                            var c, d, e = this.layout, f = this.parentNodeLayout;
                            f && e.options.dragBetweenSeries && f.nodes.forEach(function (f) {
                                b && b.marker && f !== b.series.parentNode && (c = e.getDistXY(b, f), d = e.vectorLength(c) - f.marker.radius - b.marker.radius, 0 > d && (f.series.addPoint(a.merge(b.options, {
                                    plotX: b.plotX,
                                    plotY: b.plotY
                                }), !1),
                                    e.removeElementFromCollection(b, e.nodes), b.remove()))
                            });
                            v.onMouseUp.apply(this, arguments)
                        }
                    },
                    destroy: function () {
                        this.chart.graphLayoutsLookup && this.chart.graphLayoutsLookup.forEach(function (a) {
                            a.removeElementFromCollection(this, a.series)
                        }, this);
                        this.parentNode && (this.parentNodeLayout.removeElementFromCollection(this.parentNode, this.parentNodeLayout.nodes), this.parentNode.dataLabel && (this.parentNode.dataLabel = this.parentNode.dataLabel.destroy()));
                        a.Series.prototype.destroy.apply(this, arguments)
                    },
                    alignDataLabel: a.Series.prototype.alignDataLabel
                },
                {
                    destroy: function () {
                        this.series.layout && this.series.layout.removeElementFromCollection(this, this.series.layout.nodes);
                        return f.prototype.destroy.apply(this, arguments)
                    }
                });
            e(q, "beforeRedraw", function () {
                this.allDataPoints && delete this.allDataPoints
            });
            ""
        });
    z(v, "parts-more/Polar.js", [v["parts/Globals.js"], v["parts/Utilities.js"]], function (a, c) {
        var l = c.splat, g = a.pick, k = a.Series, b = a.seriesTypes;
        c = a.wrap;
        var f = k.prototype, u = a.Pointer.prototype;
        f.searchPointByAngle = function (a) {
            var b = this.chart, c = this.xAxis.pane.center;
            return this.searchKDTree({clientX: 180 + -180 / Math.PI * Math.atan2(a.chartX - c[0] - b.plotLeft, a.chartY - c[1] - b.plotTop)})
        };
        f.getConnectors = function (a, b, c, f) {
            var e = f ? 1 : 0;
            var g = 0 <= b && b <= a.length - 1 ? b : 0 > b ? a.length - 1 + b : 0;
            b = 0 > g - 1 ? a.length - (1 + e) : g - 1;
            e = g + 1 > a.length - 1 ? e : g + 1;
            var p = a[b];
            e = a[e];
            var d = p.plotX;
            p = p.plotY;
            var k = e.plotX;
            var h = e.plotY;
            e = a[g].plotX;
            g = a[g].plotY;
            d = (1.5 * e + d) / 2.5;
            p = (1.5 * g + p) / 2.5;
            k = (1.5 * e + k) / 2.5;
            var q = (1.5 * g + h) / 2.5;
            h = Math.sqrt(Math.pow(d - e, 2) + Math.pow(p - g, 2));
            var l = Math.sqrt(Math.pow(k - e, 2) + Math.pow(q -
                g, 2));
            d = Math.atan2(p - g, d - e);
            q = Math.PI / 2 + (d + Math.atan2(q - g, k - e)) / 2;
            Math.abs(d - q) > Math.PI / 2 && (q -= Math.PI);
            d = e + Math.cos(q) * h;
            p = g + Math.sin(q) * h;
            k = e + Math.cos(Math.PI + q) * l;
            q = g + Math.sin(Math.PI + q) * l;
            e = {rightContX: k, rightContY: q, leftContX: d, leftContY: p, plotX: e, plotY: g};
            c && (e.prevPointCont = this.getConnectors(a, b, !1, f));
            return e
        };
        f.toXY = function (a) {
            var b = this.chart, c = a.plotX;
            var e = a.plotY;
            a.rectPlotX = c;
            a.rectPlotY = e;
            e = this.xAxis.postTranslate(a.plotX, this.yAxis.len - e);
            a.plotX = a.polarPlotX = e.x - b.plotLeft;
            a.plotY =
                a.polarPlotY = e.y - b.plotTop;
            this.kdByAngle ? (b = (c / Math.PI * 180 + this.xAxis.pane.options.startAngle) % 360, 0 > b && (b += 360), a.clientX = b) : a.clientX = a.plotX
        };
        b.spline && (c(b.spline.prototype, "getPointSpline", function (a, b, c, f) {
            this.chart.polar ? f ? (a = this.getConnectors(b, f, !0, this.connectEnds), a = ["C", a.prevPointCont.rightContX, a.prevPointCont.rightContY, a.leftContX, a.leftContY, a.plotX, a.plotY]) : a = ["M", c.plotX, c.plotY] : a = a.call(this, b, c, f);
            return a
        }), b.areasplinerange && (b.areasplinerange.prototype.getPointSpline =
            b.spline.prototype.getPointSpline));
        a.addEvent(k, "afterTranslate", function () {
            var b = this.chart, c;
            if (b.polar) {
                (this.kdByAngle = b.tooltip && b.tooltip.shared) ? this.searchPoint = this.searchPointByAngle : this.options.findNearestPointBy = "xy";
                if (!this.preventPostTranslate) {
                    var f = this.points;
                    for (c = f.length; c--;) this.toXY(f[c]), !b.hasParallelCoordinates && !this.yAxis.reversed && f[c].y < this.yAxis.min && (f[c].isNull = !0)
                }
                this.hasClipCircleSetter || (this.hasClipCircleSetter = !!a.addEvent(this, "afterRender", function () {
                    if (b.polar) {
                        var c =
                            this.yAxis.center;
                        this.group.clip(b.renderer.clipCircle(c[0], c[1], c[2] / 2));
                        this.setClip = a.noop
                    }
                }))
            }
        }, {order: 2});
        c(f, "getGraphPath", function (a, b) {
            var c = this, e;
            if (this.chart.polar) {
                b = b || this.points;
                for (e = 0; e < b.length; e++) if (!b[e].isNull) {
                    var f = e;
                    break
                }
                if (!1 !== this.options.connectEnds && void 0 !== f) {
                    this.connectEnds = !0;
                    b.splice(b.length, 0, b[f]);
                    var g = !0
                }
                b.forEach(function (a) {
                    void 0 === a.polarPlotY && c.toXY(a)
                })
            }
            e = a.apply(this, [].slice.call(arguments, 1));
            g && b.pop();
            return e
        });
        k = function (a, b) {
            var c = this.chart,
                e = this.options.animation, f = this.group, g = this.markerGroup, k = this.xAxis.center, d = c.plotLeft,
                p = c.plotTop;
            c.polar ? c.renderer.isSVG && (!0 === e && (e = {}), b ? (a = {
                translateX: k[0] + d,
                translateY: k[1] + p,
                scaleX: .001,
                scaleY: .001
            }, f.attr(a), g && g.attr(a)) : (a = {
                translateX: d,
                translateY: p,
                scaleX: 1,
                scaleY: 1
            }, f.animate(a, e), g && g.animate(a, e), this.animate = null)) : a.call(this, b)
        };
        c(f, "animate", k);
        b.column && (b = b.column.prototype, b.polarArc = function (a, b, c, f) {
            var e = this.xAxis.center, k = this.yAxis.len;
            return this.chart.renderer.symbols.arc(e[0],
                e[1], k - b, null, {start: c, end: f, innerR: k - g(a, k)})
        }, c(b, "animate", k), c(b, "translate", function (a) {
            var b = this.xAxis, c = b.startAngleRad, e;
            this.preventPostTranslate = !0;
            a.call(this);
            if (b.isRadial) {
                var f = this.points;
                for (e = f.length; e--;) {
                    var g = f[e];
                    a = g.barX + c;
                    g.shapeType = "path";
                    g.shapeArgs = {d: this.polarArc(g.yBottom, g.plotY, a, a + g.pointWidth)};
                    this.toXY(g);
                    g.tooltipPos = [g.plotX, g.plotY];
                    g.ttBelow = g.plotY > b.center[1]
                }
            }
        }), c(b, "alignDataLabel", function (a, b, c, g, k, l) {
            this.chart.polar ? (a = b.rectPlotX / Math.PI * 180, null ===
            g.align && (g.align = 20 < a && 160 > a ? "left" : 200 < a && 340 > a ? "right" : "center"), null === g.verticalAlign && (g.verticalAlign = 45 > a || 315 < a ? "bottom" : 135 < a && 225 > a ? "top" : "middle"), f.alignDataLabel.call(this, b, c, g, k, l)) : a.call(this, b, c, g, k, l)
        }));
        c(u, "getCoordinates", function (a, b) {
            var c = this.chart, e = {xAxis: [], yAxis: []};
            c.polar ? c.axes.forEach(function (a) {
                var f = a.isXAxis, g = a.center;
                if ("colorAxis" !== a.coll) {
                    var d = b.chartX - g[0] - c.plotLeft;
                    g = b.chartY - g[1] - c.plotTop;
                    e[f ? "xAxis" : "yAxis"].push({
                        axis: a, value: a.translate(f ? Math.PI -
                            Math.atan2(d, g) : Math.sqrt(Math.pow(d, 2) + Math.pow(g, 2)), !0)
                    })
                }
            }) : e = a.call(this, b);
            return e
        });
        a.SVGRenderer.prototype.clipCircle = function (b, c, f) {
            var e = a.uniqueKey(), g = this.createElement("clipPath").attr({id: e}).add(this.defs);
            b = this.circle(b, c, f).add(g);
            b.id = e;
            b.clipPath = g;
            return b
        };
        a.addEvent(a.Chart, "getAxes", function () {
            this.pane || (this.pane = []);
            l(this.options.pane).forEach(function (b) {
                new a.Pane(b, this)
            }, this)
        });
        a.addEvent(a.Chart, "afterDrawChartBox", function () {
            this.pane.forEach(function (a) {
                a.render()
            })
        });
        c(a.Chart.prototype, "get", function (b, c) {
            return a.find(this.pane, function (a) {
                return a.options.id === c
            }) || b.call(this, c)
        })
    });
    z(v, "masters/highcharts-more.src.js", [], function () {
    })
});
//# sourceMappingURL=highcharts-more.js.map