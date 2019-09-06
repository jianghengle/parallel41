<template>
  <div>
    <div class="container">
      <div class="content text-content">
        <h4 class="p-header">Get Started</h4>
        <p>Pins on the map represent flux station locations. Click a point to view data. Data and graphs will appear below the map.</p>
      </div>

      <gmap-map
        ref="map"
        :center="mapCenter"
        :zoom="mapZoom"
        style="width: 100%"
        :style="{'height': mapHeightPx}"
      >
        <gmap-cluster :zoomOnClick="true">
          <gmap-marker
            v-for="(m, i) in sites"
            :key="'m-' + i"
            :position="m.position"
            :clickable="true"
            @click="openSite(i)">
          </gmap-marker>
        </gmap-cluster>
        <gmap-info-window
          v-for="(m, i) in sites"
          :key="'i-' + i"
          :opened="m.infoOpened"
          :position="m.position"
          :options="infoOptions"
          @closeclick="m.infoOpened = false">
          <span v-html="m.info"></span>
        </gmap-info-window>
      </gmap-map>
    </div>

    <div class="container data-window" v-if="activeSite">
      <div class="station-title">
        {{activeSite.name}}
      </div>
      <table class="table is-fullwidth data-table">
        <tbody>
          <tr>
            <th>Date</th>
            <td>
              <div>
                <a class="button" @click="selectPreDate">
                  <span class="icon is-small">
                    <icon name="chevron-left"></icon>
                  </span>
                </a>
                <datepicker
                  wrapper-class="date-picker-wrapper"
                  input-class="date-picker-input"
                  format="yyyy-MM-dd"
                  :value="date"
                  :disabled="dateDisabled"
                  v-on:selected="dateSelected">
                </datepicker>
                <a class="button" @click="selectNextDate">
                  <span class="icon is-small">
                    <icon name="chevron-right"></icon>
                  </span>
                </a>
              </div>
            </td>
          </tr>

          <tr>
            <th>ET Units</th>
            <td>
              <div class="control">
                <label class="radio">
                  <input type="radio" value="mm" v-model="unit">
                  mm
                </label>
                <label class="radio">
                  <input type="radio" value="inches" v-model="unit">
                  inches
                </label>
              </div>
            </td>
          </tr>

          <tr>
            <th>Daily Measured ET (ETc) Value</th>
            <td>{{dayEt[0] ? dayEt[0] + ' ' + unit : 'Not Available'}}</td>
          </tr>

          <tr>
            <th>ETc of Previous 7 Days</th>
            <td>
              <table class="table is-narrow week-table" v-if="weekEt">
                <thead>
                  <tr>
                    <th v-for="d in weekEt[0]">{{d}}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td v-for="et in weekEt[1]">{{et[0]}}</td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>

          <tr>
            <th>
              Graph of Daily ETc Values for Date Selected and Previous
              <input class="input is-small pre-days-input" type="number" v-model="previousDays">
              Days
            </th>
            <td>
              <div class="chart-container">
                <div id="previousChart0"></div>
              </div>
            </td>
          </tr>

          <tr>
            <th>Daily Reference ET (ETr) Value &nbsp;&nbsp;<span class="is-size-7 has-text-grey">Source: HPRCC</span></th>
            <td>{{dayEt[1] ? dayEt[1] + ' ' + unit : 'Not Available'}}</td>
          </tr>

          <tr>
            <th>ETr of Previous 7 Days &nbsp;&nbsp;<span class="is-size-7 has-text-grey">Source: HPRCC</span></th>
            <td>
              <table class="table is-narrow week-table" v-if="weekEt">
                <thead>
                  <tr>
                    <th v-for="d in weekEt[0]">{{d}}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td v-for="et in weekEt[1]">{{et[1]}}</td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>

          <tr>
            <th>
              Graph of Daily ETc & ETr Values for Date Selected and Previous
              <input class="input is-small pre-days-input" type="number" v-model="previousDays">
              Days
            </th>
            <td>
              <div class="chart-container">
                <div id="previousChart1"></div>
              </div>
            </td>
          </tr>

          <tr>
            <th>Daily Crop Coefficient (Kc) Value (ETc/ETr)</th>
            <td>{{dayEt[2] ? dayEt[2] : 'Not Available'}}</td>
          </tr>

          <tr>
            <th>Kc of Previous 7 Days</th>
            <td>
              <table class="table is-narrow week-table" v-if="weekEt">
                <thead>
                  <tr>
                    <th v-for="d in weekEt[0]">{{d}}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td v-for="et in weekEt[1]">{{et[2]}}</td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>

          <tr>
            <th>
              Graph of Daily Kc (ETc/ETr) Values for Date Selected and Previous
              <input class="input is-small pre-days-input" type="number" v-model="previousDays">
              Days
            </th>
            <td>
              <div class="chart-container">
                <div id="previousChart2"></div>
              </div>
            </td>
          </tr>

          <tr>
            <th>Cumulative ET during Growing Season, to Date</th>
            <td>{{(growingEt && growingEt[3]) ? growingEt[3] + ' ' + unit : 'Not Available'}}</td>
          </tr>

          <tr>
            <th>
              <span>Graph of Cumulative ET Values for Growing Season, to Date</span><br />
              <span class="has-text-weight-light is-size-7">Based on a standard growing season from May 1 to September 15</span>
            </th>
            <td>
              <div class="chart-container">
                <div id="growingChart"></div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'
import c3 from 'c3'

function makeInfo(s){
  var info = '<h3><strong>' + s.name + ' (' + s.abbr + ')</strong></h3>'
  info += '<p>Location: ' + s.location + ' (lat: ' + s.position.lat + ', lng: ' + s.position.lng + ')</p>'
  info += '<p>Ecosystem: ' + s.ecosystem + '</p>'
  info += '<p>Elevation: ' + s.elevation + '</p>'
  if(s.image){
    info += '<img src="' + s.image + '" style="width:320px">'
  }
  return info
}

var site1 = {
  name: 'Grant NE 01',
  abbr: 'NE01',
  location: 'Grant, NE',
  position: { lat: 40.793, lng: -101.624 },
  ecosystem: 'irrigated field corn',
  elevation: '1027.3m',
  infoOpened: false,
  image: 'static/sites/ne01.jpg',
  et: {},
}
site1.info = makeInfo(site1)

var site2 = {
  name: 'Mead NE 01',
  abbr: 'Mead1',
  location: 'ENREC, Mead, NE',
  position: { lat: 41.165, lng: -96.477 },
  ecosystem: 'Irrigated continuous maize',
  elevation: '345.9 m',
  infoOpened: false,
  image: 'static/sites/Mead NE 01.jpg',
  et: {},
}
site2.info = makeInfo(site2)

var site3 = {
  name: 'Mead NE 02',
  abbr: 'Mead2',
  location: 'ENREC, Mead, NE',
  position: { lat: 41.165, lng: -96.470 },
  ecosystem: 'Irrigated maize-soybean rotation',
  elevation: '349.8 m',
  infoOpened: false,
  image: 'static/sites/Mead NE 02.jpg',
  et: {},
}
site3.info = makeInfo(site3)

var site4 = {
  name: 'Mead NE 03',
  abbr: 'Mead3',
  location: 'ENREC, Mead, NE',
  position: { lat: 41.18, lng: -96.440 },
  ecosystem: 'Rainfed maize-soybean rotation',
  elevation: '354.4 m',
  infoOpened: false,
  image: 'static/sites/Mead NE 03.jpg',
  et: {},
}
site4.info = makeInfo(site4)

var site5 = {
  name: 'Brooks 11',
  abbr: 'Brooks 11',
  location: 'Ames, IA',
  position: { lat: 41.974, lng: -93.694 },
  ecosystem: 'Corn-Soy rotation',
  elevation: '324.3 m',
  infoOpened: false,
  et: {},
}
site5.info = makeInfo(site5)

var site6 = {
  name: 'Brooks 30ft',
  abbr: 'Brooks 30ft',
  location: 'Ames, IA',
  position: { lat: 41.976, lng: -93.693 },
  ecosystem: 'Mixture of corn and soybean',
  elevation: '322.4 m',
  infoOpened: false,
  et: {},
}
site6.info = makeInfo(site6)


export default {
  name: 'map-data',
  components: {
    Datepicker
  },
  data () {
    return {
      mapHeight: 600,
      mapCenter: {lat: 40.8, lng: -97.6},
      newMapCenter: {lat: 40.8, lng: 97.6},
      mapZoom: 6,
      date: new Date(Date.now() - 86400000),
      sites: [site1, site2, site3, site4, site5, site6],
      infoOptions: {
        pixelOffset: {
          width: 0,
          height: -42
        }
      },
      activeSite: null,
      growingSeason: ['05-01', '09-15'],
      unit: 'mm',
      previousDays: 7,
      previousCharts: [null, null, null],
      growingChart: null,
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    mapHeightPx () {
      return this.mapHeight + 'px'
    },
    year () {
      return this.date.getFullYear()
    },
    day () {
      return this.dateToDay (this.date)
    },
    dayEt () {
      if(!this.activeSite || !this.date || !this.activeSite.et[this.year])
        return []
      var dayEt = this.activeSite.et[this.year][this.day]
      if(dayEt){
        var et = this.unit == "mm" ? dayEt[2] : (dayEt[2] / 25.4)
        var etr = this.unit == "mm" ? dayEt[4] : (dayEt[4] / 25.4)
        var kc = parseFloat(etr) == 0.0 ? null : (et / etr)
        return [et, etr, kc].map(this.twoDigits)
      }
      return []
    },
    previousEt () {
      if(!this.activeSite || !this.date || !this.activeSite.et[this.year])
        return
      var yearEt = this.activeSite.et[this.year]
      var xs = []
      var ys = []
      for(var i=0;i<this.previousDays;i++){
        var day = this.day - i
        if(day <= 0)
          break

        var date = this.dayToDate(this.year, day)
        xs.unshift(DateForm(date, "isoDate"))
        if(yearEt[day]){
          var et = this.unit == "mm" ? yearEt[day][2] : (yearEt[day][2] / 25.4)
          var etr = null
          var kc = null
          if(parseFloat(yearEt[day][4]) != 0){
            etr = this.unit == "mm" ? yearEt[day][4] : (yearEt[day][4] / 25.4)
            kc =  et / etr
          }
          ys.unshift([et, etr, kc].map(this.twoDigits))
        }else{
          ys.unshift([null, null, null])
        }
      }
      return [xs, ys]
    },
    weekEt () {
      if(!this.previousEt)
        return
      var len = this.previousEt[0].length
      if(len <= 7)
        return this.previousEt
      var diff = len - 7
      return [this.previousEt[0].slice(diff), this.previousEt[1].slice(diff)]
    },
    growingDays () {
      var start = this.growingSeason[0].split('-')
      var startDate = new Date(this.year, start[0]-1, start[1], 1)
      var startDay = this.dateToDay(startDate)
      var end = this.growingSeason[1].split('-')
      var endDate = new Date(this.year, end[0]-1, end[1], 1)
      var endDay = this.dateToDay(endDate)
      return [startDay, endDay]
    },
    growingEt () {
      if(!this.activeSite || !this.date || !this.activeSite.et[this.year])
        return
      var yearEt = this.activeSite.et[this.year]
      var xs = []
      var ys = []
      var sum = 0.0
      var nonzero = -1
      var regions = []
      var regionStart = false
      for(var i=this.growingDays[0];i<=this.growingDays[1];i++){
        var day = i
        var date = this.dayToDate(this.year, day)
        xs.push(DateForm(date, "isoDate"))
        if(yearEt[day] != undefined){
          sum += this.unit == "mm" ? yearEt[day][2] : (yearEt[day][2] / 25.4)
          ys.push(this.twoDigits(sum))
          nonzero = day - this.growingDays[0]
          regionStart = false
        }else{
          ys.push(this.twoDigits(sum))
          if(regionStart){
            var lastRegion = regions[regions.length - 1]
            lastRegion[1] = DateForm(date, "isoDate")
          }else{
            var region = [DateForm(date, "isoDate"), DateForm(date, "isoDate")]
            regions.push(region)
            regionStart = true
          }
        }
      }
      if(regionStart){
        regions.pop()
      }
      for(var i=nonzero+1;i<ys.length;i++){
        ys[i] = null
      }
      var line = null
      var value = null
      if(this.day >= this.growingDays[0] && this.day <= this.growingDays[1]){
        line = DateForm(this.date, "isoDate")
        value = ys[this.day - this.growingDays[0]]
      }
      return [xs, ys, line, value, regions]
    },
    dateDisabled () {
      if(!this.activeSite || !this.date || !this.activeSite.et[this.year])
        return {}
      var yearEt = this.activeSite.et[this.year]
      var dates = []
      var start = new Date(this.year, 0, 1)
      var count = this.year % 4 ? 366 : 365
      for(var i=0;i<count;i++){
        var doy = 1 + i
        if(yearEt[doy] == undefined){
          var date = new Date(start.getTime() + 86400000 * i)
          dates.push(date)
        }
      }
      return {dates: dates}
    },
  },
  watch: {
    previousEt: function (val) {
      if(val){
        this.$nextTick(function(){
          this.drawPreviousEt()
        })
      }
    },
    growingEt: function (val) {
      if(val){
        this.$nextTick(function(){
          this.drawGrowingEt()
        })
      }
    },
  },
  methods: {
    openSite (idx) {
      this.sites.forEach(function(s){
        s.infoOpened = false
      })
      this.sites[idx].infoOpened = true
      this.activeSite = this.sites[idx]
      this.requestData()
    },
    requestData () {
      if(!this.activeSite || !this.year || this.activeSite.et[this.year])
        return

      var url = 'static/data/' + this.activeSite.name + '/' + this.year + '.txt'
      this.$http.get(url).then(response => {
        var lines = response.body.split('\n')
        var data = {}
        for(var i=1;i<lines.length;i++){
          var line = lines[i]
          if(line.length){
            var d = lines[i].split('\t')
            d[2] = parseFloat(d[2])
            data[d[1]] = d
          }
        }
        Vue.set(this.activeSite.et, this.year, data)
      }, response => {
        this.error = 'Failed to get data!'
      })
    },
    dateToDay (date) {
      var year = date.getFullYear()
      var month = date.getMonth()
      var day = date.getDate()
      return Math.ceil((new Date(year, month, day, 12) - new Date(year, 0, 1)) / 86400000)
    },
    dayToDate (year, day) {
      return new Date(new Date(year, 0, 1, 12).getTime() + 86400000 * (day - 1))
    },
    mapCenterChanged (center) {
      this.newMapCenter = {lat: center.lat(), lng: center.lng()}
    },
    mapZoomChanged (zoom) {
      this.mapZoom = zoom
    },
    dateSelected (newDate) {
      this.date = newDate
      this.$nextTick(function(){
        this.requestData()
      })
    },
    selectPreDate () {
      var date = new Date(this.date.getTime() - 86400000)
      this.dateSelected(date)
    },
    selectNextDate () {
      var date = new Date(this.date.getTime() + 86400000)
      this.dateSelected(date)
    },
    drawPreviousEt () {
      var columns = [['x'], ['ETc'], ['ETr'], ['Kc']]
      for(var i=0;i<this.previousEt[0].length;i++){
        columns[0].push(this.previousEt[0][i])
        columns[1].push(this.previousEt[1][i][0])
        columns[2].push(this.previousEt[1][i][1])
        columns[3].push(this.previousEt[1][i][2])
      }

      var charts = [
        {data: [columns[0], columns[1]], type: 'bar'},
        {data: [columns[0], columns[1], columns[2]], type: 'spline'},
        {data: [columns[0], columns[3]], type: 'spline'}
      ]
      var barWidth = 700 / columns[0].length / 1.5

      for(var i=0;i<charts.length;i++){
        if(this.previousCharts[i]){
          this.previousCharts[i] = this.previousCharts[i].destroy()
        }
        var vm = this
        this.previousCharts[i] = c3.generate({
          bindto: '#previousChart' + i,
          padding: { right: 20 },
          data: { x: 'x', columns: charts[i].data, type: charts[i].type, onclick: function (d, element) { vm.dateSelected(d.x) }},
          bar: { width: barWidth },
          axis: { x: { type: 'timeseries', tick: { count: 7, format: '%Y-%m-%d' } }, y: { min: 0, padding: {bottom:0} } },
          zoom: { enabled: true }
        })
      }
    },
    drawGrowingEt () {
      var columns = [this.growingEt[0].slice(0), this.growingEt[1].slice(0)]
      columns[0].unshift('x')
      columns[1].unshift('Accum. ET')
      var lines = []
      if (this.growingEt[2]) {
        lines = [{value: this.growingEt[2], text: this.growingEt[2]}]
      }
      var regions = this.growingEt[4].map(function(r){
        return {start: r[0], end: r[1], class: 'regionX'}
      })

      this.growingChart = c3.generate({
        bindto: '#growingChart',
        padding: { right: 20 },
        data: { x: 'x', columns: columns, types: { 'Accum. ET': 'area'}, type: 'spline' },
        axis: { x: { type: 'timeseries', tick: { count: 4, format: '%Y-%m-%d' } } },
        grid: {x: {lines: lines}},
        regions: regions,
        zoom: { enabled: true }
      })
    },
    twoDigits (val) {
      if(!val)
        return null
      if(val == 0)
        return 0
      var v = val < 0 ? (-val) : val
      var scale = 1
      while(v < 0.1){
        scale *= 10
        v *= 10
      }
      v = Math.round(v * 100)/(100*scale)
      return val < 0 ? (-v) : v
    }
  },
  mounted () {
    if(this.$route.params.target){
      var el = document.getElementById(this.$route.params.target)
      window.scroll(0, el.offsetTop)
    }else{
      window.scroll(0, 0)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.text-content {
  margin-bottom: 15px;
}

.p-header{
  font-weight: bold;
  margin-bottom: 0.5em;
  color: #05485A;
}

.data-window {
  margin-top: 15px;
  margin-bottom: 50px;
}

.station-title {
  text-align: center;
  font-weight: bold;
  color: #05485A;
  padding: 12px;
  font-size: 24px;
}

.week-table {
  margin-bottom: 0px;
 
  th {
    border-width: 0px;
    border-bottom-width: 0px!important;
    white-space: nowrap;
  }
  td {
    border-width: 0px;
    border-bottom-width: 0px!important;
    max-width: 100px;
    overflow: hidden;
    text-align: center;
  }
}

.chart-container {
  width: 100%;
  margin-top: 10px;
}

.pre-days-input {
  width: 55px;
}



</style>
