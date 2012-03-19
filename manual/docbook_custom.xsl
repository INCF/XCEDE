<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0">
  <xsl:include href="/usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl" />

  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="hyphenation-character">&#x25BA;</xsl:attribute>
  </xsl:attribute-set>

<xsl:template match="type">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

</xsl:stylesheet>
