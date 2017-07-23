---
layout: null
---
<?xml version="1.0"?>
<xsl:stylesheet xmlns:sm="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html"/>
  <xsl:template match="/sm:urlset">
    <html>
      {% include head.html %}
      <body>
        {% include header.html %}
        
        
        
         <div id="content-wrapper">
      <div class="inner clearfix">
        <section id="main-content">
		<h1>
          URL listing
        </h1>
          <ul>
          <xsl:apply-templates select="sm:url">
            <xsl:sort select="sm:lastmod" />
          </xsl:apply-templates>
        </ul>
        </section>
      </div>
    </div>
        
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sm:url">
    <li>
      <a href="{sm:loc}"><xsl:value-of select="sm:loc"/></a>
    </li>
  </xsl:template>
</xsl:stylesheet>