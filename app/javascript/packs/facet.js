import Vue from 'vue/dist/vue.esm';
//import axios from 'axios';
import axios from 'axios-on-rails';

// https://www.npmjs.com/package/vue-star-rating
import StarRating from 'vue-star-rating'
Vue.component('star-rating', StarRating)

import vSelect from 'vue-select';
Vue.component('v-select', vSelect);
import 'vue-select/dist/vue-select.css';

import EvaIcons from 'vue-eva-icons'
Vue.use(EvaIcons)

import VueRamda from 'vue-ramda'
Vue.use(VueRamda)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#facet',
    data() {

      return {
        all_label: '--- All ---',
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
        currentPage: 1

      }

    },
    computed: {



      on_the_first_page: function() {
        return (this.currentPage == 1);

      },

      at_the_last_page: function() {
        return (this.currentPage == app.number_of_pages_needed_for_pagination);

      },

      number_of_pages_needed_for_pagination: function() {
        return Math.ceil(app.number_of_filtered_movies_without_pagination / this.pageSize);

      },

      pagination_needed: function() {
        return (app.number_of_pages_needed_for_pagination > 1);

      },

      total_number_of_movies: function() {
        return this.movies_jsn.length;
      },

      filtered_movies_total: function() {
        return this.filteredMovies.length;
      },

      user_logged_in: function() {

        return (app.current_user_id > 0);

      },
      visitor: function() {

        return !app.user_logged_in

      },

      filteredMoviesWithoutPagination: function() {

        // This would search by movie title as well (for pagination, add filter below)
        // return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn))));
        // <p>Search: <input v-model="search_title_txt" placeholder="Movie titles"></p>

        return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn))))

      },
      movieCategoriesWithRepeats: function() {
        let names = []
        //  let cat = { name: '', freq: 0 }
        let sep = ';' // csv separator
        this.movies_jsn.forEach(function(element) {
          names.push(element.category.name);
        });

        let sorted_names = names.sort() // with repetitions
        // console.log(sorted_names)
        return sorted_names;

      },

      // https://stackoverflow.com/questions/19395257/how-to-count-duplicate-value-in-an-array-in-javascript
      category_name_options_revised: function() {
        let arr = [];

        var counts = {};
        app.movieCategoriesWithRepeats.forEach(function(x) {
          counts[x] = (counts[x] || 0) + 1;
        });


        // https://stackoverflow.com/questions/14379274/how-to-iterate-over-a-javascript-object/14379304
        for (let [key, value] of Object.entries(counts)) {
          let category_name_with_count = key + ' (' + value + ')'
          // console.log(category_name_with_count);
          arr.push(category_name_with_count)
        }

        return (arr);

      },

      movieCategoryCounts: function() {

        var counts = {};
        app.movieCategoriesWithRepeats.forEach(function(x) {
          counts[x] = (counts[x] || 0) + 1;
        });


        // https://stackoverflow.com/questions/14379274/how-to-iterate-over-a-javascript-object/14379304
        for (let [key, value] of Object.entries(counts)) {
          // console.log(key + ' (' + value + ')');
        }

        return (counts);

      },


      number_of_filtered_movies_without_pagination: function() {

        // This would search by movie title as well (for pagination, add filter below)
        // return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn))));
        // <p>Search: <input v-model="search_title_txt" placeholder="Movie titles"></p>

        return app.filteredMoviesWithoutPagination.length

      },

      number_of_filtered_movies_with_pagination: function() {

        // This would search by movie title as well (for pagination, add filter below)
        // return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn))));
        // <p>Search: <input v-model="search_title_txt" placeholder="Movie titles"></p>

        return app.filteredMovies.length

      },

      filteredMovies: function() {

        return app.filteredMoviesWithoutPagination.
        // filter added for pagination, as in: https://www.raymondcamden.com/2018/02/08/building-table-sorting-and-pagination-in-vuejs
        filter((row, index) => {
          let start = (this.currentPage - 1) * this.pageSize;
          let end = this.currentPage * this.pageSize;
          if (index >= start && index < end) return true;
        });

      },
      category_names_with_counts: function() {

        let cat_names_raw = [];
        let cat_names = [];
        //              cat_names.push(this.all_label);
        for (var i = 0; i < this.total_number_of_movies; i++) {
          let name = this.movies_jsn[i].category.name
          //  if (category_names.includes(name) === false) {
          cat_names_raw.push(name);

        }

        let elements = cat_names_raw.reduce((b, c) => ((b[b.findIndex(d => d.el === c)] || b[b.push({
          el: c,
          count: 0
        }) - 1]).count++, b), []);
        // console.log(elements);

        for (var j = 0; j < elements.length; j++) {
          //  // console.log(elements[j].el+' ('+elements[j].count+')');
          cat_names.push(elements[j].el + ' (' + elements[j].count + ')');
        }

        // console.log(cat_names);
        return cat_names.sort();



      },
      category_names: function() {
        let category_names = [];
        for (var i = 0; i < this.total_number_of_movies; i++) {
          let name = this.movies_jsn[i].category.name
          if (category_names.includes(name) === false) {
            category_names.push(name);
          }

        }

        return category_names.sort();


      },
      category_name_options: function() {
        let arr = [];
        arr.push(this.all_label);
        arr.push(this.category_names_with_counts);
        // console.log(this.category_names_with_counts);

        return arr.flat();
      },

      all_movie_ratings: function() {
        let ratings = [];


        this.movies_jsn.forEach(function(movie) {
          ratings.push(movie.ratings);
        });

        console.log(ratings);
        return ratings;

      },
      average_ratings: function() {
        let avg_ratings = [];

        // https://stackoverflow.com/questions/30176604/nested-foreach-loop-does-not-work

        this.movies_jsn.forEach(function(movie){
          avg_ratings.push({movie_id: movie.id, stars: movie.stars})
        })

        return avg_ratings;

        // https://stackoverflow.com/questions/27281405/group-by-object-ids-in-javascript/27281586
      },

      // https://ramdajs.com/docs/#reduce
      movies_by_rating_scale: function() {


        const groupMovieIds = (acc, {movie_id}) => acc.concat(movie_id)
        const ratingScale = ({stars}) =>
        stars < 1 ? '0' :
        stars < 2 ? '1' :
        stars < 3 ? '2' :
        stars < 4 ? '3' :
        stars < 5 ? '4' : '5'

        let res=this.$R.reduceBy(groupMovieIds, [], ratingScale, this.average_ratings)
        return res ;

      },

      rating_scale_counts: function() {

        let arr=[]

        for (let [key, value] of Object.entries(this.movies_by_rating_scale)) {
           console.log(key + ' (' + value.length + ')');
           arr.push(key + ' (' + value.length + ')');
        }

        return arr.sort((a, b) => b - a); // descending
        // https://stackoverflow.com/questions/1063007/how-to-sort-an-array-of-integers-correctly

      },
      rating_options: function() {
        let arr = [];
        arr.push(this.all_label);
//        let levels = ['5', '4', '3', '2', '1'];
        let levels=this.rating_scale_counts

        arr.push(levels);
        return arr.flat();

//        return arr.flat().sort((a, b) => a - b)
//        return arr.flat().sort((a, b) => a - b);
      },
    },
    // https://alligator.io/vuejs/rest-api-axios/
    // https://stackoverflow.com/questions/54757510/how-to-delete-a-record-in-rails-api-and-vue-js
    created() {
      // https://forum.vuejs.org/t/how-to-get-id-value-in-vue-js/44999
      let user_id = document.querySelector('#current_user').dataset.value;
      //      // console.log(user_id);
      this.current_user_id = user_id;
      this.getmovies();
    },
    // https://forum.vuejs.org/t/select-element-by-id/21213/7
    mounted() {

    },
    methods: {
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
            let movie_average = app.average_rating(movie);

            console.log(selected_rating);
            console.log('selected');
            console.log(selected_rating[0]*1);
            return ((movie_average >= selected_rating[0]*1) && (Math.abs(selected_rating[0]*1 - movie_average) < 1));

          } else {
            return true;
          }

        });

      },
      moviesByCategory(movies) {
        return movies.filter((movie) => {
          //          // console.log(movie.category.name);

          if ((this.selected_category != '') && (this.selected_category != this.all_label)) {

            return this.selected_category.includes(movie.category.name);
          } else {
            return true;
          }

        });

      },

      // get the average rate (number of stars)
      average_rating(movie) {
        if (movie.ratings.length > 0) {

          let score = app.total_stars(movie) / app.number_of_ratings(movie);
          return Math.round(score * 10) / 10;
        } else
        return 0;

        //        return total_stars(movie)/number_of_ratings(movie) ;
        //    else
        //      return 0;
        //    end
      },

      selected_rating_as_numeric(movie) {
        return this.selected_rating[0]*1;
      },
      number_of_ratings(movie) {
        return movie.ratings.length;
      },
      total_stars(movie) {
        let movie_ratings = movie.ratings;
        let total_stars = 0;
        movie_ratings.forEach(function(movie_rating) {
          total_stars += movie_rating.stars;
        });
        return total_stars;
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

        // https://stackoverflow.com/questions/54156534/how-to-create-alert-confirm-box-in-vue
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
      }

    },
    // https://stackoverflow.com/questions/50169210/vuejs-redirect-to-url-when-clicked-on-a-button
    components: {}

  })

})
