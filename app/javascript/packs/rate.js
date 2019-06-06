import Vue from 'vue/dist/vue.esm'
import Rate from '../rate.vue'
//import axios from 'axios';
import axios from 'axios-on-rails';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rate',
    data (){

      return{
        movies_jsn:[],
        errors: []
      }

    },
    // https://alligator.io/vuejs/rest-api-axios/
    // https://stackoverflow.com/questions/54757510/how-to-delete-a-record-in-rails-api-and-vue-js
    created() {
      this.getmovies()
    },
    methods: {
      getmovies () {
        let url=`/movies.json`;
        axios.get(url).then(response => {this.movies_jsn = response.data })
        .catch(e => {this.errors.push(e)})
        
//      },
//      removemovie(id) {
//        let url=`http://localhost:3000/movies/` + id;
//        console.log(url)
//        this.axios.delete(url).then(response => {
//          this.movies_json = this.movies_json.filter(movie => movie.id !== id)})
//          .catch(e => {this.errors.push(e)});
//          console.log(response)
        }

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
