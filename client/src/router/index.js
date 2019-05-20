import Vue from 'vue'
import Router from 'vue-router'
import MyMain from '@/components/MyMain'
import About from '@/components/About'
import PartnersNProjects from '@/components/PartnersNProjects'
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
      path: '/partners_n_projects',
      name: 'PartnersNProjects',
      component: PartnersNProjects
    },
    {
      path: '/documentation',
      name: 'Documentation',
      component: Documentation
    }
  ]
})
