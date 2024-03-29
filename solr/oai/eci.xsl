<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2010 International Institute for Social History, The Netherlands.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns:saxon="http://saxon.sf.net/"
                exclude-result-prefixes="saxon">

    <xsl:import href="oai.xsl"/>
    <xsl:output omit-xml-declaration="yes"/>
    <xsl:param name="prefix"/>

    <xsl:template name="metadata">
        <metadata>
            <xsl:variable name="eci" select="$doc//str[@name='original']/text()"/>
            <xsl:choose>
                <xsl:when test="$eci"><xsl:copy-of select="saxon:parse($eci)/node()"/></xsl:when>
                <xsl:otherwise><xsl:copy-of select="saxon:parse($doc//str[@name='resource']/text())/node()//recordData/*"/></xsl:otherwise>
            </xsl:choose>
        </metadata>
    </xsl:template>

</xsl:stylesheet>