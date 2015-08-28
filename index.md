---
layout: page
title: Len Kiefer
tagline: Helping people understand the economy, housing and mortgage markets.
---
{% include JB/setup %}

<p><em>Amazing <span class="icon-dataviz"></span> data visualizations, <span class="icon-display"></span> dynamic presentations, <span class="icon-terminal"></span> some coding and <span class="icon-file-excel" style="color:green;"></span> probably a little excel.</em></p>

<p>Recent posts:</p>

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>