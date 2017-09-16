---
title: Tags
slug: content//tag/tag
---

 <div > Blog categories
        <ul id="all-tags">
            {{ range $name, $taxonomy := .Site.Taxonomies.categories }}
            <ul><a href="/tags/{{ $name | urlize }}">{{ $name }}</a></ul>
            {{ end }}
        </ul>
 </div>
