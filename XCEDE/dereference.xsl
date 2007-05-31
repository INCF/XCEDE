<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns="http://www.xcede.org/xcede-2"
  xmlns:xcede="http://www.xcede.org/xcede-2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dyn="http://exslt.org/dynamic"
  exclude-result-prefixes="xsl xcede"
  version="1.0">

  <xsl:variable name="apos">'</xsl:variable>

  <xsl:output
    method="xml"
    indent="yes"
    omit-xml-declaration="no"
    />

  <xsl:template match="//xcede:subjectList/xcede:subjectRef|//xcede:visitList/xcede:visitRef|//xcede:studyList/xcede:studyRef|//xcede:episodeList/xcede:episodeRef|//xcede:acquisitionRef|//xcede:analysisRef|//xcede:dataResourceRef|//xcede:protocolTimeRef|//xcede:stepRef">
    <xsl:variable name="url" select="substring-before(., '#xpointer(')"/>
    <xsl:variable name="xpath" select="substring-before(substring-after(., '#xpointer('), ')')"/>

    <xsl:choose>
      <xsl:when test="string-length($url)=0">
        <xsl:for-each select="dyn:evaluate($xpath)">
          <xsl:copy>
            <xsl:for-each select="@*|node()">
              <xsl:apply-templates select="." />
            </xsl:for-each>
          </xsl:copy>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="evalstr" select="concat('document(',$apos,$url,$apos,',/)',$xpath)"/>
        <xsl:for-each select="dyn:evaluate($evalstr)">
          <xsl:copy>
            <xsl:for-each select="@*|node()">
              <xsl:apply-templates select="." />
            </xsl:for-each>
          </xsl:copy>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
