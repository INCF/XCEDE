<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns="http://www.xcede.org/xcede-2"
  xmlns:xcede="http://www.xcede.org/xcede-2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xsl xcede"
  version="1.0">

  <xsl:param name="mergedoc"/>

  <xsl:output
    method="xml"
    indent="yes"
    omit-xml-declaration="no"
    />

  <xsl:template match="/xcede:XCEDE">
    <xsl:variable name="mergerootnode" select="document($mergedoc)/xcede:XCEDE"/>
    <xsl:copy>
      <xsl:for-each select="@*|$mergerootnode/@*">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:for-each>
      <xsl:for-each select="node()|$mergerootnode/node()">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
