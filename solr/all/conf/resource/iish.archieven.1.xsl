<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9">

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <!-- Change the odd Iisg header -->
    <xsl:template match="Iisg">
        <ead:ead xmlns="urn:isbn:1-931666-22-9"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
                 audience="{@audience}">
            <xsl:apply-templates select="node()"/>
        </ead:ead>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:choose>
            <xsl:when test="local-name()">
                <xsl:element name="{concat('ead:',local-name())}" namespace="urn:isbn:1-931666-22-9">
                    <xsl:copy-of select="attribute::*"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- And do not show... -->
    <xsl:template match="//archdesc/descgrp/acqinfo">
        <xsl:comment>archdesc/descgrp/acqinfo has been removed for privacy reasons.</xsl:comment>
    </xsl:template>

</xsl:stylesheet>