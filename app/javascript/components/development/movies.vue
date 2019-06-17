<template>
  <div id="app-movies">

    <!--

    <table v-if="(filteredMovies.length>0)" class="table table-striped" id="movies-table">

    <table class="table table-striped" id="movies-table">

  -->

    <table class="table table-striped" id="movies-table">


      <thead class="thead-dark">
        <tr>
          <th>Title</th>
          <th>Text</th>
          <th>Ratings</th>

        <!--
        <th v-if="user_logged_in"></th>
      -->
          <th></th>
          <th>Category</th>

          <th colspan="3"></th>
        </tr>
      </thead>

        <tbody>
          <template v-for="(movie, index) in movies_jsn">

            <tr>
              <td><a v-bind:id="`title-${movie.id}`" v-bind:href="`movies/${movie.id}`">{{ movie.title }}</a></td>
              <td><a v-bind:id="`summary-${movie.id}`" v-bind:href="`movies/${movie.id}`">{{ movie.summary }}</a></td>

              <td>

              {{ average_rating(movie)}}

                <eva-icon name="star" fill="#05e5d6" animation="pulse" height="22">
                </eva-icon>

              </td>

              <td>

            <!--

            <template v-if="(rating_stars_visible(movie)) ">

            <star-rating v-model="rating" v-bind:star-size="18" active-color="#ebf442" @rating-selected ="rate_movie(movie)"></star-rating>

          </template>

             -->

             </td>

             <td>{{ movie.category["name"] }}</td>

             <td>
               <a v-bind:id="`show-${movie.id}`" v-bind:href="`movies/${movie.id}`" >
               <button type="button" class="btn btn-primary">Show
               </button>
               </a>
             </td>


             <td>

        <!--

        <a v-if="owner(movie)" v-bind:id="`edit-${movie.id}`" v-bind:href="`movies/${movie.id}/edit`" >
        <button type="button" class="btn btn-warning">Edit
      </button>
    </a>

    -->

            </td>

            <td>

      <!--

      <td v-on:click="invoke_destroy(movie)" v-if="owner(movie)" v-bind:id="`destroy-${movie.id}`"><button type="button" class="btn btn-danger">Remove</button></td>

    -->

            </td>

          </tr>

        </template>     <!-- v-for loop end  -->
      </tbody>
    </table>

  </div>
</template>

<script>

import axios from 'axios-on-rails';
import StarRating from 'vue-star-rating'
import vSelect from 'vue-select';
import 'vue-select/dist/vue-select.css';
import EvaIcons from 'vue-eva-icons'
import VueRamda from 'vue-ramda'

export default {


  data: function () {


    return {

      all_label: '--- All ---',
      highest_rating: '5',
      search_title_txt: '',
      search_summary_txt: '',
      selected_category: '',
      selected_rating: '',
      rating: 0,
      current_user_id: 0,
      movies_jsn: [],
      errors: [],
      // https://www.raymondcamden.com/2018/02/08/building-table-sorting-and-pagination-in-vuejs
      pageSize: 10,
      currentPage: 1,
      movies_jsn: [],
      //
      movie_ids_recently_rated: []
    }


  },
  computed: {

    average_ratings: function() {
        // https://stackoverflow.com/questions/41762429/javascript-map-multiple-values-into-list
        return this.movies_jsn.map(movie => new Object({movie_id: movie.id, stars: movie.stars}))
    },

  },

  methods: {


    getmovies() {
      let url = `/movies.json`;
      axios.get(url).then(response => {
        this.movies_jsn = response.data
      })
      .catch(e => {
        this.errors.push(e)
      })
    },

      average_rating(movie) {

        // find the individual movie rating
        let movie_rating=this.average_ratings.find(rating => rating.movie_id === movie.id)
        // e.g. { "movie_id": 1, "stars": 1 }

        return movie_rating.stars ;

        }


  },
  // https://alligator.io/vuejs/rest-api-axios/
  // https://stackoverflow.com/questions/54757510/how-to-delete-a-record-in-rails-api-and-vue-js
  created() {
    // https://forum.vuejs.org/t/how-to-get-id-value-in-vue-js/44999
    let user_id = document.querySelector('#current_user').dataset.value;
    this.current_user_id = user_id;
    this.getmovies();
  },
  components: {

  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
