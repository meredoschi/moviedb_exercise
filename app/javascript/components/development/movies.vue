<template>
  <div id="app-movie-list">

    {{ currentPage }}

    User: {{ current_user_id }}
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
      //
      movie_ids_recently_rated: []
    }


  },
  // https://alligator.io/vuejs/rest-api-axios/
  // https://stackoverflow.com/questions/54757510/how-to-delete-a-record-in-rails-api-and-vue-js
  created() {
      // https://forum.vuejs.org/t/how-to-get-id-value-in-vue-js/44999
      let user_id = document.querySelector('#current_user').dataset.value;
      this.current_user_id = user_id;
    //  this.getmovies();
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
