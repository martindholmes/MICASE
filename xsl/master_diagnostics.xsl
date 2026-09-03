<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace=""
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    expand-text="yes"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 2, 2026</xd:p>
            <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
            <xd:p>Let's find out what we have in the data, and how 
                  consistent it is.</xd:p>
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
        <xd:desc>Set this param to limit the run to a single diagnostic.</xd:desc>
    </xd:doc>
    <xsl:param name="runOnly" as="xs:string" select="''"/>
    
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
        <xsl:message>Running diagnostics...</xsl:message>
        <xsl:message>$runOnly = {$runOnly}</xsl:message>
        
        <xsl:result-document href="{$baseDir}/site/diagnostics.html">
            <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en" id="diagnostics">
                <head>
                    <title>MICASE Project Diagnostics</title>
                    <link rel="stylesheet" href="css/diagnostics.css"/>
                </head>
                <body>
                    <header>
                        <h1>MICASE Project Diagnostics</h1>
                    </header>
                    
                    <main>
                        <!-- Run everything, or just selected items? -->
                        <xsl:choose>
                            <xsl:when test="$runOnly eq ''">
                                <xsl:call-template name="statistics"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Run only the one(s) that are being called. -->
                                <xsl:for-each select="tokenize($runOnly, '\s*,\s*')">
                                    <xsl:variable name="templateName" as="xs:string" select="."/>
                                    <xsl:apply-templates select="$docRoot//xsl:template[@name = $templateName]"/>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </main>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Stats tells us what we have and how it works.</xd:desc>
    </xd:doc>
    <xsl:template name="statistics" match="xsl:template[@name='statistics']" as="element(xh:div)">
        <div class="statistics">
            <div id="statistics">
                <details>
                    <summary>Statistics <xsl:value-of select="format-date(current-date(), '[D1o] [MNn] [Y0001]')"/></summary>
                    <table class="statistics">
                        <thead>
                            <tr>
                                <td>Element</td><td>Instances</td><td>Parents</td><td>Children</td>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="distinct-values($xmlSource/descendant::*/local-name())">
                                <xsl:sort select="."/>
                                <xsl:variable name="currName" as="xs:string" select="."/>
                                <xsl:variable name="instances" as="element()+" select="$xmlSource/descendant::*[local-name() eq $currName]"/>
                                <xsl:variable name="parentNames" as="xs:string*" select="distinct-values((for $i in $instances return if ($i/parent::*) then $i/parent::*/local-name() else ()))"/>
                                <xsl:variable name="childNames" as="xs:string*" select="distinct-values((for $i in $instances return if ($i/child::*) then for $c in $i/child::* return $c/local-name() else ()))"/>
                                <tr>
                                    <td><xsl:value-of select="$currName"/></td>
                                    <td><xsl:value-of select="count($instances)"/></td>
                                    <td class="elements">
                                        <xsl:for-each select="$parentNames">
                                            <xsl:sort select="."/>
                                            <xsl:sequence select="."/>
                                            <xsl:if test="position() lt last()"><xsl:text>, </xsl:text></xsl:if>
                                        </xsl:for-each>
                                    </td>
                                    <td class="elements">
                                        <xsl:for-each select="$childNames">
                                            <xsl:sort select="."/>
                                            <xsl:sequence select="."/>
                                            <xsl:if test="position() lt last()"><xsl:text>, </xsl:text></xsl:if>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </details>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>