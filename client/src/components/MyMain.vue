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
      </gmap-map>
    </div>

    <div class="map-options columns">
      <div class="column date-picker-column">
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
</template>

<script>
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'

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
      date: new Date()
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    mapHeightPx () {
      return this.mapHeight + 'px'
    },
  },
  methods: {
    mapCenterChanged (center) {
      this.newMapCenter = {lat: center.lat(), lng: center.lng()}
    },
    mapZoomChanged (zoom) {
      this.mapZoom = zoom
    },
    dateSelected (newDate) {
      this.date = newDate
      this.requestDays(newDate)
    },
    requestDays (date) {
      
    },
    selectPreDate () {
      if(this.preDate){
        this.dateSelected(this.preDate)
      }
    },
    selectNextDate () {
      if(this.nextDate){
        this.dateSelected(this.nextDate)
      }
    },
  },
  mounted () {
    
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.main-window {
  padding-top: 5px;
  padding-bottom: 20px;
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

</style>
