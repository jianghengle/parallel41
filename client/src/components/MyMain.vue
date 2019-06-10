<template>
  <div class="container">
    <div class="content">
      <h4 class="p-header">Welcome to the Parallel 41 Flux Network</h4>
      <div>
        <p>Parallel 41 is a free portal to view and download real-time evapotranspiration (ET) datasets across the mid-western United States. The data is collected by the latest generation of smart flux towers manufactured by LI-COR Biosciences. Datasets may be downloaded at 30 minute time intervals, or as daily averages.</p>

        <p>Applications of this data include measurements of crop water use, assessment of plant water stress, drought monitoring, irrigation scheduling, and basin-wide water accounting and water productivity analysis.</p>

        <h4 class="p-header">Network Development and Citation</h4>
        <p>Information on the Parallel 41 Flux Network development and citation instruction is available. <router-link :to="'/about'">Discover more about Parallel 41</router-link>.</p>

        <h4 class="p-header">Training Resources</h4>
        <p>Instructional guides, training videos and other resources are available. <router-link :to="'/documentation'">See our documentation</router-link>.</p>

        <h4 class="p-header">Partners and Projects</h4>
        <p>Many partners contribute to the Parallel 41 expansive dataset, and projects descriptions are presented to provide a better understanding of how the information is being utilized. <router-link :to="'/partners_n_projects'">View our partners and projects</router-link>.</p>

        <h4 class="p-header">Get Started</h4>
        <p>In order to download Parallel 41 datasets, you must sign-up for a user account. Click the <router-link :to="'/login'">login button</router-link> in the top right corner to start exploring. To quickly learn how to use the Parallel 41 website features, read our <a href="static/GloDET Quick Start Guide.pdf" target="_blank">Quick Start Guide</a>.</p>
      </div>
    </div>
    <map-data></map-data>
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
.p-header{
  font-weight: bold;
  margin-bottom: 0.5em;
  color: #05485a;
  font-weight: 700;
}
</style>
