---
layout: "post"
title: "Data-model"
date: "2019-06-03 11:11"
---

# Data model (draft)

## Movies

Title
  * String
  * Maxlength: something reasonable, let's say 200

Info

  * Text

  * Maxlength: 4000 characters

Rating
  * rating_id
  * integer (association)

Category
  * category_id
  * integer (association)

## Ratings

Movie
  * movie_id
  * integer (association)

Stars
* integer (from 0 to maximum, let's say 5)

## Category
* Name: string
  * Action, Drama, Science-Fiction (etc)
* maxlength: 70
