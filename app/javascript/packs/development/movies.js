/* eslint no-console: 0 */

import Vue from 'vue'
import App from '../../components/development/movies.vue'

import EvaIcons from 'vue-eva-icons'

Vue.use(EvaIcons)
document.addEventListener('DOMContentLoaded', () => {
  const movies_app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(movies_app.$el)

  console.log(movies_app)
})
