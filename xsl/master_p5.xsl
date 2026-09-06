<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace=""
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    expand-text="yes"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 6, 2026</xd:p>
            <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
            <xd:p>This converts the old TEI.2 to TEI P5.</xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xd:doc>
        <xd:desc>We're producing XHTML5.</xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" html-version="5" encoding="UTF-8" omit-xml-declaration="yes"
        normalization-form="NFC" indent="yes" exclude-result-prefixes="#all" include-content-type="no"/>
    
    <xd:doc>
        <xd:desc>For now, we output what we see unless there's a template for it.</xd:desc>
    </xd:doc>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xd:doc>
        <xd:desc>For clarity, we use a basedir from the Ant build file.</xd:desc>
    </xd:doc>
    <xsl:param name="baseDir" as="xs:string" select="'..'"/>
    
    <xd:doc>
        <xd:desc>Set this param to limit the build to a single file.</xd:desc>
    </xd:doc>
    <xsl:param name="docsToBuild" as="xs:string" select="''"/>
    
    <xd:doc>
        <xd:desc>Split those docsToBuild...</xd:desc>
    </xd:doc>
    <xsl:variable name="docsToBuildIds" as="xs:string*" select="tokenize($docsToBuild, '\s*,\s*')"/>
    
    <xd:doc scope="component">
        <xd:desc><xd:ref name="docRoot">docRoot</xd:ref> is needed in various contexts where the input
            document is out of scope.</xd:desc>
    </xd:doc>
    <xsl:variable name="docRoot" select="/"/>
    
    <xd:doc>
        <xd:desc>This is the source XML.</xd:desc>
    </xd:doc>
    <xsl:variable name="xmlSource" as="document-node()+" select="collection($baseDir || '/data/?select=*.xml;recurse=yes')"/>
    
    <xd:doc>
        <xd:desc>The root template calls each of the individual diagnostic processes.</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:message>Building site...</xsl:message>
        <xsl:message>$docsToBuild = {$docsToBuild}</xsl:message>
        
        <xsl:for-each select="$xmlSource[TEI.2/@ID = $docsToBuildIds or $docsToBuild eq '']">
            <xsl:variable name="currId" as="xs:string" select="xs:string(TEI.2/@ID)"/>
            <xsl:message>Processing document {TEI.2/@ID}</xsl:message>
            <xsl:result-document href="{$baseDir}/p5/{$currId}.xml">
                <xsl:apply-templates/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Root element</xd:desc>
    </xd:doc>
    <xsl:template match="TEI.2">
        <TEI>
            <xsl:apply-templates select="@* | node()"/>
        </TEI>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Header elements</xd:desc>
    </xd:doc>
    <xsl:template match="TEIHEADER">
        <teiHeader>
            <xsl:apply-templates select="@* | node()"/>
        </teiHeader>
    </xsl:template>
    <xsl:template match="FILEDESC">
        <fileDesc>
            <xsl:apply-templates select="@* | node()"/>
        </fileDesc>
    </xsl:template>
    <xsl:template match="TITLESTMT">
        <titleStmt>
            <xsl:apply-templates select="@* | node()"/>
        </titleStmt>
    </xsl:template>
    <xsl:template match="TITLE">
        <title>
            <xsl:apply-templates select="@* | node()"/>
        </title>
    </xsl:template>
    <xsl:template match="WORDCOUNT">
        <extent>
            <measure unit="words"><xsl:sequence select="normalize-space(text())"/></measure>
        </extent>
    </xsl:template>
    <xsl:template match="PUBLICATIONSTMT">
        <publicationStmt>
            <xsl:apply-templates select="@* | node()"/>
        </publicationStmt>
    </xsl:template>
    <xsl:template match="PUBLISHER">
        <publisher>
            <xsl:apply-templates select="@* | node()"/>
        </publisher>
    </xsl:template>
    <xsl:template match="P">
        <p>
            <xsl:apply-templates select="@* | node()"/>
        </p>
    </xsl:template>
    <xsl:template match="AVAILABILITY">
        <availability>
            <xsl:apply-templates select="@* | node()"/>
        </availability>
    </xsl:template>
    <xsl:template match="IDNO">
        <idno>
            <xsl:apply-templates select="@* | node()"/>
        </idno>
    </xsl:template>
    <xsl:template match="IDNO/text()">
        <idno>
            <xsl:sequence select="normalize-space(.)"/>
        </idno>
    </xsl:template>
    <xsl:template match="SOURCEDESC">
        <sourceDesc>
            <xsl:apply-templates select="@* | node()"/>
        </sourceDesc>
    </xsl:template>
    <xsl:template match="RECORDINGSTMT">
        <recording>
            <xsl:apply-templates select="@* | node()"/>
        </recording>
    </xsl:template>
    <xsl:template match="RECORDING">
        <recordingStmt>
            <xsl:apply-templates select="@* | node()"/>
        </recordingStmt>
    </xsl:template>
    <xsl:template match="EQUIPMENT">
        <equipment>
            <xsl:apply-templates select="@* | node()"/>
        </equipment>
    </xsl:template>
    <xsl:template match="DATE">
        <date>
            <xsl:apply-templates select="@* | node()"/>
        </date>
    </xsl:template>
    <xsl:template match="RESPSTMT">
        <respStmt>
            <xsl:apply-templates select="@* | node()"/>
        </respStmt>
    </xsl:template>
    <xsl:template match="RESP">
        <resp>
            <xsl:apply-templates select="@* | node()"/>
        </resp>
    </xsl:template>
    <xsl:template match="NAME">
        <name>
            <xsl:apply-templates select="@* | node()"/>
        </name>
    </xsl:template>
    <xsl:template match="PROFILEDESC">
        <profileDesc>
            <xsl:apply-templates select="@* | node()"/>
        </profileDesc>
    </xsl:template>
    <xsl:template match="LANGUSAGE">
        <langUsage>
            <xsl:apply-templates select="@* | node()"/>
        </langUsage>
    </xsl:template>
    <xsl:template match="LANGUAGE">
        <language>
            <xsl:apply-templates select="@* | node()"/>
        </language>
    </xsl:template>
    <xsl:template match="PARTICDESC">
        <particDesc>
            <xsl:apply-templates select="@* | node()"/>
        </particDesc>
    </xsl:template>
    <xsl:template match="PERSON">
        <person>
            <xsl:apply-templates select="@* | node()"/>
        </person>
    </xsl:template>
    <xsl:template match="PERSONGRP">
        <personGrp>
            <xsl:apply-templates select="@* | node()"/>
        </personGrp>
    </xsl:template>
    <xsl:template match="SETTINGDESC">
        <settingDesc>
            <xsl:apply-templates select="@* | node()"/>
        </settingDesc>
    </xsl:template>
    <xsl:template match="SETTING">
        <setting>
            <xsl:apply-templates select="@* | node()"/>
        </setting>
    </xsl:template>
    <xsl:template match="TEXT">
        <text>
            <xsl:apply-templates select="@* | node()"/>
        </text>
    </xsl:template>
    <xsl:template match="BODY">
        <body>
            <xsl:apply-templates select="@* | node()"/>
        </body>
    </xsl:template>
    <xsl:template match="U">
        <u>
            <xsl:apply-templates select="@* | node()"/>
        </u>
    </xsl:template>
    <xsl:template match="OVERLAP">
        <seg type="overlap">
            <xsl:apply-templates select="@* | node()"/>
        </seg>
    </xsl:template>
    <xsl:template match="PAUSE">
        <pause>
            <xsl:apply-templates select="@* | node()"/>
        </pause>
    </xsl:template>
    <xsl:template match="EVENT">
        <incident>
            <xsl:apply-templates select="@ITERATED"/>
            <xsl:apply-templates select="@DESC"/>
        </incident>
    </xsl:template>
    
    <!-- ************ ATTRIBUTES ************* -->
    <xsl:template match="@ID">
        <xsl:attribute name="xml:id" select="."/>
    </xsl:template>
    <xsl:template match="U/@WHO">
        <xsl:attribute name="who" select="'#' || ."/>
    </xsl:template>
    <xsl:template match="EVENT/@DESC">
        <desc>
            <xsl:sequence select="xs:string(.)"/>
        </desc>
    </xsl:template>
    <xsl:template match="EVENT/@ITERATED">
        <xsl:attribute name="type" select="if (. eq 'N') then 'non-iterated' else 'iterated'"/>
    </xsl:template>
    <xsl:template match="@TRANS">
        <xsl:attribute name="trans" select="lower-case(.)"/>
    </xsl:template>
    <xsl:template match="@DUR">
        <xsl:attribute name="dur" select="."/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Many attributes we don't want, including default ones.</xd:desc>
    </xd:doc>
    <xsl:template match="TEIHEADER/@TYPE | @TEIFORM | @STATUS | @DEFAULT"/>
</xsl:stylesheet>