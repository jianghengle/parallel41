<template>
  <div id="app" v-if="ready">
    <my-header></my-header>
    <div class="main-body">
      <router-view></router-view>
    </div>
    <my-footer></my-footer>
  </div>
</template>

<script>
import Vue from 'vue'
import MyHeader from './components/MyHeader'
import MyMain from './components/MyMain'
import MyFooter from './components/MyFooter'

export default {
  name: 'app',
  components: {
    MyHeader,
    MyFooter
  },
  data () {
    return {
      ready: false
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    }
  },
  mounted () {
    if(this.token){
      Vue.http.headers.common['Authorization'] = this.token
    }
    this.ready = true
  }
}
</script>

<style lang="scss">
@import "~bulma/sass/utilities/initial-variables";
$primary: #0e485a;
$navbar-height: 117px;
$navbar-item-hover-color: #0e485a;
@import "~bulma";
@import "~c3/c3.css";

body {
  font-family: Futura-pt,Futura PT,Trebuchet MS,Arial,sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.main-body {
  min-height: 480px;
  padding-left: 10px;
  padding-right: 10px;

  .content {
    margin-top: 30px;
  }
}

.date-picker-wrapper {
  display: inline-block;
}

.date-picker-input{
  cursor: pointer;
  height: 35px;
  width: 120px;
  text-align: center;
  font-size: 1rem;
}

.c3-region.regionX {
  fill: red;
}

</style>
