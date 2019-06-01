/* eslint no-console: 0 */
 import Vue from 'vue/dist/vue.esm'
 import App from '../app.vue'

 document.addEventListener('DOMContentLoaded', () => {
   var app = new Vue({
     el: '#app-movies-index',
     data: {
       // list of movies
       movies_j: JSON.parse(document.getElementById("movie-list").getAttribute('data-movies'))
     }
   })
 })
