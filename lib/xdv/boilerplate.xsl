<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dv="http://namespaces.plone.org/xdv"
    xmlns:esi="http://www.edge-delivery.org/esi/1.0"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="exsl str dv xhtml" >
  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"
      media-type="text/html" encoding="utf-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

    <xsl:template match="/">

        <!-- Pass incoming content through initial-stage filter. -->
        <xsl:variable name="initial-stage-rtf">
            <xsl:apply-templates select="/" mode="initial-stage"/>
        </xsl:variable>
        <xsl:variable name="initial-stage" select="exsl:node-set($initial-stage-rtf)"/>

        <!-- Now apply the theme to the initial-stage content -->
        <xsl:variable name="themedcontent-rtf">
            <xsl:apply-templates select="$initial-stage" mode="apply-theme"/>
        </xsl:variable>
        <xsl:variable name="content" select="exsl:node-set($themedcontent-rtf)"/>

        <!-- We're done, so generate some output by passing 
            through a final stage. -->
        <xsl:apply-templates select="$content" mode="final-stage"/>

    </xsl:template>

    <!-- 
    
        Utility templates
    -->
    <xsl:template match="none" mode="insert-drop-rules">
        <!-- The compiler looks for this and replaces 
        the @match and @mode. -->
    </xsl:template>
    <xsl:template match="node()|@*" mode="initial-stage">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="initial-stage"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="pre/text()" mode="initial-stage">
        <!-- Filter out quoted &#13; -->
        <xsl:value-of select="str:replace(., '&#13;&#10;', '&#10;')"/>
    </xsl:template>
    <xsl:template match="/" mode="apply-theme">
        <dv:insert/>
    </xsl:template>
    <xsl:template match="style|script|xhtml:style|xhtml:script" priority="5" mode="final-stage">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*" mode="final-stage"/>
            <xsl:value-of select="text()" disable-output-escaping="yes"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="node()|@*" priority="1" mode="final-stage">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="final-stage"/>
        </xsl:copy>
    </xsl:template>

    <!-- 
    
        Extra templates
    -->
    <dv:insert-extra/>
</xsl:stylesheet>
