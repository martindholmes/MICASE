<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace=""
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    expand-text="yes"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 11, 2026</xd:p>
            <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
            <xd:p>This abstracts components used in multiple transformations.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>For clarity, we use a projDir from the Ant build file.</xd:desc>
    </xd:doc>
    <xsl:param name="projDir" as="xs:string" select="'..'"/>
    
    <xd:doc>
        <xd:desc>This is the source for content pages, which are written as XHTML article elements.</xd:desc>
    </xd:doc>
    <xsl:variable name="pageSource" as="document-node()+" select="collection($projDir || '/pages/?select=*.xml;recurse=yes')"/>
    
    <xd:doc>
        <xd:desc>This is the page template that will be used for all the pages.</xd:desc>
    </xd:doc>
    <xsl:variable name="pageTemplate" as="document-node()" select="doc($projDir || '/templates/pageTemplate.xml')"/>
    
    <xd:doc>
        <xd:desc>The metadata taxonomies.</xd:desc>
    </xd:doc>
    <xsl:variable name="taxonomies" as="element(tei:taxonomy)+">
        <xsl:sequence select="doc($projDir || '/metadata/metadata.xml')//tei:taxonomy"/>
    </xsl:variable>
    
    <xd:doc>
        <xd:desc>A map of all the metadata keys to their categories.</xd:desc>
    </xd:doc>
    <xsl:variable name="mapMetaKeysToCategories" as="map(xs:string, element(tei:category))">
        <xsl:map>
            <xsl:for-each select="$taxonomies">
                <xsl:variable name="taxId" as="xs:string" select="xs:string(@xml:id)"/>
                <xsl:for-each select="descendant::category">
                    <xsl:map-entry key="concat($taxId, '_', xs:string(@n))" select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    
    <xd:doc>
        <xd:desc>This is a quick lookup map for taxonomy descriptions, from id pointers.</xd:desc>
    </xd:doc>
    <xsl:variable name="mapTaxPtrToDesc" as="map(xs:string, xs:string)">
        <xsl:map>
            <xsl:for-each select="$taxonomies">
                <xsl:map-entry key="'tax:' || xs:string(@xml:id)" select="xs:string(tei:gloss)"/>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    
    
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
    <xsl:variable name="xmlSource" as="document-node()+" select="collection($projDir || '/data/?select=*.xml;recurse=yes')"/>
    
    <xd:doc>
        <xd:desc>This is the generated P5 XML.</xd:desc>
    </xd:doc>
    <xsl:variable name="p5Source" as="document-node()+" select="collection($projDir || '/p5/?select=*.xml;recurse=yes')"/>
    
</xsl:stylesheet>