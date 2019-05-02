<template>
  <div class="main-window">
    <div class="map-window" v-if="ready">
      <gmap-map
        ref="map"
        :center="mapCenter"
        :zoom="mapZoom"
        style="width: 100%"
        :style="{'height': mapHeightPx}"
      >
      <gmap-marker
          v-for="(m, i) in sites"
          :key="'m-' + i"
          :position="m.position"
          :clickable="true"
          @click="openSite(i)">
        </gmap-marker>
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
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Station</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="input is-static">{{activeSite.name}}</div>
            </div>
          </div>
        </div>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Date</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="input is-static">
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
            </div>
          </div>
        </div>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Avg. Daily Value</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="input is-static">{{dayEt ? dayEt + ' mm/day' : 'Not Available'}}</div>
            </div>
          </div>
        </div>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Value over last 7 days</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div>
                <table class="table" v-if="weekEt">
                  <thead>
                    <tr>
                      <th v-for="d in weekEt[0]">{{d}}</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td v-for="et in weekEt[1]" class="et-value">{{et}}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="chart-container">
                <div id="weekChart"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Accum. Value of Growing Season ({{growingSeason[0] + ' ~ ' + growingSeason[1]}})</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="input is-static">{{(growingEt && growingEt[3]) ? growingEt[3] + ' mm/day' : 'Not Available'}}</div>
              <div class="chart-container">
                <div id="growingChart"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

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
  weekChart: null,
  growingChart: null
}
site1.info = makeInfo(site1)


export default {
  name: 'my-main',
  components: {
    Datepicker
  },
  data () {
    return {
      ready: true,
      mapHeight: 800,
      mapCenter: {lat: 40.8, lng: -97.6},
      newMapCenter: {lat: 40.8, lng: 97.6},
      mapZoom: 7,
      date: new Date(Date.now() - 86400000),
      sites: [site1],
      infoOptions: {
        pixelOffset: {
          width: 0,
          height: -42
        }
      },
      activeSite: null,
      growingSeason: ['05-01', '09-15']
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
      return Math.ceil((this.date - new Date(this.year, 0, 1)) / 86400000)
    },
    isoDate () {
      if(this.date)
        return DateForm(this.date, "isoDate")
    },
    dayEt () {
      if(!this.activeSite || !this.date || !this.activeSite.et[this.year])
        return
      var dayEt = this.activeSite.et[this.year][this.day]
      if(dayEt)
        return dayEt[2]
    },
    weekEt () {
      if(!this.activeSite || !this.date || !this.activeSite.et[this.year])
        return
      var yearEt = this.activeSite.et[this.year]
      var xs = []
      var ys = []
      for(var i=0;i<7;i++){
        var day = this.day - i
        if(day <= 0)
          break
        var date = new Date(new Date(this.year, 0, 1).getTime() + 86400000 * (day - 1))
        xs.unshift(DateForm(date, "isoDate"))
        if(yearEt[day]){
          ys.unshift(yearEt[day][2])
        }else{
          ys.unshift(null)
        }
      }
      return [xs, ys]
    },
    growingDays () {
      var start = this.growingSeason[0].split('-')
      var startDate = new Date(this.year, start[0]-1, start[1], 1)
      var startDay = Math.ceil((startDate - new Date(this.year, 0, 1)) / 86400000)
      var end = this.growingSeason[1].split('-')
      var endDate = new Date(this.year, end[0]-1, end[1], 1)
      var endDay = Math.ceil((endDate - new Date(this.year, 0, 1)) / 86400000)
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
      for(var i=this.growingDays[0];i<=this.growingDays[1];i++){
        var day = i
        var date = new Date(new Date(this.year, 0, 1).getTime() + 86400000 * (day - 1))
        xs.push(DateForm(date, "isoDate"))
        if(yearEt[day]){
          sum += yearEt[day][2]
          ys.push(Math.round(sum * 1000)/1000)
          nonzero = day - this.growingDays[0]
        }else{
          ys.push(Math.round(sum * 1000)/1000)
        }
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
      return [xs, ys, line, value]
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
    weekEt: function (val) {
      if(val){
        this.$nextTick(function(){
          this.drawWeekEt()
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
    drawWeekEt () {
      var columns = [this.weekEt[0].slice(0), this.weekEt[1].slice(0)]
      columns[0].unshift('x')
      columns[1].unshift('Avg. Daily ET')
      if(this.weekChart){
        this.weekChart.load({
          columns: columns
        })
      }else{
        this.weekChart = c3.generate({
          bindto: '#weekChart',
          data: {
            x: 'x',
            columns: columns,
          },
          axis: {
            x: {
              type: 'timeseries',
              tick: {
                count: 4,
                format: '%Y-%m-%d'
              }
            },
            y: {
              label: {text: 'Average Daily ET (mm/day)'}
            },
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

      this.growingChart = c3.generate({
        bindto: '#growingChart',
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
          },
          y: {
            label: {text: 'Accumulated Value of Growing Season'}
          },
        },
        grid: {x: {lines: lines}}
      })
    }
  },
  mounted () {
    
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.main-window {
  padding-top: 5px;
  padding-left: 0px;
  padding-right: 0px;
}

.map-options {
  margin: 0px;
  text-align: center;
}

.date-picker-column {
  padding-top: 6px;
}

.map-window {
  margin-top: -5px;
  margin-bottom: 0px;
  margin-left: -20px;
  margin-right: -20px;
}

.data-window {
  margin-top: 15px;
  margin-bottom: 50px;
}

.et-value {
  max-width: 100px;
  overflow: hidden;
}

.chart-container {
  max-width: 800px;
  margin-top: 10px;
}

</style>
