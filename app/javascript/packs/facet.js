import Vue from 'vue/dist/vue.esm';
//import axios from 'axios';
import axios from 'axios-on-rails';

// https://www.npmjs.com/package/vue-star-rating
import StarRating from 'vue-star-rating'
Vue.component('star-rating', StarRating)

import vSelect from 'vue-select';
Vue.component('v-select', vSelect);
import 'vue-select/dist/vue-select.css';

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
                pageSize: 5,
                currentPage: 1

            }

        },
        computed: {

            filteredMovies: function() {

                // This would search by movie title as well (for pagination, add filter below)
                // return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn))));
                // <p>Search: <input v-model="search_title_txt" placeholder="Movie titles"></p>

                return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn)))).
                // filter added for pagination, as in: https://www.raymondcamden.com/2018/02/08/building-table-sorting-and-pagination-in-vuejs
                filter((row, index) => {
                    let start = (this.currentPage - 1) * this.pageSize;
                    let end = this.currentPage * this.pageSize;
                    if (index >= start && index < end) return true;
                });

            },
            category_names: function() {
                let category_names = [];
                for (var i = 0; i < this.movies_jsn.length; i++) {
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
                arr.push(this.category_names);
                return arr.flat();
            },
            rating_options: function() {
                let arr = [];
                arr.push(this.all_label);
                let levels = ['5', '4', '3', '2', '1'];
                arr.push(levels);
                return arr.flat();
            },
        },
        // https://alligator.io/vuejs/rest-api-axios/
        // https://stackoverflow.com/questions/54757510/how-to-delete-a-record-in-rails-api-and-vue-js
        created() {
            // https://forum.vuejs.org/t/how-to-get-id-value-in-vue-js/44999
            let user_id = document.querySelector('#current_user').dataset.value;
            //      console.log(user_id);
            this.current_user_id = user_id;
            this.getmovies();
        },
        // https://forum.vuejs.org/t/select-element-by-id/21213/7
        mounted() {

        },
        methods: {

            // https://www.raymondcamden.com/2018/02/08/building-table-sorting-and-pagination-in-vuejs
            nextPage: function() {
                if ((this.currentPage * this.pageSize) < this.movies_jsn.length) this.currentPage++;
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
                        return ((movie_average >= selected_rating) && (movie_average - selected_rating <= 1));

                    } else {
                        return true;
                    }

                });

            },
            moviesByCategory(movies) {
                return movies.filter((movie) => {
                    //          console.log(movie.category.name);

                    if ((this.selected_category != '') && (this.selected_category != this.all_label)) {

                        return movie.category.name == this.selected_category;
                    } else {
                        return true;
                    }

                });

            },

            // get the average rate (number of stars)
            average_rating(movie) {
                if (movie.ratings.length > 0) {

                    let score = app.total_stars(movie) / app.number_of_ratings(movie);
                    return Math.round(score * 100) / 100;
                } else
                    return 0;

                //        return total_stars(movie)/number_of_ratings(movie) ;
                //    else
                //      return 0;
                //    end
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
            //        remove_movie(id) {
            //        let url=`http://localhost:3000/movies/` + id;
            //        console.log(url)
            //        this.axios.delete(url).then(response => {
            //          this.movies_json = this.movies_json.filter(movie => movie.id !== id)})
            //          .catch(e => {this.errors.push(e)});
            //          console.log(response)

            rate_movie: function(movie) {

                axios.post('/ratings', {
                    user_id: this.current_user_id,
                    movie_id: movie.id,
                    stars: this.rating
                })
                //    }).then(result => {

                //        console.log(result.data)
                //      })

                //               .catch(function (error) {
                //                 console.log(error);
                //                });

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

    axios.get('/movies.json');
    //    .then(function(response) {
    // handle success
    //      console.log(response);
    //    })

})