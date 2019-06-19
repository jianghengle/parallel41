<template>
  <div>
    <div>
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
      <table class="table is-fullwidth data-table">
        <tbody>
          <tr>
            <th>Station</th>
            <td>{{activeSite.name}}</td>
          </tr>

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
            <th>Daily ET Value</th>
            <td>{{dayEt ? dayEt + ' ' + unit : 'Not Available'}}</td>
          </tr>

          <tr>
            <th>ET of Previous 7 Days</th>
            <td>
              <table class="table is-narrow week-table" v-if="weekEt">
                <thead>
                  <tr>
                    <th v-for="d in weekEt[0]">{{d}}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td v-for="et in weekEt[1]">{{et}}</td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>

          <tr>
            <th>
              Graph of Daily ET Values for Date Selected and Previous
              <input class="input is-small pre-days-input" type="number" v-model="previousDays">
              Days
            </th>
            <td>
              <div class="chart-container">
                <div id="previousChart"></div>
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
  et: {},
}
site4.info = makeInfo(site4)


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
      sites: [site1, site2, site3, site4],
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
      previousChart: null,
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
        return
      var dayEt = this.activeSite.et[this.year][this.day]
      if(dayEt){
        dayEt = this.unit == "mm" ? dayEt[2] : (dayEt[2] / 25.4)
        return this.twoDigits(dayEt)
      }
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
          var y = this.unit == "mm" ? yearEt[day][2] : (yearEt[day][2] / 25.4)
          ys.unshift(this.twoDigits(y))
        }else{
          ys.unshift(null)
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
      var columns = [this.previousEt[0].slice(0), this.previousEt[1].slice(0)]
      columns[0].unshift('x')
      columns[1].unshift('Daily ET')
      if(this.previousChart){
        this.previousChart.load({
          columns: columns
        })
      }else{
        this.previousChart = c3.generate({
          bindto: '#previousChart',
          padding: {
            right: 20,
          },
          data: {
            x: 'x',
            columns: columns,
          },
          axis: {
            x: {
              type: 'timeseries',
              tick: {
                count: 7,
                format: '%Y-%m-%d'
              }
            },
            y: {
              min: 0,
              padding: {bottom:0}
            }
          }
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
        padding: {
          right: 20,
        },
        data: {
          x: 'x',
          columns: columns,
          types: { 'Accum. ET': 'area'},
        },
        axis: {
          x: {
            type: 'timeseries',
            tick: {
              count: 4,
              format: '%Y-%m-%d'
            }
          }
        },
        grid: {x: {lines: lines}},
        regions: regions
      })
    },
    twoDigits (val) {
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
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.data-window {
  margin-top: 15px;
  margin-bottom: 50px;
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
