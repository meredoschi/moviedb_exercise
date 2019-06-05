import Vue from 'vue/dist/vue.esm'
import Rate from '../rate-app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rate',
    data: {
    },
    components: { Rate }
  })
})
