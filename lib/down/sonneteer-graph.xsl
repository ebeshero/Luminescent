<?xml version="1.0" standalone="no"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY ldquo '&#x201C;' >
<!ENTITY rdquo '&#x201D;' >
]>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:x="http://lmnl-markup.org/ns/xLMNL"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:f="http://lmnl-markup.org/ns/xslt/utility"
  xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all">

  <xsl:import href="bubbles-svg.xsl"/>

  <xsl:import href="xlmnl-xml.xsl"/>

  <xsl:output method="xhtml"/>

  <xsl:variable name="specs" xmlns="http://lmnl-markup.org/ns/xslt/utility">
    <left-margin>40</left-margin>
    <top-margin>10</top-margin>
    <bottom-margin>10</bottom-margin>
    <background-color>midnightblue</background-color>
    <title>
      <font-family>sans-serif</font-family>
      <font-size>18</font-size>
      <line-height>30</line-height>
      <indent>220</indent>
      <drop>30</drop>
    </title>
    <styles>
      <ranges color="lavender" opacity="0">sonnet octave sestet</ranges>
      <ranges color="lightsteelblue" opacity="0.1">quatrain tercet couplet</ranges>
      <ranges color="rosybrown" opacity="0.1" stroke="orange">s</ranges>
      <ranges color="lavender" opacity="0.2">line</ranges>
      <ranges color="pink" opacity="0.1">phr</ranges>
    </styles>
    <bars indent="200">
      <ranges width="30" indent="0">octave sestet</ranges>
      <ranges width="30" indent="30">quatrain tercet couplet</ranges>
      <ranges width="30" indent="60">line</ranges>
      <ranges width="30" indent="90">phr</ranges>
      <ranges width="30" indent="120">s</ranges>
    </bars>
    <discs indent="100">
      <range label="none">sonnet</range>
      <range label="none">octave</range>
      <range label="none">sestet</range>
      <range label="none">quatrain</range>
      <range label="none">tercet</range>
      <range label="none">couplet</range>
      <range>line</range>
      <range label="left">phr</range>
      <range label="left">s</range>
    </discs>
  </xsl:variable>

  <xsl:template match="/">
    <html xml:lang="en">
      <head>
        <title>Sonneteer graph</title>
        <meta charset="utf-8"/>
        <!--<link rel="stylesheet" type="text/css" href="jquery.svg.css"/>--> 
        <script type="text/javascript" src="jquery-1.9.1.min.js">
          <xsl:text> </xsl:text>
        </script>
        <xsl:comment> JQuery SVG plugin by Keith Wood: see keith-wood.name/svg.html (and thanks!) </xsl:comment>
        <script type="text/javascript" src="jquery.svg.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript" src="jquery.svgdom.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript">
          
$(document).ready(function() {

  $('.range-bar').hover(
    function(event) {
      $('.'+this.id).stop(true,true).addClass('shine');
    },
    function() {$('.'+this.id).stop(true,true).removeClass('shine')
    }
  );

  $('.range-span').hover(
    function(event) {
      $.each($(this).attr('class').split(' '), function() {
        $('#' + this).addClass('shine') })
    },
    function() {
    $.each($(this).attr('class').split(' '), function() {
      $('#' + this).removeClass('shine') })
    }
  )
})
        </script>
        <style type="text/css">
div#text    { margin-left:460px; color: white; font-size: 14pt }
h3.title, h4.author { margin: 0px }
h3.title { border-bottom: thin solid white }
div.lg      { margin-top: 2ex }
p.line      { margin-top: 0px; margin-bottom: 0px; margin-left: 1em; text-indent:-1em }
span:hover  { color: skyblue }
span.shine  { background-color: papayawhip; color: midnightblue }
rect.shine, circle.shine  { fill-opacity: 0.5 }
        </style>
      </head>
      <body style="background-color:{$specs/f:background-color}" id="mainbody">
        <svg width="450" height="800" xmlns="http://www.w3.org/2000/svg"
          style="position:fixed; top: 0px" id="svg">
          <xsl:call-template name="draw-svg"/>
        </svg>

        <div id="text">
          <xsl:call-template name="display-sonnet"/>
        </div>
        <!--<div style="display:none">
          <xsl:copy-of select="$sonnet-xml"/>
        </div>-->
      </body>
    </html>
  </xsl:template>

  <xsl:variable name="sonnet-xml">
    <xsl:apply-templates select="$lmnl-document">
      <xsl:with-param name="elements" tunnel="yes" as="xs:string*"
        select="('sonneteer','meta','sonnet','line')"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:template name="display-sonnet">
    <!--<xsl:copy-of select="$sonnet-xml"/>-->
    <xsl:apply-templates select="$sonnet-xml" mode="display"/>
  </xsl:template>

  <xsl:template mode="display" match="sonneteer">
    <xsl:apply-templates mode="display"/>
  </xsl:template>

  <xsl:template mode="display" match="meta">
    <xsl:apply-templates select="@title,@author" mode="display"/>
  </xsl:template>
  
  <xsl:template mode="display" match="@title">
    <h3 class="title">
      <xsl:next-match/>
    </h3>
  </xsl:template>
  
  <xsl:template mode="display" match="@author">
    <h4 class="author">
      <xsl:next-match/>
    </h4>
  </xsl:template>
    
  <xsl:template mode="display" match="sonnet">
    <div class="lg">
      <xsl:apply-templates mode="display"/>
    </div>
  </xsl:template>
  
  <xsl:template mode="display" match="line">
    <p class="line">
      <xsl:apply-templates mode="display"/>
    </p>
  </xsl:template>

  <xsl:template match="line/x:span" mode="display">
    <span id="{generate-id(.)}"
      class="range-span {string-join(
      for $r in tokenize(@ranges,'\s+') return replace($r,'^R.','bar-'),' ')}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="x:*" mode="display"/>

  <!-- customizes class assignment only on bubble objects
       generated for ranges, binding them to the corresponding bar. -->
  <xsl:template match="x:range" mode="assign-class">
    <xsl:param name="class"/>
    <xsl:if test="$class = 'range-bubble'">
      <xsl:attribute name="class" select="string-join(($class,replace(@ID,'^R\.','bar-')),' ')"/>
    </xsl:if>
  </xsl:template>
  
  <!--<xsl:template match="*" mode="animate" xmlns="http://www.w3.org/2000/svg">
    <xsl:param name="stroke-width" select="1" as="xs:double"/>
    <xsl:param name="fill-opacity" select="0.2" as="xs:double"/>
    <set attributeName="fill-opacity" to="{($fill-opacity + 1) div 2}"
      begin="{replace(@ID,'^R.','bar-')}.mouseover"/>
    <set attributeName="fill-opacity" to="{$fill-opacity}"
      begin="{replace(@ID,'^R.','bar-')}.mouseout"/>
    <xsl:for-each select="key('spans-by-range',@ID,$sonnet-xml)">
      <set attributeName="fill-opacity" to="{($fill-opacity + 1) div 2}"
        begin="{generate-id(.)}.mouseover"/>
      <set attributeName="stroke-width" to="{$stroke-width * 2}"
        begin="{generate-id(.)}.mouseover"/>
      <set attributeName="fill-opacity" to="{$fill-opacity}"
        begin="{generate-id(.)}.mouseout"/>
      <set attributeName="stroke-width" to="{$stroke-width}"
        begin="{generate-id(.)}.mouseout"/>
    </xsl:for-each>
  </xsl:template>-->

</xsl:stylesheet>