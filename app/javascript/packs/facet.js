import Vue from 'vue/dist/vue.esm';
//import axios from 'axios';
import axios from 'axios-on-rails';

import vSelect from 'vue-select';
Vue.component('v-select', vSelect);
import 'vue-select/dist/vue-select.css';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#facet',
    data (){

      return {
        all_label: '--- All ---',
        // original
        search_title_txt: '',
        search_summary_txt: '',
        selected: undefined,
        selected_category: '',
        selected_rating: '',
        options: ['First','Second','Third'],
        rating : 0,
        current_user_id: 0,
        current_movie_id: 0,
        movies_jsn:[],
        errors: []
      }

    },
    computed: {

      filteredMovies: function() {

        //    return app.moviesByCategory(app.moviesByRating(this.movies_jsn));

        //      return ;

        return app.movieTitleContainsText(app.movieSummaryContainsText(app.moviesByCategory(app.moviesByRating(this.movies_jsn))));

      },

      MoviesFilteredByRating: function() {

        return this.movies_jsn.filter((movie) => {
          //          console.log(movie.category.name);

          if ((this.selected_rating!='') && (this.selected_rating!=this.all_label))
          {

            let selected_rating=this.selected_rating;
            let movie_average=app.average_rating(movie);
            return  ((movie_average>=selected_rating) && (movie_average-selected_rating<=1));

          } else {
            return true;
          }

        });

      },
      MoviesFilteredByCategory: function() {

        return this.movies_jsn.filter((movie) => {
          //          console.log(movie.category.name);

          if ((this.selected_category!='') && (this.selected_category!=this.all_label))
          {

            return movie.category.name==this.selected_category;
          } else {
            return true;
          }

        });
      },
      // a computed getter
      category_names: function () {
        // `this` points to the vm instance
        console.log(this.movies_jsn.category);
        let category_names=[];
        for (var i=0; i<this.movies_jsn.length; i++) {
          //let name=JSON.stringify(this.movies_jsn[i].category.name)
          let name=this.movies_jsn[i].category.name

          console.log(name);
          if(category_names.includes(name) === false) { category_names.push(name); }


          //        category_names.push(cat_name);
        }

        console.log(category_names.sort());

        //  console.log(category_names)


        return category_names.sort();


      },
      category_name_options: function () {
        let arr=[];
        arr.push(this.all_label);
        arr.push(this.category_names);
        return arr.flat();
      },
      rating_options: function () {
        let arr=[];
        arr.push(this.all_label);
        let levels=['5','4','3','2','1'];
        arr.push(levels);
        return arr.flat();
      },
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

      movieTitleContainsText(movies) {

        return movies.filter((movie) => {

          if (this.search_title_txt!='')
          {

            console.log(this.search_tile_txt);
            console.log(movie.title);

            let movie_text=movie.title.toUpperCase();
            let search_title_txt_case_insensitive=this.search_title_txt.toUpperCase();
            // insert logic here
            return   movie_text.match(search_title_txt_case_insensitive);

            //      let selected_rating=this.selected_rating;
            //      let movie_average=app.average_rating(movie);
            //    return  ((movie_average>=selected_rating) && (movie_average-selected_rating<=1));

          } else {
            return true;
          }
          this.search_title_txt=''; // reset

        });

      },

      movieSummaryContainsText(movies) {

        return movies.filter((movie) => {

          if (this.search_summary_txt!='')
          {

            console.log(this.search_summary_txt);
            console.log(movie.summary);

            let movie_text=movie.summary.toUpperCase();
            let search_summary_txt_case_insensitive=this.search_summary_txt.toUpperCase();
            // insert logic here
            return   movie_text.match(search_summary_txt_case_insensitive);

            //      let selected_rating=this.selected_rating;
            //      let movie_average=app.average_rating(movie);
            //    return  ((movie_average>=selected_rating) && (movie_average-selected_rating<=1));

          } else {
            return true;
          }
          this.search_summary_txt=''; // reset

        });

      },

      // movies_jsn
      moviesByRating(movies) {

        return movies.filter((movie) => {

          if ((this.selected_rating!='') && (this.selected_rating!=this.all_label))
          {

            let selected_rating=this.selected_rating;
            let movie_average=app.average_rating(movie);
            return  ((movie_average>=selected_rating) && (movie_average-selected_rating<=1));

          } else {
            return true;
          }

        });

      },
      moviesByCategory(movies) {
        return movies.filter((movie) => {
          //          console.log(movie.category.name);

          if ((this.selected_category!='') && (this.selected_category!=this.all_label))
          {

            return movie.category.name==this.selected_category;
          } else {
            return true;
          }

        });

      },

      // get the average rate (number of stars)
      number_of_ratings(movie) {
        console.log(movie.title);
        return -1;
        //        return movie.ratings.length;

      },
      average_rating(movie) {
        if (movie.ratings.length > 0) {

          let score=app.total_stars(movie)/app.number_of_ratings(movie);
          return Math.round(score * 100)/100;
        }

        else
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
        let movie_ratings=movie.ratings;
        let total_stars=0;
        movie_ratings.forEach(function(movie_rating) {
          total_stars+=movie_rating.stars;
        });
        console.log(movie.title+" has "+total_stars+" stars in total.")
        return total_stars;
        //        return movie.ratings.length;
      },
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
        console.log('user_id: '+this.current_user_id+', movie_id: '+movie.id, 'stars: '+this.rating);
        //            axios.post('/ratings', { "user_id"=>"1","movie_id"=>"6","stars"=>1 })
        //                user_id: this.current_user_id,
        //                movie_id: movie.id,
        //                stars: this.score
        //              })
        //              .then(function (response) {
        //                console.log(response);
        //              })
        //              .catch(function (error) {
        //                console.log(error);
        //              });

        //              axios.post('/ratings',{user_id:'1', movie_id: '5', stars: 5}).then(result => {
        axios.post('/ratings',{user_id:this.current_user_id, movie_id: movie.id, stars: this.rating}).then(result => {

          console.log(result.data)
        })

        if (this.rating>1) {
          alert("You gave '"+movie.title+"' "+this.rating+" stars.")
        } else {
          alert("You rated '"+movie.title+"' just one star.")
        }
        this.rating=0; // Important: reset number of stars to zero (otherwise they would be appear filled in all rows)
      }

    },
    // https://stackoverflow.com/questions/50169210/vuejs-redirect-to-url-when-clicked-on-a-button
    components: { }
    //    ,
    // https://stackoverflow.com/questions/44440708/vue-js-templating-and-interpolation-not-rendering-data
    //    delimiters: ["((","))"]
  })

  //

  axios.get('/movies.json')
  .then(function (response) {
    // handle success
    console.log(response);
  })

})
