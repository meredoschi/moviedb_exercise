<template>
  <div id="app-movies">
    <br>
    <div class="container bg-light">

          <h5>Average rating
            <v-select id="rating_select" v-model="selected_rating" :options="rating_options"></v-select>
          </h5>

          <h5>Category
            <v-select id="category_select" v-model="selected_category" :options="category_name_options" label="category"></v-select>
          </h5>

          <h5 class="text-left"><input id="search_text" v-model="search_summary_txt" placeholder="Search text"></h5>

    </div>

    <br>

          <!--

          <p>Average rating
             <eva-icon name="star" fill="yellow" animation="pulse" height="22">
             </eva-icon>
          </p>
            <p>Search:</p>
              <p><input id="search_text" v-model="search_summary_txt" placeholder="Movie text contents"></p>


    <table v-if="(filteredMovies.length>0)" class="table table-striped" id="movies-table">

    <table class="table table-striped" id="movies-table">

  -->

  <div class="container">

    <div v-if="pagination_needed">

      <h6 class="text-right">Page: {{ currentPage }} / {{  number_of_pages_needed_for_pagination }}</h6>
      <br>
    </div>

  <table v-if="(filteredMovies.length>0)" class="table table-striped" id="movies-table">


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
    <template v-for="(movie, index) in filteredMovies" v-bind:id="movie.id">

      <tr>
        <td><a v-bind:id="`title-${movie.id}`" v-bind:href="`movies/${movie.id}`">{{ movie.title }}</a></td>
        <td><a v-bind:id="`summary-${movie.id}`" v-bind:href="`movies/${movie.id}`">{{ movie.summary }}</a></td>

        <td>

          {{ average_rating(movie)}}

          <eva-icon name="star" fill="#05e5d6" animation="pulse" height="22">
          </eva-icon>

        </td>

        <td>

          <template v-if="(rating_stars_visible(movie)) ">

            <star-rating v-model="rating" v-bind:star-size="18" active-color="#ebf442" @rating-selected ="rate_movie(movie)"></star-rating>

          </template>

        </td>

        <td>{{ movie.category["name"] }}</td>

        <td>
          <a v-bind:id="`show-${movie.id}`" v-bind:href="`movies/${movie.id}`" >
            <button type="button" class="btn btn-primary btn-sm">Show
            </button>
          </a>
        </td>


        <td>


          <a v-if="owner(movie)" v-bind:id="`edit-${movie.id}`" v-bind:href="`movies/${movie.id}/edit`" >
            <button type="button" class="btn btn-warning btn-sm">Edit
            </button>
          </a>


          <td>

            <p v-on:click="invoke_destroy(movie)" v-if="owner(movie)" v-bind:id="`destroy-${movie.id}`"><button type="button" class="btn btn-danger btn-sm">Remove</button>
            </p>
          </td>

      </tr>

    </template>     <!-- v-for loop end  -->
  </tbody>
</table>

<!-- Pagination info  -->

<div v-if="pagination_needed">
  <p class="text-left">
    <button type="button" class="btn btn-info btn-sm" v-if="!on_the_first_page" @click="prevPage">Previous page</button>
    <button type="button" class="btn btn-info btn-sm" v-if="!at_the_last_page" @click="nextPage">Next page</button>
  </p>

</div>

<h5 v-if="(filteredMovies.length==0)" class="text-warning">No records found with the selected search criteria.</h5>

</div> <!-- table container (bootstrap)  -->

</div> <!-- App  -->
</template>

<script>

import axios from 'axios-on-rails'
import StarRating from 'vue-star-rating'
import vSelect from 'vue-select'
import 'vue-select/dist/vue-select.css'
import EvaIcons from 'vue-eva-icons'
import * as R from 'ramda'
// import VueRamda from 'vue-ramda'

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

    on_the_first_page: function() {
      return (this.currentPage == 1);

    },

    at_the_last_page: function() {
      return (this.currentPage == this.number_of_pages_needed_for_pagination);

    },

    number_of_pages_needed_for_pagination: function() {
      return Math.ceil(this.number_of_filtered_movies_without_pagination / this.pageSize);

    },

    pagination_needed: function() {
      return (this.number_of_pages_needed_for_pagination > 1);

    },

    total_number_of_movies: function() {
      return this.movies_jsn.length;
    },

    filtered_movies_total: function() {
      return this.filteredMovies.length;
    },


    all_ratings: function() {
      return this.movies_jsn.map(movie => movie.ratings).flat()
    },

    average_ratings: function() {
      // https://stackoverflow.com/questions/41762429/javascript-map-multiple-values-into-list
      return this.movies_jsn.map(movie => new Object({movie_id: movie.id, stars: movie.stars}))
    },

    user_logged_in: function() {

      return (this.current_user_id > 0);

    },
    visitor: function() {

      return !this.user_logged_in

    },

    filteredMoviesWithoutPagination: function() {

      return this.movieTitleContainsText(this.movieSummaryContainsText(this.moviesByCategory(this.moviesByRating(this.movies_jsn))))

    },

    movieCategoriesWithRepeats: function() {

      return this.category_names.sort() // with repetitions

    },


    number_of_filtered_movies_without_pagination: function() {

      return this.filteredMoviesWithoutPagination.length

    },

    number_of_filtered_movies_with_pagination: function() {

      return this.filteredMovies.length

    },

    filteredMovies: function() {

      return this.filteredMoviesWithoutPagination.
      // filter added for pagination, as in: https://www.raymondcamden.com/2018/02/08/building-table-sorting-and-pagination-in-vuejs
      filter((row, index) => {
        let start = (this.currentPage - 1) * this.pageSize;
        let end = this.currentPage * this.pageSize;
        if (index >= start && index < end) return true;
      });

    },

    // unsorted, includes repeats
    category_names: function() {

      return this.movies_jsn.map(movie => movie.genre);

    },

    category_names_with_counts: function() {

      let genres_with_counts=[]

      // https://gist.github.com/ralphcrisostomo/3141412
      let categories = this.category_names.reduce((b, c) => ((b[b.findIndex(d => d.el === c)] || b[b.push({
        el: c,
        count: 0
      }) - 1]).count++, b), []);

      for (var j = 0; j < categories.length; j++) {
        genres_with_counts.push(categories[j].el + ' (' + categories[j].count + ')');
      }


      return genres_with_counts.sort();


    },

    category_name_options: function() {
      let arr = [];
      arr.push(this.all_label);
      arr.push(this.category_names_with_counts);

      return arr.flat();
    },
    average_ratings: function() {
      let avg_ratings = [];

      // https://stackoverflow.com/questions/30176604/nested-foreach-loop-does-not-work

      this.movies_jsn.forEach(function(movie) {
        avg_ratings.push({
          movie_id: movie.id,
          stars: movie.stars
        })
      })

      return avg_ratings;

      // https://stackoverflow.com/questions/27281405/group-by-object-ids-in-javascript/27281586
    },
    // https://ramdajs.com/docs/#reduce
    movies_by_rating_scale: function() {


      const groupMovieIds = (acc, {
        movie_id
      }) => acc.concat(movie_id)
      const ratingScale = ({
        stars
      }) =>
      stars < 1 ? '0' :
      stars < 2 ? '1' :
      stars < 3 ? '2' :
      stars < 4 ? '3' :
      stars < 5 ? '4' : '5'

      let res = R.reduceBy(groupMovieIds, [], ratingScale, this.average_ratings)
      return res;

    },

    rating_scale_counts: function() {

      let arr = []

      for (let [key, value] of Object.entries(this.movies_by_rating_scale)) {

        let rating_level = key;
        let number_of_movies = value.length;
        let suffix = ''

        if (rating_level > 1) {
          suffix = 'Stars'
        } else if (rating_level == 1) {
          suffix = 'Star';
        } else {
          suffix = 'Stars [Not yet rated]';
        }

        arr.push(rating_level + ' ' + suffix + ' (' + number_of_movies + ')');
      }

      return arr.sort((a, b) => b - a); // descending
      // https://stackoverflow.com/questions/1063007/how-to-sort-an-array-of-integers-correctly

    },

    rating_options: function() {
        let arr = [];
        arr.push(this.all_label);

        let levels = this.rating_scale_counts

        let first_char=String(levels[0]).slice(0,1)

        // Additional check to enforce descending sorting order (numeric characters)
        if (first_char == this.highest_rating) {

            arr.push(levels);
        } else {
            arr.push(levels.reverse());
        }

        let res=arr.flat()
        return res

    },

  },

  methods: {

    // ratings for a specific movie
    ratings(movie) {

      return this.all_ratings.filter(function (rating) {
        return rating.movie_id == movie.id
      });

    },

    // user ids for those people who rated this movie
    user_ids_rated: function(movie) {

      return this.ratings(movie).map(movie => movie.user_id);

    },

    was_recently_rated_by_user: function(movie) {

      return (this.movie_ids_recently_rated.includes(movie.id));
    },
    already_rated_by_user: function(movie) {
      return (this.user_ids_rated(movie).includes(this.current_user_id * 1));
    },
    // used in the table.  Update and remove buttons only appear for the movie's owner
    owner: function(movie) {
      return (this.current_user_id == movie.user_id);
    },

    // https://www.raymondcamden.com/2018/02/08/building-table-sorting-and-pagination-in-vuejs
    nextPage: function() {
      if ((this.currentPage * this.pageSize) < this.total_number_of_movies) this.currentPage++;
    },
    prevPage: function() {
      if (this.currentPage > 1) this.currentPage--;
    },
    rating_stars_visible: function(movie) {

      let user_logged = this.user_logged_in;
      let not_already_rated = !this.already_rated_by_user(movie.id);
      let not_rated_recently = !this.was_recently_rated_by_user(movie); // i.e. without refresh

      return ((user_logged) && (not_already_rated) && (not_rated_recently));

    },

    getmovies() {
      let url = `/movies.json`;
      axios.get(url).then(response => {
        this.movies_jsn = response.data
      })
      .catch(e => {
        this.errors.push(e)
      })
    },


    invoke_destroy(movie) {

      alert(movie.title + " will be removed from the list.")

      let url = `movies/` + movie.id;
      if (confirm('Are you sure?'))
      axios.delete(url).then(response => {}).catch(e => {
        this.errors.push(e)
      });
      window.location.reload(true);


    },
    rate_movie: function(movie) {

      axios.post('/ratings', {
        user_id: this.current_user_id,
        movie_id: movie.id,
        stars: this.rating
      })

      if (this.rating > 1) {
        alert("You gave '" + movie.title + "' " + this.rating + " stars.")
      } else {
        alert("You rated '" + movie.title + "' just one star.")
      }
      this.rating = 0; // Important: reset number of stars to zero (otherwise they would be appear filled in all rows)
      this.movie_ids_recently_rated.push(movie.id); // Add it to the list of movies recently rated (for responsiveness)
    },

    movieTitleContainsText(movies) {

      return movies.filter((movie) => {

        if (this.search_title_txt != '') {

          let movie_text = movie.title.toUpperCase();
          let search_title_txt_case_insensitive = this.search_title_txt.toUpperCase();

          return movie_text.match(search_title_txt_case_insensitive);

        } else {
          return true;
        }

      });

    },

    movieSummaryContainsText(movies) {

      return movies.filter((movie) => {

        if (this.search_summary_txt != '') {

          let movie_text = movie.summary.toUpperCase();
          let search_summary_txt_case_insensitive = this.search_summary_txt.toUpperCase();
          return movie_text.match(search_summary_txt_case_insensitive);

        } else {
          return true;
        }

      });

    },

    // movies_jsn
    moviesByRating(movies) {

      return movies.filter((movie) => {

        if ((this.selected_rating != '') && (this.selected_rating != this.all_label)) {

          let selected_rating = this.selected_rating;
          let movie_average = this.average_rating(movie);
          return ((movie_average >= selected_rating[0] * 1) && (Math.abs(selected_rating[0] * 1 - movie_average) < 1));

        } else {
          return true;
        }

      });

    },
    moviesByCategory(movies) {
      return movies.filter((movie) => {

        if ((this.selected_category != '') && (this.selected_category != this.all_label)) {

          return this.selected_category.includes(movie.category.name);
        } else {
          return true;
        }

      });

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
  components: { StarRating, vSelect, R

  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
