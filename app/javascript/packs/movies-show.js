/* eslint no-console: 0 */
 import Vue from 'vue/dist/vue.esm'
 import App from '../app.vue'

 document.addEventListener('DOMContentLoaded', () => {
   var app_show = new Vue({
     el: '#app-movies-show',
     data: {
       // current movie
       movie: JSON.parse(document.getElementById("movie").getAttribute('data-movie'))
     }
   })
 })
