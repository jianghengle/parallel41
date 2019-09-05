<template>
  <div>
    <div class="top-bar">
      <div class="container">
        <div class="top-bar-left">
          <a class="university-name is-hidden-mobile" href="https://www.unl.edu/">
            UNIVERSITY OF NEBRASKA
          </a>
        </div>

        <!--<div class="top-bar-right">
          <router-link class="top-bar-item" :to="'/help'">
            <span class="nav-icon"><icon name="question"></icon></span>Help
          </router-link>
          <router-link v-if="!token" class="top-bar-item" :to="'/login'">
            <span class="nav-icon"><icon name="sign-in"></icon></span>Login
          </router-link>
          <a v-if="token" class="top-bar-item" @click="logout">
            <span class="nav-icon"><icon name="sign-out"></icon></span>Logout
          </a>
        </div>-->
      </div>
    </div>

    <nav class="navbar container">
      <div class="navbar-brand">
        <router-link class="navbar-item app-name" :to="'/'">
          <img src="static/logo.png" class="app-logo">&nbsp;
          <span class="app-main-name">Parallel 41</span>
          <span class="app-sub-name">Flux Network</span>
        </router-link>
        <div class="navbar-burger burger" :class="{'is-active': menuActive}"
          @click="menuActive = !menuActive">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>

      <div class="navbar-menu" :class="{'is-active': menuActive}">
        <div class="navbar-end">
          <router-link class="navbar-item menu-item" :class="{'active-menu': routePath=='/'}" :to="'/'">
            Home
          </router-link>
          <router-link class="navbar-item menu-item" :class="{'active-menu': routePath=='/about'}" :to="'/about'">
            About
          </router-link>
          <router-link class="navbar-item menu-item" :class="{'active-menu': routePath=='/map-data'}" :to="'/map-data'">
            Flux Stations
          </router-link>
          <router-link class="navbar-item menu-item" :class="{'active-menu': routePath=='/help'}" :to="'/help'">
            Producer Dashboard
          </router-link>
          <router-link class="navbar-item menu-item" :class="{'active-menu': routePath=='/documentation'}" :to="'/documentation'">
            Resources
          </router-link>
        </div>
      </div>
    </nav>
    <div class="color-seperator"></div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'my-header',
  data () {
    return {
      menuActive: false
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    username () {
      return this.$store.state.user.firstName
    },
    role () {
      return this.$store.state.user.role
    },
    routePath () {
      return this.$route.path
    },
  },
  methods: {
    logout () {
      delete Vue.http.headers.common['Authorization']
      this.$store.commit('user/reset')
      this.$router.push('/login')
      this.$nextTick(function(){
        this.$store.commit('tiles/setSetting', null)
      })
    },
  }
}
</script>

<style lang="scss" scoped>

.top-bar {
  background-color: #0e485a;
  color: white;
  height: 41px;


  .top-bar-left {
    float: left;
    margin-left: 20px;

    .university-name {
      line-height: 41px;
      color: white;
      font-size: 12pt;
      font-weight: 600;
      letter-spacing: .05em;
    }

    .university-name:hover {
      color: #eeeeee;
    }
  }

  .top-bar-right {
    float: right;
    margin-right: 10px;

    .top-bar-dropdown {
      margin-right: 10px;
      line-height: 41px;

      .username {
        color: white;
        font-size: 12pt;
        font-weight: 600;
      }

      .username:hover {
        color: #eeeeee;
      }

      .user-dropdown {
        width: 120px;
        min-width: 120px;
        position: relative;
        top: -2px;
        left: -10px;
      }
    }

    .top-bar-item {
      margin-left: 20px;
      color: white;
      font-size: 12pt;
      font-weight: 600;
      line-height: 41px;

      &.not-the-last {
        margin-right: 20px;
      }
    }

    .top-bar-item:hover {
      color: #eeeeee;
    }
  }
}

.nav-icon {
  position: relative;
  top: 3px;
  right: 5px;
}

.app-name {
  width: 300px;

  .app-logo {
    max-height: 70px;
    height: 70px;
    width: 65px;
  }

  .app-main-name {
    font-size: 32px;
    color: #0e485a;
    font-family: "Arial Black", Gadget, sans-serif;
    position: relative;
    top: -10px;
    white-space: nowrap;
  }

  .app-sub-name {
    font-size: 20px;
    color: #0e485a;
    font-family: futura-pt-condensed,Futura PT Cond,futura-lt-condensed,sans-serif;
    position: relative;
    top: 24px;
    left: -120px;
    white-space: nowrap;
  }
}

.menu-item {
  color: #0e485a;
  font-family: futura-pt-condensed,Futura PT Cond,futura-lt-condensed,sans-serif;
  font-size: 18px;
  font-weight: bold;
}

.active-menu {
  background-color: hsl(0, 0%, 96%);
}

.color-seperator{
  height: 5px;
  background: linear-gradient(90deg,#b19844 0,#97a05c 33%,#6fac7f 64%,#17c7d0)
}
</style>
