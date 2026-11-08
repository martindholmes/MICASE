<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    expand-text="yes"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 3, 2026</xd:p>
            <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
            <xd:p>This is the driver for the static site build.</xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xd:doc>
        <xd:desc>We're producing XHTML5.</xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" html-version="5" encoding="UTF-8" omit-xml-declaration="yes"
        normalization-form="NFC" indent="yes" exclude-result-prefixes="#all" include-content-type="no"/>
    
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
    
    <xd:doc>
        <xd:desc><xd:ref name="docRoot">docRoot</xd:ref> is needed in various contexts where the input
            document is out of scope.</xd:desc>
    </xd:doc>
    <xsl:variable name="docRoot" select="/"/>
    
    <xd:doc>
        <xd:desc>For the page template we process, the mode is basically an identity transform.</xd:desc>
    </xd:doc>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xd:doc>
        <xd:desc>This is the page template that will be used for all the pages.</xd:desc>
    </xd:doc>
    <xsl:variable name="pageTemplate" as="document-node()" select="doc($baseDir || '/templates/pageTemplate.xml')"/>
    
    <xd:doc>
        <xd:desc>This is the source XML: P5 generated from the original TEI.2 data.</xd:desc>
    </xd:doc>
    <xsl:variable name="xmlSource" as="document-node()+" select="collection($baseDir || '/p5/?select=*.xml;recurse=yes')"/>
    
    <xd:doc>
        <xd:desc>This is the source for content pages, which are written as XHTML article elements.</xd:desc>
    </xd:doc>
    <xsl:variable name="pageSource" as="document-node()+" select="collection($baseDir || '/pages/?select=*.xml;recurse=yes')"/>
    
    <xd:doc>
        <xd:desc>The root template calls each of the individual diagnostic processes.</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:message>Building site...</xsl:message>
        <xsl:message>$docsToBuild = {$docsToBuild}</xsl:message>
        
        <!-- First the corpus content. -->
        <xsl:for-each select="$xmlSource[(TEI/@xml:id = $docsToBuildIds) or ($docsToBuild eq '')]">
            <xsl:variable name="currId" as="xs:string" select="xs:string(TEI/@xml:id)"/>
            <xsl:message>Processing document {$currId}</xsl:message>
            <xsl:result-document href="{$baseDir}/site/{$currId}.html">
                <xsl:apply-templates select="$pageTemplate/xh:html">
                    <xsl:with-param name="currId" as="xs:string" select="$currId" tunnel="yes"/>
                    <xsl:with-param name="currP5" as="document-node()" select="." tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
        
        <!-- Next, the site pages. -->
        <xsl:for-each select="$pageSource[(xh:article/@id = $docsToBuildIds) or ($docsToBuild eq '')]">
            <xsl:variable name="currId" as="xs:string" select="xs:string(xh:article/@id)"/>
            <xsl:message>Processing document {$currId}</xsl:message>
            <xsl:result-document href="{$baseDir}/site/{$currId}.html">
                <xsl:apply-templates select="$pageTemplate/xh:html">
                    <xsl:with-param name="currId" as="xs:string" select="$currId" tunnel="yes"/>
                    <xsl:with-param name="currHtml" as="document-node()" select="." tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>