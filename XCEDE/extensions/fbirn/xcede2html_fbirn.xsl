<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns="http://www.xcede.org/xcede-2"
  xmlns:fbirn="http://www.xcede.org/xcede-2/extensions/fbirn"
  xmlns:xcede="http://www.xcede.org/xcede-2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dyn="http://exslt.org/dynamic"
  version="1.0">

  <xsl:output method="html"/>

  <xsl:include href="../../tools/xcede2html/xcede2html.xsl" />

  <xsl:template match="xcede:episodeInfo[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2/extensions/fbirn', 'fipsEpisodeInfo_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blocktitle</xsl:attribute>
        <xsl:text>FIPS Info</xsl:text>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">blockcontent</xsl:attribute>
        <xsl:call-template name="genericElement" />
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:acquisitionInfo[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'mrAcquisitionInfo_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blocktitle</xsl:attribute>
        <xsl:text>MR Acquisition</xsl:text>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">blockcontent</xsl:attribute>
        <xsl:call-template name="genericElement" />
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
