<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns="http://www.nbirn.net/xcede"
  xmlns:xcede="http://www.nbirn.net/xcede"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dyn="http://exslt.org/dynamic"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="xsl xcede"
  version="1.0">

  <xsl:variable name="apos">'</xsl:variable>

  <xsl:output
    method="xml"
    indent="yes"
    omit-xml-declaration="no"
    />

  <xsl:template match="*[@href]">
    <xsl:variable name="url" select="substring-before(@href, '#xpointer(')"/>
    <xsl:variable name="xpath" select="substring-before(substring-after(@href, '#xpointer('), ')')"/>
    <xsl:variable name="evalstr" select="concat('document(',$apos,$url,$apos,',/)',$xpath)"/>
    <xsl:for-each select="dyn:evaluate($evalstr)">
      <xsl:copy>
        <xsl:for-each select="@*|node()">
          <xsl:apply-templates select="." />
        </xsl:for-each>
      </xsl:copy>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
