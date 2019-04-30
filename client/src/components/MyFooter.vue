<template>
  <div>
    <footer class="footer">
      <div class="container">
        <div class="content has-text-centered">
          <a href="http://waterforfood.nebraska.edu/"><img src="static/logos/DWFI.png" width="250" class="logo dwfi"></a>
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

.dwfi {
  position: relative;
  top: 20px;
  left: -10px;
}

</style>
