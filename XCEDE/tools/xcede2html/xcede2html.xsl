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

  <!-- ======================================= -->
  <!--                TEMPLATES                -->
  <!-- ======================================= -->

  <xsl:template match="/xcede:XCEDE">
    <html>
      <head>
        <link rel="stylesheet" href="xcede2html.css" type="text/css" media="screen"/>
        <title>XCEDE dataset</title>
      </head>
      <body bgcolor="#FFFFFF">
        <xsl:element name="div">
          <xsl:attribute name="class">elementList</xsl:attribute>
          <p><b>Element list:</b></p>
          <ul>
            <xsl:for-each select="xcede:project|xcede:subject|xcede:visit|xcede:study|xcede:episode|xcede:acquisition">
              <li>
                <xsl:value-of select="concat(local-name(), ' ')" />
                <xsl:choose>
                  <xsl:when test="local-name()='project'">
                    <xsl:value-of select="dyn:evaluate($projectUIDTopexpr)" />
                  </xsl:when>
                  <xsl:when test="local-name()='subject'">
                    <xsl:value-of select="dyn:evaluate($subjectUIDTopexpr)" />
                  </xsl:when>
                  <xsl:when test="local-name()='visit'">
                    <xsl:value-of select="dyn:evaluate($visitUIDTopexpr)" />
                  </xsl:when>
                  <xsl:when test="local-name()='study'">
                    <xsl:value-of select="dyn:evaluate($studyUIDTopexpr)" />
                  </xsl:when>
                  <xsl:when test="local-name()='episode'">
                    <xsl:value-of select="dyn:evaluate($episodeUIDTopexpr)" />
                  </xsl:when>
                  <xsl:when test="local-name()='acquisition'">
                    <xsl:value-of select="dyn:evaluate($acquisitionUIDTopexpr)" />
                  </xsl:when>
                </xsl:choose>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:element>
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
      </body>
    </html>
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
    <xsl:element name="div">
      <xsl:attribute name="class">
        <xsl:value-of select="$levelname"/>
      </xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="concat($levelname,'Title')" />
        </xsl:attribute>
        <span class='levelName'>
          <xsl:value-of select="$LevelName" />
          <xsl:value-of select="':'" />
        </span>
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
  </xsl:template>

  <xsl:template name="visit">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="study">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="episode">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="acquisition">
    <xsl:apply-templates />
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
        <xsl:apply-templates select="//xcede:data[@ID=$ID]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:attribute name="class">block</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">blockTitle</xsl:attribute>
            <xsl:text>Data [</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('#data', $ID)" />
              </xsl:attribute>
              <xsl:text>link</xsl:text>
            </xsl:element>
            <xsl:text>]</xsl:text>
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
        <xsl:apply-templates select="//xcede:resource[@ID=$ID]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:attribute name="class">block</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">blockTitle</xsl:attribute>
            <xsl:text>Resource [</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('#data', $ID)" />
              </xsl:attribute>
              <xsl:text>link</xsl:text>
            </xsl:element>
            <xsl:text>]</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xcede:description">
    <xsl:element name="div">
      <xsl:attribute name="class">description</xsl:attribute>
      <xsl:for-each select="xcede:text">
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:subjectGroup">
    <xsl:element name="div">
      <xsl:attribute name="class">floatingBlock</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:value-of select="@ID" />
      </xsl:element>
      <xsl:element name="ul">
        <xsl:for-each select="xcede:subjectID">
          <xsl:element name="li">
            <xsl:attribute name="class">subjectID</xsl:attribute>
            <xsl:value-of select="string(.)" />
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:subjectGroupList">
    <xsl:element name="div">
      <xsl:attribute name="class">leftBlock</xsl:attribute>
      <xsl:if test="count(xcede:subjectGroup) > 0">
        <xsl:element name="div">
          <xsl:attribute name='class'>blockTitle</xsl:attribute>
          <xsl:text>Subject groups:</xsl:text>
        </xsl:element>
        <xsl:apply-templates />
        <xsl:element name="div">
          <xsl:attribute name="class">afterFloatBlock</xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:projectInfo">
    <xsl:element name="div">
      <xsl:attribute name="class">levelInfo</xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:contributor">
    <xsl:element name="li">
      <xsl:attribute name="class">contributor</xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">contributorName</xsl:attribute>
        <xsl:value-of select="xcede:salutation" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="xcede:givenName" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="xcede:middleName" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="xcede:surname" />
      </xsl:element>
      <xsl:text> </xsl:text>
      <xsl:element name="span">
        <xsl:attribute name="class">academicTitles</xsl:attribute>
        <xsl:value-of select="xcede:academicTitles" />
      </xsl:element>
      <xsl:text> </xsl:text>
      <xsl:if test="xcede:institution or xcede:department">
        <xsl:text>(</xsl:text>
        <xsl:if test="xcede:institution">
          <xsl:element name="span">
            <xsl:attribute name="class">institution</xsl:attribute>
            <xsl:value-of select="xcede:institution" />
          </xsl:element>
          <xsl:if test="xcede:department">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:element name="span">
          <xsl:attribute name="class">department</xsl:attribute>
          <xsl:value-of select="xcede:department" />
        </xsl:element>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:contributorList">
    <xsl:element name="div">
      <xsl:attribute name="class">leftBlock</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Contributors:</xsl:text>
      </xsl:element>
      <xsl:element name="ul">
        <xsl:apply-templates />
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:subjectInfo">
    <xsl:element name="div">
      <xsl:attribute name="class">levelInfo</xsl:attribute>
      <xsl:for-each select="xcede:sex">
        <xsl:element name="div">
          <xsl:attribute name="class">sex</xsl:attribute>
          <xsl:text>Sex: </xsl:text>
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="xcede:species">
        <xsl:element name="div">
          <xsl:attribute name="class">species</xsl:attribute>
          <xsl:text>Species: </xsl:text>
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="xcede:birthdate">
        <xsl:element name="div">
          <xsl:attribute name="class">birthdate</xsl:attribute>
          <xsl:text>Birth Date: </xsl:text>
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:for-each>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:visitInfo">
    <xsl:element name="div">
      <xsl:attribute name="class">levelInfo</xsl:attribute>
      <xsl:for-each select="xcede:timeStamp">
        <xsl:element name="div">
          <xsl:attribute name="class">timeStamp</xsl:attribute>
          <xsl:text>Date/Time: </xsl:text>
          <xsl:call-template name="formatDateTime">
            <xsl:with-param name="datetimestr">
              <xsl:value-of select="string(.)" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:episodeInfo">
    <xsl:element name="div">
      <xsl:attribute name="class">levelInfo</xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:annotation">
    <xsl:element name="div">
      <xsl:attribute name="class">annotation</xsl:attribute>
      <xsl:for-each select="xcede:comment">
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:annotationList">
    <xsl:element name="div">
      <xsl:attribute name="class">annotationList</xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template name="attrAsString">
    <xsl:param name="paren" select="0" />
    <xsl:param name="separator" select="''" />
    <xsl:if test="position() = 1">
      <xsl:if test="$paren">
        <xsl:text>(</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="position() != 1">
      <xsl:value-of select="$separator" />
    </xsl:if>
    <xsl:element name="span">
      <xsl:attribute name="class">attr</xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">attrName</xsl:attribute>
        <xsl:value-of select="local-name()"/>
      </xsl:element>
      <xsl:text>=</xsl:text>
      <xsl:element name="span">
        <xsl:attribute name="class">attrValue</xsl:attribute>
        <xsl:value-of select="string(.)"/>
      </xsl:element>
      <xsl:if test="$paren">
        <xsl:if test="position() = last()">
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template name="attrsAsString">
    <xsl:param name="paren" select="0" />
    <xsl:for-each select="@*">
      <xsl:call-template name="attrAsString">
        <xsl:with-param name="paren" select="$paren" />
        <xsl:with-param name="separator" select="', '" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="elementContent" >
    <xsl:choose>
      <xsl:when test="*">
        <xsl:element name="div">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">fieldName</xsl:attribute>
            <xsl:value-of select="local-name()" />
            <xsl:text>:</xsl:text>
          </xsl:element>
          <xsl:call-template name="genericElement" />
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:element name="span">
            <xsl:attribute name="class">fieldName</xsl:attribute>
            <xsl:value-of select="local-name()" />
          </xsl:element>
          <xsl:if test="@*">
            <xsl:element name="span">
              <xsl:attribute name="class">fieldParam</xsl:attribute>
              <xsl:text> (</xsl:text>
              <xsl:call-template name="attrsAsString" />
              <xsl:text>)</xsl:text>
            </xsl:element>
          </xsl:if>
          <xsl:text>: </xsl:text>
          <xsl:element name="span">
            <xsl:attribute name="class">fieldValue</xsl:attribute>
            <xsl:value-of select="string(.)" />
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="genericElement">
    <xsl:param name="title" />
    <xsl:element name="div">
      <xsl:attribute name="class">fieldGroup</xsl:attribute>
      <xsl:if test="$title != ''">
        <xsl:element name="div">
          <xsl:attribute name="class">fieldGroupTitle</xsl:attribute>
          <xsl:value-of select="$title" />
        </xsl:element>
      </xsl:if>
      <xsl:for-each select="*">
        <xsl:call-template name="elementContent" />
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:data">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Data</xsl:text>
        <xsl:if test="@ID">
          <xsl:value-of select="concat(' (ID=', @ID, ')')" />
        </xsl:if>
      </xsl:element>
      <xsl:element name="a">
        <xsl:attribute name="name">
          <xsl:value-of select="@ID" />
        </xsl:attribute>
      </xsl:element>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:event">
    <xsl:param name="units" />
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockHeader</xsl:attribute>
        <xsl:if test="@type">
          <xsl:element name="span">
            <xsl:attribute name="class">sideBar</xsl:attribute>
            <xsl:value-of select="@type" />
          </xsl:element>
        </xsl:if>
        <xsl:if test="xcede:onset">
          <xsl:element name="span">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="xcede:onset" />
            <xsl:choose>
              <xsl:when test="xcede:duration">
                <xsl:text>,</xsl:text>
                <xsl:value-of select="xcede:onset + xcede:duration" />
                <xsl:text>)</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>]</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="$units != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$units" />
              </xsl:when>
              <xsl:when test="units">
                <xsl:text> </xsl:text>
                <xsl:value-of select="units" />
              </xsl:when>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">fieldGroup</xsl:attribute>
        <xsl:for-each select="xcede:value">
          <xsl:element name="div">
            <xsl:attribute name="class">field</xsl:attribute>
            <xsl:element name="span">
              <xsl:attribute name="class">fieldName</xsl:attribute>
              <xsl:value-of select="@name" />
            </xsl:element>
            <xsl:text>: </xsl:text>
            <xsl:element name="span">
              <xsl:attribute name="class">fieldValue</xsl:attribute>
              <xsl:value-of select="string(.)" />
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="xcede:data[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'events_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">overflowBlock</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Events</xsl:text>
        <xsl:if test="@ID">
          <xsl:value-of select="concat(' (ID=', @ID, ')')" />
        </xsl:if>
      </xsl:element>
      <xsl:element name="a">
        <xsl:attribute name="name">
          <xsl:value-of select="@ID" />
        </xsl:attribute>
      </xsl:element>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template name="resource_t" match="xcede:resource[not(@xsi:type) or xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'resource_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">overflowBlock</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Resource</xsl:text>
      </xsl:element>
      <xsl:element name="a">
        <xsl:attribute name="name">
          <xsl:value-of select="@ID" />
        </xsl:attribute>
      </xsl:element>
      <xsl:for-each select="@ID|@name|@description|@level|@projectID|@subjectID|@subjectGroupID|@visitID|@studyID|@episodeID|@acquisitionID">
        <xsl:call-template name="attrAsString">
          <xsl:with-param name="paren" select="1" />
          <xsl:with-param name="separator" select="', '" />
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="xcede:uri">
        <xsl:call-template name="elementContent" />
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="dataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'dataResource_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Data Resource</xsl:text>
      </xsl:element>
      <xsl:apply-templates select="xcede:provenance" />
      <xsl:call-template name="resource_t" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="binaryDataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'binaryDataResource_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Binary Data Resource</xsl:text>
      </xsl:element>
      <xsl:for-each select="xcede:elementType|xcede:byteOrder|xcede:compression">
        <xsl:call-template name="elementContent" />
      </xsl:for-each>
      <xsl:call-template name="dataResource_t" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="binaryDataDimension_t">
    <xsl:element name="div">
      <xsl:attribute name="class">fieldGroup</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">fieldGroupTitle</xsl:attribute>
        <xsl:text>binaryDataDimension</xsl:text>
      </xsl:element>
      <xsl:for-each select="xcede:size|@splitRank|@outputSelect">
        <xsl:call-template name="elementContent" />
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="dimensionedBinaryDataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'dimensionedBinaryDataResource_t')]">
    <xsl:param name="nodims" select="0" />
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Dimensioned Binary Data Resource</xsl:text>
      </xsl:element>
      <xsl:for-each select="xcede:dimension">
        <xsl:text>Dimension </xsl:text>
        <xsl:value-of select="@label"/>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="binaryDataDimension_t"/>
      </xsl:for-each>
      <xsl:call-template name="binaryDataResource_t" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="mappedBinaryDataDimension_t">
    <xsl:element name="div">
      <xsl:attribute name="class">fieldGroup</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">fieldGroupTitle</xsl:attribute>
        <xsl:text>mappedBinaryDataDimension</xsl:text>
      </xsl:element>
      <xsl:for-each select="xcede:origin|xcede:spacing|xcede:gap|xcede:direction|xcede:units">
        <xsl:call-template name="elementContent" />
      </xsl:for-each>
      <xsl:for-each select="xcede:datapoints|xcede:measurementFrame">
        <xsl:call-template name="genericElement" />
      </xsl:for-each>
      <xsl:call-template name="binaryDataDimension_t"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="mappedBinaryDataResource_t" match="xcede:resource[xcede:checkTypeMatch(@xsi:type, 'http://www.xcede.org/xcede-2', 'mappedBinaryDataResource_t')]">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Mapped Binary Data Resource</xsl:text>
      </xsl:element>
      <xsl:for-each select="xcede:originCoords">
        <xsl:call-template name="elementContent" />
      </xsl:for-each>
      <xsl:for-each select="xcede:dimension">
        <xsl:text>Dimension </xsl:text>
        <xsl:value-of select="@label"/>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="mappedBinaryDataDimension_t"/>
      </xsl:for-each>
      <xsl:call-template name="binaryDataResource_t" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:processStep">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Process step</xsl:text>
        <xsl:if test="@ID">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="concat('ID=', @ID)" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:element>
      <xsl:call-template name="genericElement" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xcede:provenance">
    <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">blockTitle</xsl:attribute>
        <xsl:text>Provenance</xsl:text>
        <xsl:if test="@ID">
          <xsl:value-of select="concat(' (ID=', @ID, ')')" />
        </xsl:if>
      </xsl:element>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="*|text()">
    <!-- no-op -->
  </xsl:template>

</xsl:stylesheet>
