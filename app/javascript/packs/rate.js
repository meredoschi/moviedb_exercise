import Vue from 'vue/dist/vue.esm'
import Rate from '../rate.vue'
//import axios from 'axios';
import axios from 'axios-on-rails';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rate',
    data (){

      return{
        rating : {
          user_id: '',
          movie_id: '',
          stars: ''
        },
        current_user_id: 0,
        current_movie_id: 0,
        score: 0, // current score
        movies_jsn:[],
        errors: []
      }

    },
    // https://alligator.io/vuejs/rest-api-axios/
    // https://stackoverflow.com/questions/54757510/how-to-delete-a-record-in-rails-api-and-vue-js
    created() {
      this.getmovies()
    },
    // https://forum.vuejs.org/t/select-element-by-id/21213/7
    mounted() {
        this.current_user_id = this.$el.getAttribute('data-id');
  //    current_user_id: document.getElementById("current-user");
  //    console.log(current_user_id);
//      console.log(this);
  //    console.log(this.current_user_id.getAttribute('data-value'));
    //  console.log("Info: ",current_user_id)

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
      },
        rate_movie: function (movie) {
            // movie = current movie object
            // console.log(this.current_user_id);
            // console.log(movie.id);
            // console.log(this.score);
            console.log('user_id: '+this.current_user_id+', movie_id: '+movie.id, 'stars: '+this.score)

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
