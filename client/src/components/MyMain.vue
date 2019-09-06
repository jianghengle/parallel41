<template>
  <div class="container">
    <div class="home-image-container">
      <img src="/static/HomeBanner.jpg">
      <div class="image-notation">Installation of eddy covariance flux tower in Grant, NE</div>
    </div>
    <div class="content intro">
      <h4 class="p-header">Welcome to the Parallel 41 Flux Network</h4>
      <div class="intro-text">
        <p>Increasing food production in a sustainable way is a global challenge. To do this, we need to get more crop per drop. This means applying the unique amount of water a plant needs, when it needs it, to achieve the best possible yield. To achieve high efficiency precision irrigation, we need to know how much water a plant is using on a daily basis, also known as <strong>evapotranspiration (ET)</strong>.</p>

        <p>Parallel 41 is a free portal to access real-time ET datasets across the mid-western U.S. The data is collected by the latest generation of smart flux towers manufactured by LI-COR Biosciences.</p>

        <p>ET data may be used to measure crop water use, schedule irrigation, assess plant water stress, monitor drought, and calculate water balance and productivity.</p>
      </div>

      <div class="columns boxes">
        <div class="column">
          <router-link :to="'/about'"><img src="/static/Home_ClickBox1.JPG"></router-link>
          <h4 class="p-header"><router-link :to="'/about'">About Parallel 41</router-link></h4>
          <p>Advanced equipment and sensors can analyze the atmosphere at the surface of the earth, where it is interacting with plants. <router-link :to="{ name: 'About', params: { target: 'partners' }}"><strong>Read about our project & methods.</strong></router-link></p>
        </div>
        <div class="column">
          <router-link :to="'/map-data'"><img src="/static/Home_ClickBox2.JPG"></router-link>
          <h4 class="p-header"><router-link :to="'/map-data'">Flux Station Data</router-link></h4>
          <p>Eddy covariance flux towers continually monitor the land surface. We share real time, quality controlled, gap filled, and continuous ET measurements. <router-link :to="'/map-data'"><strong>See our data.</strong></router-link></p>
        </div>
        <div class="column">
          <a><img src="/static/Home_ClickBox3.JPG"></a>
          <h4 class="p-header"><a>Producer Dashboard</a></h4>
          <p>Evapotranspiration and weather data are some of the most useful pieces of information for farmers to manage their fields. <a><strong>Explore our tools for growers.</strong></a></p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import MapData from './MapData'

export default {
  name: 'my-main',
  components: {
    MapData
  },
  data () {
    return {
      ready: true,
    }
  },
  mounted () {
    
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>
.home-image-container {
  position: relative;

  .image-notation {
    position: absolute;
    bottom: 10px;
    right: 10px;
    color: white;
    font-size: 14px;
    font-style: italic;
  }
}

.intro {
  text-align: center;

  .intro-text {
    margin: auto;
    max-width: 800px
  }
}

.p-header{
  font-weight: bold;
  margin-bottom: 0.5em;
  color: #05485a;
  font-weight: 700;
}

.boxes {
  margin-top: 40px;
  margin-bottom: 40px;

  h4 {
    margin-top: 5px;
  }

  p {
    margin-top: -7px;
  }

  a {
    color: #05485a;
  }
}
</style>
