/* eslint no-console: 0 */

import Vue from 'vue'
import App from '../components/icons.vue'

import EvaIcons from 'vue-eva-icons'

Vue.use(EvaIcons)
document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})
