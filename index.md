---
layout: page
title: Intro
tagline: Supporting tagline
---
{% include JB/setup %}

<h1>Len Kiefer's great webpage</h1>

<p><em>Amazing <span class="icon-dataviz"></span> data visualizations, <span class="icon-display"></span> dynamic presentations, <span class="icon-terminal"></span> some coding and <span class="icon-file-excel" style="color:green;"></span> probably a little excel.</em></p>



<p>Recent posts:</p>

Here's a sample "posts list".

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>