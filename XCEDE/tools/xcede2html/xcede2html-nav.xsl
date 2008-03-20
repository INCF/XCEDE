<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns="http://www.xcede.org/xcede-2"
  xmlns:xcede="http://www.xcede.org/xcede-2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dyn="http://exslt.org/dynamic"
  xmlns:func="http://exslt.org/functions"
  extension-element-prefixes="func"
  version="1.0">

  <xsl:output method="html"/>

  <xsl:param name="basefile" select="''"/>
  <xsl:param name="targetframe" select="''"/>
  <xsl:param name="IDsep" select="':'"/>

  <!-- ======================================= -->
  <!--          GLOBAL VARIABLES/KEYS          -->
  <!-- ======================================= -->

  <xsl:variable name="apos">'</xsl:variable>

  <xsl:variable name="projectUIDexpr" select="'@projectID'"/>
  <xsl:variable name="subjectGroupUIDexpr" select="'concat(@projectID,$IDsep,@subjectGroupID)'"/>
  <xsl:variable name="subjectUIDexpr" select="'@subjectID'"/>
  <xsl:variable name="visitUIDexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID)'"/>
  <xsl:variable name="studyUIDexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID,$IDsep,@studyID)'"/>
  <xsl:variable name="episodeUIDexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID,$IDsep,@studyID,$IDsep,@episodeID)'"/>
  <xsl:variable name="acquisitionUIDexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID,$IDsep,@studyID,$IDsep,@episodeID,$IDsep,@acquisitionID)'"/>

  <xsl:variable name="projectUIDTopexpr" select="'@ID'"/>
  <xsl:variable name="subjectGroupUIDTopexpr" select="'concat(@projectID,$IDsep,@ID)'"/>
  <xsl:variable name="subjectUIDTopexpr" select="'@ID'"/>
  <xsl:variable name="visitUIDTopexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@ID)'"/>
  <xsl:variable name="studyUIDTopexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID,$IDsep,@ID)'"/>
  <xsl:variable name="episodeUIDTopexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID,$IDsep,@studyID,$IDsep,@ID)'"/>
  <xsl:variable name="acquisitionUIDTopexpr" select="'concat(@projectID,$IDsep,@subjectGroupID,$IDsep,@subjectID,$IDsep,@visitID,$IDsep,@studyID,$IDsep,@episodeID,$IDsep,@ID)'"/>

  <xsl:key name="projectUID" match="xcede:visit|xcede:study|xcede:episode|xcede:acquisition" use="dyn:evaluate($projectUIDexpr)" />
  <xsl:key name="subjectGroupUID" match="xcede:visit|xcede:study|xcede:episode|xcede:acquisition" use="dyn:evaluate($subjectGroupUIDexpr)" />
  <xsl:key name="subjectUID" match="xcede:visit|xcede:study|xcede:episode|xcede:acquisition" use="dyn:evaluate($subjectUIDexpr)" />
  <xsl:key name="visitUID" match="xcede:study|xcede:episode|xcede:acquisition" use="dyn:evaluate($visitUIDexpr)" />
  <xsl:key name="studyUID" match="xcede:episode|xcede:acquisition" use="dyn:evaluate($studyUIDexpr)" />
  <xsl:key name="episodeUID" match="xcede:acquisition" use="dyn:evaluate($episodeUIDexpr)" />

  <xsl:key name="projectUID" match="xcede:project" use="dyn:evaluate($projectUIDTopexpr)" />
  <xsl:key name="subjectUID" match="xcede:subject" use="dyn:evaluate($subjectUIDTopexpr)" />
  <xsl:key name="visitUID" match="xcede:visit" use="dyn:evaluate($visitUIDTopexpr)" />
  <xsl:key name="studyUID" match="xcede:study" use="dyn:evaluate($studyUIDTopexpr)" />
  <xsl:key name="episodeUID" match="xcede:episode" use="dyn:evaluate($episodeUIDTopexpr)" />
  <xsl:key name="acquisitionUID" match="xcede:acquisition" use="dyn:evaluate($acquisitionUIDTopexpr)" />

  <xsl:variable name="projectUIDquote" select="'projectUID'" />
  <xsl:variable name="subjectUIDquote" select="'subjectUID'" />
  <xsl:variable name="subjectGroupUIDquote" select="'subjectGroupUID'" />
  <xsl:variable name="visitUIDquote" select="'visitUID'" />
  <xsl:variable name="studyUIDquote" select="'studyUID'" />
  <xsl:variable name="episodeUIDquote" select="'episodeUID'" />
  <xsl:variable name="acquisitionUIDquote" select="'acquisitionUID'" />

  <xsl:variable name="projectquote" select="'project'" />
  <xsl:variable name="subjectquote" select="'subject'" />
  <xsl:variable name="subjectGroupquote" select="'subjectGroup'" />
  <xsl:variable name="visitquote" select="'visit'" />
  <xsl:variable name="studyquote" select="'study'" />
  <xsl:variable name="episodequote" select="'episode'" />
  <xsl:variable name="acquisitionquote" select="'acquisition'" />

  <xsl:variable name="projectUIDFilterUnique" select="concat('[(local-name()=$projectquote and count(.|key($projectUIDquote,', $projectUIDTopexpr, ')[1])=1) or (local-name()!=$projectquote and count(.|key($projectUIDquote,', $projectUIDexpr, ')[1])=1)]')" />
  <xsl:variable name="subjectUIDFilterUnique" select="concat('[(local-name()=$subjectquote and count(.|key($subjectUIDquote,', $subjectUIDTopexpr, ')[1])=1) or (local-name()!=$subjectquote and count(.|key($subjectUIDquote,', $subjectUIDexpr, ')[1])=1)]')" />
  <xsl:variable name="visitUIDFilterUnique" select="concat('[(local-name()=$visitquote and count(.|key($visitUIDquote,', $visitUIDTopexpr, ')[1])=1) or (local-name()!=$visitquote and count(.|key($visitUIDquote,', $visitUIDexpr, ')[1])=1)]')" />
  <xsl:variable name="studyUIDFilterUnique" select="concat('[(local-name()=$studyquote and count(.|key($studyUIDquote,', $studyUIDTopexpr, ')[1])=1) or (local-name()!=$studyquote and count(.|key($studyUIDquote,', $studyUIDexpr, ')[1])=1)]')" />
  <xsl:variable name="episodeUIDFilterUnique" select="concat('[(local-name()=$episodequote and count(.|key($episodeUIDquote,', $episodeUIDTopexpr, ')[1])=1) or (local-name()!=$episodequote and count(.|key($episodeUIDquote,', $episodeUIDexpr, ')[1])=1)]')" />
  <xsl:variable name="acquisitionUIDFilterUnique" select="concat('[(local-name()=$acquisitionquote and count(.|key($acquisitionUIDquote,', $acquisitionUIDTopexpr, ')[1])=1) or (local-name()!=$acquisitionquote and count(.|key($acquisitionUIDquote,', $acquisitionUIDexpr, ')[1])=1)]')" />

  <xsl:variable name="acquisitionelementcheck" select="'local-name()=$acquisitionquote'" />
  <xsl:variable name="episodeelementcheck" select="concat('local-name()=$episodequote or ', $acquisitionelementcheck)" />
  <xsl:variable name="studyelementcheck" select="concat('local-name()=$studyquote or ', $episodeelementcheck)" />
  <xsl:variable name="visitelementcheck" select="concat('local-name()=$visitquote or ', $studyelementcheck)" />
  <xsl:variable name="subjectelementcheck" select="concat('local-name()=$subjectquote or ', $visitelementcheck)" />
  <xsl:variable name="projectelementcheck" select="concat('local-name()=$projectquote or ', $visitelementcheck)" />

  <xsl:variable name="projectSearch" select="concat('/xcede:XCEDE/*[', $projectelementcheck, ']', $projectUIDFilterUnique)" />
  <xsl:variable name="subjectSearch" select="concat('/xcede:XCEDE/*[', $subjectUIDFilterUnique)" />
  <xsl:variable name="visitSearch" select="concat('/xcede:XCEDE/*[', $visitelementcheck, ']', $visitUIDFilterUnique)" />
  <xsl:variable name="studySearch" select="concat('/xcede:XCEDE/*[', $studyelementcheck, ']', $studyUIDFilterUnique)" />
  <xsl:variable name="episodeSearch" select="concat('/xcede:XCEDE/*[', $episodeelementcheck, ']', $episodeUIDFilterUnique)" />
  <xsl:variable name="acquisitionSearch" select="concat('/xcede:XCEDE/*[', $acquisitionelementcheck, ']', $acquisitionUIDFilterUnique)" />

  <!-- ======================================= -->
  <!--            HELPER FUNCTIONS             -->
  <!-- ======================================= -->

  <func:function name="xcede:xcedeID">
    <xsl:variable name="localname" select="local-name()" />

    <func:result>
      <xsl:value-of select="$localname" />
      <xsl:text>:</xsl:text>
      <xsl:value-of select="@ID" />
      <xsl:text>:</xsl:text>
      <xsl:choose>
        <xsl:when test="$localname='project'">
          <xsl:value-of select="@ID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@projectID" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>:</xsl:text>
      <xsl:choose>
        <xsl:when test="$localname='subject'">
          <xsl:value-of select="@ID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@subjectID" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>:</xsl:text>
      <xsl:choose>
        <xsl:when test="$localname='visit'">
          <xsl:value-of select="@ID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@visitID" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>:</xsl:text>
      <xsl:choose>
        <xsl:when test="$localname='study'">
          <xsl:value-of select="@ID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@studyID" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>:</xsl:text>
      <xsl:choose>
        <xsl:when test="$localname='episode'">
          <xsl:value-of select="@ID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@episodeID" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>:</xsl:text>
      <xsl:choose>
        <xsl:when test="$localname='acquisition'">
          <xsl:value-of select="@ID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@acquisitionID" />
        </xsl:otherwise>
      </xsl:choose>
    </func:result>
  </func:function>

  <func:function name="xcede:checkTypeMatch">
    <xsl:param name="checkthis" />
    <xsl:param name="matchURI" />
    <xsl:param name="matchNCType" />
    <xsl:param name="nsContainer" select="." />

    <xsl:variable name="retval">
      <xsl:call-template name="checkTypeMatch">
        <xsl:with-param name="checkthis" select="$checkthis" />
        <xsl:with-param name="matchURI" select="$matchURI" />
        <xsl:with-param name="matchNCType" select="$matchNCType" />
        <xsl:with-param name="nsContainer" select="." />
      </xsl:call-template>
    </xsl:variable>
    <func:result select="number($retval)" />
  </func:function>

  <xsl:template name="checkTypeMatch">
    <xsl:param name="checkthis" />
    <xsl:param name="matchURI" />
    <xsl:param name="matchNCType" />
    <xsl:param name="nsContainer" select="." />

<!--
    <xsl:message>
      <xsl:text>*** called checkTypeMatch</xsl:text>
    </xsl:message>
    <xsl:message>
      <xsl:text>checkthis=</xsl:text>
      <xsl:value-of select="$checkthis" />
    </xsl:message>
    <xsl:message>
      <xsl:text>matchURI=</xsl:text>
      <xsl:value-of select="$matchURI" />
    </xsl:message>
    <xsl:message>
      <xsl:text>matchNCType=</xsl:text>
      <xsl:value-of select="$matchNCType" />
    </xsl:message>
-->

    <xsl:variable name="checkNCType">
      <xsl:choose>
        <xsl:when test="contains($checkthis, ':')">
          <xsl:value-of select="substring-after($checkthis, ':')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$checkthis" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="checkprefix">
      <xsl:choose>
        <xsl:when test="contains($checkthis, ':')">
          <xsl:value-of select="substring-before($checkthis, ':')" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nsNode">
      <xsl:choose>
        <xsl:when test="$checkprefix">
          <xsl:value-of select="$nsContainer/namespace::*[name()=$checkprefix][1]" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>http://www.xcede.org/xcede-2</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="checkURI">
      <xsl:choose>
        <xsl:when test="$nsNode">
          <xsl:value-of select="string($nsNode)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">
            <xsl:text>ERROR: Can't find namespace prefix </xsl:text>
            <xsl:value-of select="$prefix" />
            <xsl:text> from given node.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

<!--
    <xsl:message>
      <xsl:text>checkNCType=</xsl:text>
      <xsl:value-of select="$checkNCType" />
    </xsl:message>
    <xsl:message>
      <xsl:text>checkprefix=</xsl:text>
      <xsl:value-of select="$checkprefix" />
    </xsl:message>
    <xsl:message>
      <xsl:text>checkURI=</xsl:text>
      <xsl:value-of select="$checkURI" />
    </xsl:message>
-->

    <xsl:choose>
      <xsl:when test="$checkURI=$matchURI and $checkNCType=$matchNCType">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This function takes one parameter, a node that links to a level element
       using a "level" attribute and ID attributes for the desired level and
       its existing parents -->
  <func:function name="xcede:findLevelElement">
    <xsl:param name="levelRefElement" />
    <xsl:variable name="levelname" select="@level"/>
    <xsl:choose>
      <xsl:when test="$levelname">
        <xsl:variable name="elemcheck">
          <xsl:choose>
            <xsl:when test="$levelname='project'">
              <xsl:value-of select="$projectelementcheck" />
            </xsl:when>
            <xsl:when test="$levelname='subject'">
              <xsl:value-of select="$subjectelementcheck" />
            </xsl:when>
            <xsl:when test="$levelname='visit'">
              <xsl:value-of select="$visitelementcheck" />
            </xsl:when>
            <xsl:when test="$levelname='study'">
              <xsl:value-of select="$studyelementcheck" />
            </xsl:when>
            <xsl:when test="$levelname='episode'">
              <xsl:value-of select="$episodeelementcheck" />
            </xsl:when>
            <xsl:when test="$levelname='acquisition'">
              <xsl:value-of select="$acquisitionelementcheck" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UIDTopexpr">
          <xsl:choose>
            <xsl:when test="$levelname='project'">
              <xsl:value-of select="$projectUIDTopexpr" />
            </xsl:when>
            <xsl:when test="$levelname='subject'">
              <xsl:value-of select="$subjectUIDTopexpr" />
            </xsl:when>
            <xsl:when test="$levelname='visit'">
              <xsl:value-of select="$visitUIDTopexpr" />
            </xsl:when>
            <xsl:when test="$levelname='study'">
              <xsl:value-of select="$studyUIDTopexpr" />
            </xsl:when>
            <xsl:when test="$levelname='episode'">
              <xsl:value-of select="$episodeUIDTopexpr" />
            </xsl:when>
            <xsl:when test="$levelname='acquisition'">
              <xsl:value-of select="$acquisitionUIDTopexpr" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UIDexpr">
          <xsl:choose>
            <xsl:when test="$levelname='project'">
              <xsl:value-of select="$projectUIDexpr" />
            </xsl:when>
            <xsl:when test="$levelname='subject'">
              <xsl:value-of select="$subjectUIDexpr" />
            </xsl:when>
            <xsl:when test="$levelname='visit'">
              <xsl:value-of select="$visitUIDexpr" />
            </xsl:when>
            <xsl:when test="$levelname='study'">
              <xsl:value-of select="$studyUIDexpr" />
            </xsl:when>
            <xsl:when test="$levelname='episode'">
              <xsl:value-of select="$episodeUIDexpr" />
            </xsl:when>
            <xsl:when test="$levelname='acquisition'">
              <xsl:value-of select="$acquisitionUIDexpr" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UID" select="dyn:evaluate($UIDexpr)" />
        <xsl:variable name="findexpr" select="concat('/xcede:XCEDE/*[local-name()=$levelname][', $UIDTopexpr, '=$UID]')" />
        <func:result select="dyn:evaluate($findexpr)" />
      </xsl:when>
      <xsl:otherwise>
        <!-- tricky way to return an empty node set -->
        <func:result select="/.." />
      </xsl:otherwise>
    </xsl:choose>
  </func:function>


  <!-- ======================================= -->
  <!--                TEMPLATES                -->
  <!-- ======================================= -->

  <xsl:template match="/xcede:XCEDE">
    <html>
      <head>
        <link rel="stylesheet" href="xcede2html-nav.css" type="text/css" media="screen"/>
        <title>XCEDE dataset</title>
        <p id="debug"></p>
        <script type="text/javascript">
          <xsl:comment>
            <xsl:text><![CDATA[
function debuglog(text) {
  var debugelem = document.getElementById('debug');
  debug.appendChild(document.createTextNode(text));
  debug.appendChild(document.createElement('br'));
  debug.appendChild(document.createTextNode('\n'));
}
function showhide_sw_open(id)
{
  document.getElementById(id).style.display='';
  document.getElementById('sw_closed_'+id).style.display='none';
  document.getElementById('sw_open_'+id).style.display='';
}
function showhide_sw_close(id)
{
  document.getElementById(id).style.display='none';
  document.getElementById('sw_open_'+id).style.display='none';
  document.getElementById('sw_closed_'+id).style.display='';
}
]]></xsl:text>
          </xsl:comment>
        </script>
      </head>
      <body bgcolor="#FFFFFF">
        <xsl:for-each select="dyn:evaluate($projectSearch)">
          <xsl:choose>
            <xsl:when test="local-name()='project'">
              <xsl:variable name="projectUID" select="dyn:evaluate($projectUIDTopexpr)"/>
              <xsl:call-template name="callrecurselevel">
                <xsl:with-param name="levelname" select="'project'"/>
                <xsl:with-param name="UID" select="$projectUID"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="projectUID" select="dyn:evaluate($projectUIDexpr)"/>
              <xsl:call-template name="callrecurselevel">
                <xsl:with-param name="levelname" select="'project'"/>
                <xsl:with-param name="UID" select="$projectUID"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="/xcede:XCEDE/xcede:data|/xcede:XCEDE/xcede:analysis|/xcede:XCEDE/xcede:catalog|/xcede:XCEDE/xcede:resource|/xcede:XCEDE/xcede:protocol">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="showhide_checkbox">
    <xsl:param name="ID" />
    <xsl:param name="checked" />
    <xsl:text>
</xsl:text>
    <xsl:element name="div">
      <xsl:attribute name="class">switchContainer</xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">switchOpen</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('sw_open_',$ID)" />
        </xsl:attribute>
        <xsl:attribute name="onclick">
          <xsl:text>showhide_sw_close('</xsl:text>
          <xsl:value-of select="$ID"/>
          <xsl:text>');</xsl:text>
        </xsl:attribute>
        <xsl:text>collapse</xsl:text>
      </xsl:element>
      <xsl:text>
      </xsl:text>
      <xsl:element name="span">
        <xsl:attribute name="class">switchClosed</xsl:attribute>
        <xsl:if test="$checked">
          <xsl:attribute name="style">display: none</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('sw_closed_',$ID)" />
        </xsl:attribute>
        <xsl:attribute name="onclick">
          <xsl:text>showhide_sw_open('</xsl:text>
          <xsl:value-of select="$ID"/>
          <xsl:text>');</xsl:text>
        </xsl:attribute>
        <xsl:text>expand</xsl:text>
      </xsl:element>
      <xsl:text>
</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template name="callrecurselevel">
    <xsl:param name="levelname" />
    <xsl:param name="UID" />
    <xsl:choose>
      <xsl:when test="$levelname='project'">
        <xsl:call-template name="recurselevel">
          <xsl:with-param name="levelname" select="'project'" />
          <xsl:with-param name="LevelName" select="'Project'" />
          <xsl:with-param name="elemcheck" select="$projectelementcheck" />
          <xsl:with-param name="UID" select="$UID" />
          <xsl:with-param name="UIDexpr" select="$projectUIDexpr" />
          <xsl:with-param name="UIDTopexpr" select="$projectUIDTopexpr" />
          <xsl:with-param name="childUIDexpr" select="$visitUIDexpr" />
          <xsl:with-param name="childUIDTopexpr" select="$visitUIDTopexpr" />
          <xsl:with-param name="childlevelname" select="'visit'" />
          <xsl:with-param name="childelemcheck" select="$visitelementcheck" />
          <xsl:with-param name="childUIDfilter" select="$visitUIDFilterUnique" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='visit'">
        <xsl:call-template name="recurselevel">
          <xsl:with-param name="levelname" select="'visit'" />
          <xsl:with-param name="LevelName" select="'Visit'" />
          <xsl:with-param name="elemcheck" select="$visitelementcheck" />
          <xsl:with-param name="UID" select="$UID" />
          <xsl:with-param name="UIDexpr" select="$visitUIDexpr" />
          <xsl:with-param name="UIDTopexpr" select="$visitUIDTopexpr" />
          <xsl:with-param name="childUIDexpr" select="$studyUIDexpr" />
          <xsl:with-param name="childUIDTopexpr" select="$studyUIDTopexpr" />
          <xsl:with-param name="childlevelname" select="'study'" />
          <xsl:with-param name="childelemcheck" select="$studyelementcheck" />
          <xsl:with-param name="childUIDfilter" select="$studyUIDFilterUnique" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='study'">
        <xsl:call-template name="recurselevel">
          <xsl:with-param name="levelname" select="'study'" />
          <xsl:with-param name="LevelName" select="'Study'" />
          <xsl:with-param name="elemcheck" select="$studyelementcheck" />
          <xsl:with-param name="UID" select="$UID" />
          <xsl:with-param name="UIDexpr" select="$studyUIDexpr" />
          <xsl:with-param name="UIDTopexpr" select="$studyUIDTopexpr" />
          <xsl:with-param name="childUIDexpr" select="$episodeUIDexpr" />
          <xsl:with-param name="childUIDTopexpr" select="$episodeUIDTopexpr" />
          <xsl:with-param name="childlevelname" select="'episode'" />
          <xsl:with-param name="childelemcheck" select="$episodeelementcheck" />
          <xsl:with-param name="childUIDfilter" select="$episodeUIDFilterUnique" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='episode'">
        <xsl:call-template name="recurselevel">
          <xsl:with-param name="levelname" select="'episode'" />
          <xsl:with-param name="LevelName" select="'Episode'" />
          <xsl:with-param name="elemcheck" select="$episodeelementcheck" />
          <xsl:with-param name="UID" select="$UID" />
          <xsl:with-param name="UIDexpr" select="$episodeUIDexpr" />
          <xsl:with-param name="UIDTopexpr" select="$episodeUIDTopexpr" />
          <xsl:with-param name="childUIDexpr" select="$acquisitionUIDexpr" />
          <xsl:with-param name="childUIDTopexpr" select="$acquisitionUIDTopexpr" />
          <xsl:with-param name="childlevelname" select="'acquisition'" />
          <xsl:with-param name="childelemcheck" select="$acquisitionelementcheck" />
          <xsl:with-param name="childUIDfilter" select="$acquisitionUIDFilterUnique" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='acquisition'">
        <xsl:call-template name="recurselevel">
          <xsl:with-param name="levelname" select="'acquisition'" />
          <xsl:with-param name="LevelName" select="'Acquisition'" />
          <xsl:with-param name="elemcheck" select="$acquisitionelementcheck" />
          <xsl:with-param name="UID" select="$UID" />
          <xsl:with-param name="UIDexpr" select="$acquisitionUIDexpr" />
          <xsl:with-param name="UIDTopexpr" select="$acquisitionUIDTopexpr" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="recurselevel">
    <xsl:param name="levelname" />
    <xsl:param name="LevelName" />
    <xsl:param name="elemcheck" />
    <xsl:param name="UID" />
    <xsl:param name="UIDexpr" />
    <xsl:param name="UIDTopexpr" />
    <xsl:param name="childUIDexpr" />
    <xsl:param name="childUIDTopexpr" />
    <xsl:param name="childlevelname" />
    <xsl:param name="childelemcheck" />
    <xsl:param name="childUIDfilter" />

    <xsl:variable name="ID" select="xcede:xcedeID()" />

    <xsl:text>
</xsl:text>
    <xsl:element name="li">
      <xsl:attribute name="class">
        <xsl:value-of select="concat($levelname, '-nav')"/>
      </xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="concat($levelname,'Title','-nav')" />
        </xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="target">
            <xsl:value-of select="$targetframe"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat($basefile, '#', $ID)" />
          </xsl:attribute>
          <xsl:element name="span">
            <xsl:attribute name="class">levelName</xsl:attribute>
            <xsl:value-of select="$LevelName" />
            <xsl:value-of select="':'" />
          </xsl:element>
          <xsl:if test="$levelname='visit' and @subjectID">
            <xsl:value-of select="' Subject '" />
            <xsl:value-of select="@subjectID" />
            <xsl:value-of select="','" />
          </xsl:if>
          <xsl:if test="local-name()=$levelname">
            <span class='levelID'>
              <xsl:value-of select="concat(' ',@ID)" />
            </span>
          </xsl:if>
        </xsl:element>
      </xsl:element>

      <xsl:call-template name="showhide_checkbox">
        <xsl:with-param name="ID" select="concat($ID, '_nav')" />
        <xsl:with-param name="checked" select="1" />
      </xsl:call-template>

      <xsl:element name="div">
        <xsl:attribute name="class">levelBody</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat($ID, '_nav')" />
        </xsl:attribute>
        <!-- Match the node (should be at most one) that describes this level for this UID -->
        <xsl:variable name="exprstr" select="concat('/xcede:XCEDE/*[local-name()=$levelname][', $UIDTopexpr, '=$UID]')" />
        <xsl:for-each select="dyn:evaluate($exprstr)">
          <xsl:call-template name="calllevel">
            <xsl:with-param name="levelname" select="$levelname" />
            <xsl:with-param name="UID" select="$UID" />
          </xsl:call-template>
        </xsl:for-each>

        <xsl:if test="$childelemcheck">
          <xsl:variable name="exprstr2" select="concat('/xcede:XCEDE/*[', $childelemcheck, '][', $UIDexpr, '=$UID]', $childUIDfilter)" />
          <xsl:for-each select="dyn:evaluate($exprstr2)">
            <xsl:choose>
              <xsl:when test="local-name()=$childlevelname">
                <xsl:variable name="childUID" select="dyn:evaluate($childUIDTopexpr)"/>
                <xsl:call-template name="callrecurselevel">
                  <xsl:with-param name="levelname" select="$childlevelname" />
                  <xsl:with-param name="UID" select="$childUID" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="childUID" select="dyn:evaluate($childUIDexpr)"/>
                <xsl:call-template name="callrecurselevel">
                  <xsl:with-param name="levelname" select="$childlevelname" />
                  <xsl:with-param name="UID" select="$childUID" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="calllevel">
    <xsl:param name="levelname" />
    <xsl:param name="UID" />
    <xsl:choose>
      <xsl:when test="$levelname='project'">
        <xsl:call-template name="project">
          <xsl:with-param name="UID" select="$UID" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='visit'">
        <xsl:call-template name="visit">
          <xsl:with-param name="UID" select="$UID" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='study'">
        <xsl:call-template name="study">
          <xsl:with-param name="UID" select="$UID" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='episode'">
        <xsl:call-template name="episode">
          <xsl:with-param name="UID" select="$UID" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$levelname='acquisition'">
        <xsl:call-template name="acquisition">
          <xsl:with-param name="UID" select="$UID" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="project">
    <xsl:apply-templates />
    <xsl:call-template name="levelCommon" />
  </xsl:template>

  <xsl:template name="visit">
    <xsl:apply-templates />
    <xsl:call-template name="levelCommon" />
  </xsl:template>

  <xsl:template name="study">
    <xsl:apply-templates />
    <xsl:call-template name="levelCommon" />
  </xsl:template>

  <xsl:template name="episode">
    <xsl:apply-templates />
    <xsl:call-template name="levelCommon" />
  </xsl:template>

  <xsl:template name="acquisition">
    <xsl:apply-templates />
    <xsl:call-template name="levelCommon" />
  </xsl:template>

  <xsl:template name="levelCommon">
    <xsl:variable name="curNode" select="."/>
    <xsl:for-each select="/xcede:XCEDE/xcede:analysis">
      <xsl:variable name="targetNode" select="xcede:findLevelElement(.)" />
      <xsl:if test="count($targetNode) = 1 and count($curNode|$targetNode) = 1">
        <xsl:apply-templates select=".">
          <xsl:with-param name="linkedfrom" select="$curNode" />
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="formatDateTime">
    <xsl:param name="datetimestr" />
    <xsl:variable name="date" select="substring-before($datetimestr, 'T')" />
    <xsl:variable name="year" select="substring-before($date, '-')" />
    <xsl:variable name="monthnum" select="substring-before(substring-after($date, '-'), '-')" />
    <xsl:variable name="monthday" select="substring-after(substring-after($date, '-'), '-')" />
    <xsl:variable name="time" select="substring-after($datetimestr, 'T')" />
    <xsl:variable name="hour" select="substring-before($time, ':')" />
    <xsl:variable name="min" select="substring-before(substring-after($time, ':'), ':')" />
    <xsl:variable name="seczone" select="substring-after(substring-after($time, ':'), ':')" />
    <xsl:variable name="sec">
      <xsl:choose>
        <xsl:when test="substring-before($seczone, '-')">
          <xsl:value-of select="substring-before($seczone, '-')" />
        </xsl:when>
        <xsl:when test="substring-before($seczone, '+')">
          <xsl:value-of select="substring-before($seczone, '+')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$seczone" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="zone">
      <xsl:if test="substring-after($time, '-')">
        <xsl:value-of select="concat('-', substring-after($time, '-'))" />
      </xsl:if>
      <xsl:if test="substring-after($time, '+')">
        <xsl:value-of select="concat('+', substring-after($time, '+'))" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="month">
      <xsl:choose>
        <xsl:when test="$monthnum=1">January</xsl:when>
        <xsl:when test="$monthnum=2">February</xsl:when>
        <xsl:when test="$monthnum=3">March</xsl:when>
        <xsl:when test="$monthnum=4">April</xsl:when>
        <xsl:when test="$monthnum=5">May</xsl:when>
        <xsl:when test="$monthnum=6">June</xsl:when>
        <xsl:when test="$monthnum=7">July</xsl:when>
        <xsl:when test="$monthnum=8">August</xsl:when>
        <xsl:when test="$monthnum=9">September</xsl:when>
        <xsl:when test="$monthnum=10">October</xsl:when>
        <xsl:when test="$monthnum=11">November</xsl:when>
        <xsl:when test="$monthnum=12">December</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($monthday,' ',$month,' ',$year,', ',$hour,':',$min,':',$sec,' ',$zone)" />
  </xsl:template>

  <xsl:template match="xcede:dataRef">
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="FirstRef" select="//xcede:dataRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count($FirstRef|.)=1">
        <xsl:apply-templates select="//xcede:data[@ID=$ID]">
          <xsl:with-param name="linkedfrom" select="." />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#data', $ID)" />
            </xsl:attribute>
            <xsl:text>Data</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xcede:dataResourceRef">
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="FirstRef" select="//xcede:dataResourceRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count($FirstRef|.)=1">
        <xsl:apply-templates select="//xcede:resource[@ID=$ID]">
          <xsl:with-param name="linkedfrom" select="." />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#data', $ID)" />
            </xsl:attribute>
            <xsl:text>Resource</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xcede:data[not(@xsi:type)]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataRef[@ID=$ID][1]" />
    <xsl:if test="count($linkedfrom|$FirstRef) = 1">
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="target">
            <xsl:value-of select="$targetframe"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat($basefile, '#', $newID)" />
          </xsl:attribute>
          <xsl:text>Data</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xcede:data[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'events_t')]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataRef[@ID=$ID][1]" />
    <xsl:if test="count($linkedfrom|$FirstRef) = 1">
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="target">
            <xsl:value-of select="$targetframe"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat($basefile, '#', $newID)" />
          </xsl:attribute>
          <xsl:text>Events</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="resource_t" match="xcede:resource[not(@xsi:type) or xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'resource_t')]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataResourceRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count($linkedfrom|$FirstRef) = 1">
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#', $newID)" />
            </xsl:attribute>
            <xsl:text>Resource</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'dataResource_t')]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataResourceRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count(linkedfrom|$FirstRef) = 1">
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#', $newID)" />
            </xsl:attribute>
            <xsl:text>Data Resource</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="binaryDataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'binaryDataResource_t')]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataResourceRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count($linkedfrom|$FirstRef) = 1">
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#', $newID)" />
            </xsl:attribute>
            <xsl:text>Binary Data Resource</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dimensionedBinaryDataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'dimensionedBinaryDataResource_t')]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataResourceRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count($linkedfrom|$FirstRef) = 1">
        <xsl:param name="nodims" select="0" />
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#', $newID)" />
            </xsl:attribute>
            <xsl:text>Dimensioned Binary Data Resource</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mappedBinaryDataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'mappedBinaryDataResource_t')]">
    <xsl:param name="linkedfrom" select="."/>
    <xsl:variable name="ID" select="string(@ID)" />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="FirstRef" select="//xcede:dataResourceRef[@ID=$ID][1]" />
    <xsl:choose>
      <xsl:when test="count($linkedfrom|$FirstRef) = 1">
        <xsl:element name="div">
          <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$targetframe"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($basefile, '#', $newID)" />
            </xsl:attribute>
            <xsl:text>Mapped Binary Data Resource</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xcede:provenance">
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:element name="div">
      <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
      <xsl:call-template name="showhide_checkbox">
        <xsl:with-param name="ID" select="$newID" />
        <xsl:with-param name="checked" select="1" />
      </xsl:call-template>
      <xsl:element name="a">
        <xsl:attribute name="target">
          <xsl:value-of select="$targetframe"/>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($basefile, '#', $newID)" />
        </xsl:attribute>
        <xsl:text>Provenance</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:protocol" name="protocol_t">
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:element name="div">
      <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="target">
          <xsl:value-of select="$targetframe"/>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($basefile, '#', $newID)" />
        </xsl:attribute>
        <xsl:text>Protocol</xsl:text>
        <xsl:if test="@ID">
          <xsl:value-of select="concat(' ', @ID)" />
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:analysis" name="analysis_t">
    <xsl:param name="linkedfrom" select="." />
    <xsl:variable name="newID" select="xcede:xcedeID()" />
    <xsl:variable name="targetNode" select="xcede:findLevelElement(.)" />
    <xsl:if test="count($linkedfrom|$targetNode) = 1">
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle-nav</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="target">
            <xsl:value-of select="$targetframe"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat($basefile, '#', $newID)" />
          </xsl:attribute>
          <xsl:text>Analysis</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*|text()">
    <!-- no-op -->
  </xsl:template>

</xsl:stylesheet>
