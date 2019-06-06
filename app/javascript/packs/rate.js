import Vue from 'vue/dist/vue.esm'
import Rate from '../rate.vue'
import axios from 'axios';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rate',
    data: {
      errors: [],
      movies_jsn: []
    },
    // https://alligator.io/vuejs/rest-api-axios/
    created() {
      axios.get(`/movies.json`).then(response => {
        this.movies_jsn = response.data
      }).catch(e => {
        this.errors.push(e)
      })
    },
    // https://stackoverflow.com/questions/50169210/vuejs-redirect-to-url-when-clicked-on-a-button
    components: { Rate }
    //    ,
    // https://stackoverflow.com/questions/44440708/vue-js-templating-and-interpolation-not-rendering-data
    //    delimiters: ["((","))"]
  })


  axios.get('/movies.json')
  .then(function (response) {
    // handle success
    console.log(response);
  })
})
