<br>
<div class="row">

<div v-if="(totalPages>1)" class="col-md-4">
  Page {{current_page}}/{{ totalPages }}
</div>

<div class="col-md-4">

<button v-if="(current_page>1)" v-on:click="current_page -= 1" type="button" class="btn btn-link">Previous</button>

</div>

<div class="col-md-4">

<button v-if="(current_page<totalPages)" v-on:click="current_page += 1" type="button" class="btn btn-link">Next</button></p>

</div>

</div>
