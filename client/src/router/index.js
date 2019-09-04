import Vue from 'vue'
import Router from 'vue-router'
import MyMain from '@/components/MyMain'
import About from '@/components/About'
import MapData from '@/components/MapData'
import Documentation from '@/components/Documentation'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'MyMain',
      component: MyMain
    },
    {
      path: '/about',
      name: 'About',
      component: About
    },
    {
      path: '/map-data',
      name: 'MapData',
      component: MapData
    },
    {
      path: '/documentation',
      name: 'Documentation',
      component: Documentation
    }
  ]
})
