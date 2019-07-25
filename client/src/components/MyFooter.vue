<template>
  <div>
    <footer class="footer">
      <div class="container">
        <div class="content has-text-centered">
          <a href="http://waterforfood.nebraska.edu/" target="_blank"><img src="static/logos/DWFI.png" width="250" class="logo dwfi"></a>
          <a href="https://irrigationinnovation.org/" target="_blank"><img src="static/logos/IIC.png" width="250" class="logo"></a>
          <a href="https://www.licor.com/" target="_blank"><img src="static/logos/LiCOR.png" width="250" class="logo"></a>
        </div>
        <div class="content has-text-centered">
          <a href="https://www.climate.com/" target="_blank"><img src="static/logos/TCC.png" width="250" class="logo"></a>
          <a href="https://www.nebraskawaterbalance.com/" target="_blank"><img src="static/logos/NEWBA.png" width="100" class="logo newba"></a>
          <a href="https://www.urnrd.org/" target="_blank"><img src="static/logos/URNRD.png" width="250" class="logo"></a>
          <a href="https://hprcc.unl.edu/" target="_blank"><img src="static/logos/HPRCC.png" width="100" class="logo hprcc"></a>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'my-footer',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  }
}
</script>

<style lang="scss" scoped>

.logo {
  padding: 10px;
}

.dwfi {
  position: relative;
  top: 20px;
  left: -10px;
}

.newba {
  margin-left: 50px;
  margin-right: 50px;
}

.hprcc {
  margin-left: 50px;
  margin-right: 50px;
}

</style>
