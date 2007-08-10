<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns="http://www.xcede.org/xcede-2"
  xmlns:xcede="http://www.xcede.org/xcede-2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dyn="http://exslt.org/dynamic"
  exclude-result-prefixes="xsl xcede"
  version="1.0">

  <xsl:output method="html"/>

  <xsl:param name="IDsep" select="':'"/>

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

  <xsl:template match="/xcede:XCEDE">
    <html>
      <head>
        <link rel="stylesheet" href="xcede2html.css" type="text/css" media="screen"/>
        <title>XCEDE dataset</title>
      </head>
      <body bgcolor="#FFFFFF">
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
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="$levelname"/>
      </xsl:attribute>
      <span>
        <xsl:attribute name="class">
          <xsl:value-of select="concat($levelname,'Title')" />
        </xsl:attribute>
        <xsl:value-of select="$LevelName" />
        <xsl:if test="local-name()=$levelname">
          <xsl:value-of select="concat(' ',@ID)" />
        </xsl:if>
      </span>

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
    </div>
  </xsl:template>

  <xsl:template name="calllevel">
    <xsl:param name="levelname" />
    <xsl:param name="UID" />
    <xsl:if test="xcede:annotationList">
      <ul>
        <xsl:for-each select="xcede:annotationList/xcede:annotation">
          <li><xsl:value-of select="string(xcede:text)" /></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
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
  </xsl:template>

  <xsl:template name="visit">
  </xsl:template>

  <xsl:template name="study">
  </xsl:template>

  <xsl:template name="episode">
  </xsl:template>

  <xsl:template name="acquisition">
  </xsl:template>

</xsl:stylesheet>
