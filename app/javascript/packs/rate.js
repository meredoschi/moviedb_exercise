import Vue from 'vue/dist/vue.esm'
import Rate from '../rate.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rate',
    data: {
      movies_jsn: [ {"id":4,"title":"A real documentary","summary":"Things are very real in this documentary about...","category_id":4,"created_at":"2019-06-05T15:56:40.602Z","updated_at":"2019-06-05T15:56:40.602Z","url":"http://localhost:3000/movies/4.json"},
      {"id":3,"title":"Planet XYZ","summary":"In a recently discovered planet...","category_id":3,"created_at":"2019-06-05T15:56:40.598Z","updated_at":"2019-06-05T15:56:40.598Z","url":"http://localhost:3000/movies/3.json"},
      {"id":11,"title":"Provisional","summary":"A working title which remained...","category_id":5,"created_at":"2019-06-05T15:56:40.628Z","updated_at":"2019-06-05T15:56:40.628Z","url":"http://localhost:3000/movies/11.json"},
      {"id":5,"title":"Sleepwalking in Antarctica","summary":"The new release from the famous director...","category_id":1,"created_at":"2019-06-05T15:56:40.605Z","updated_at":"2019-06-05T15:56:40.605Z","url":"http://localhost:3000/movies/5.json"},
      {"id":6,"title":"The Zombies","summary":"As the name implies, there are many zombies...","category_id":5,"created_at":"2019-06-05T15:56:40.610Z","updated_at":"2019-06-05T15:56:40.610Z","url":"http://localhost:3000/movies/6.json"},
      {"id":8,"title":"The ball game","summary":"An american baseball story...","category_id":5,"created_at":"2019-06-05T15:56:40.618Z","updated_at":"2019-06-05T15:56:40.618Z","url":"http://localhost:3000/movies/8.json"},
      {"id":7,"title":"The basketball players","summary":"Based on the classic novel by...","category_id":2,"created_at":"2019-06-05T15:56:40.614Z","updated_at":"2019-06-05T15:56:40.614Z","url":"http://localhost:3000/movies/7.json"},
      {"id":10,"title":"The saga","summary":"All 17 episodes, restored in full digital colors..","category_id":5,"created_at":"2019-06-05T15:56:40.625Z","updated_at":"2019-06-05T15:56:40.625Z","url":"http://localhost:3000/movies/10.json"},
      {"id":1,"title":"The sample","summary":"The sample wons an award for...","category_id":1,"created_at":"2019-06-05T15:56:40.589Z","updated_at":"2019-06-05T15:56:40.589Z","url":"http://localhost:3000/movies/1.json"},
      {"id":9,"title":"The sequel","summary":"It continues where the previous movie left off...","category_id":3,"created_at":"2019-06-05T15:56:40.621Z","updated_at":"2019-06-05T15:56:40.621Z","url":"http://localhost:3000/movies/9.json"}]
    },
    components: { Rate }
//    ,
// https://stackoverflow.com/questions/44440708/vue-js-templating-and-interpolation-not-rendering-data
//    delimiters: ["((","))"]
  })
})
