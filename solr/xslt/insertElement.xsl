<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="iisg marc">

    <xsl:template name="insertIISHIdentifiers">
        <xsl:param name="identifier"/>
        <iisg:identifier>
            <xsl:value-of select="$identifier"/>
        </iisg:identifier>
    </xsl:template>

    <xsl:template name="insertCollection">
        <xsl:param name="collection"/>
        <xsl:call-template name="output-tokens">
            <xsl:with-param name="list" select="concat($collection, '.')"/>
            <xsl:with-param name="separator" select="'.'"/>
            <xsl:with-param name="collection"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="output-tokens">
        <xsl:param name="list"/>
        <xsl:param name="separator"/>
        <xsl:param name="collection"/>
        <xsl:variable name="first" select="substring-before($list, $separator)"/>
        <xsl:variable name="remaining" select="substring-after($list, $separator)"/>
        <xsl:variable name="collectionName" select="concat($collection, $first)"/>
        <iisg:collectionName>
            <xsl:value-of select="$collectionName"/>
        </iisg:collectionName>
        <xsl:if test="$remaining">
            <xsl:call-template name="output-tokens">
                <xsl:with-param name="list" select="$remaining"/>
                <xsl:with-param name="separator" select="$separator"/>
                <xsl:with-param name="collection" select="concat($collectionName, $separator)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertElement">
        <xsl:param name="tag"/>
        <xsl:param name="value"/>
        <xsl:param name="code"/>

        <xsl:variable name="tmp1">
            <xsl:for-each select="$value">
                <xsl:value-of select="."/>
                <xsl:if test="not(position()=last())">.</xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="tmp2" select="normalize-space($tmp1)"/>

        <xsl:if test="$tmp2 and string-length($tmp2)!=0">
            <marc:datafield tag="{$tag}" ind1=" " ind2=" ">
                <marc:subfield code="{$code}">
                    <xsl:value-of select="$tmp2"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
    </xsl:template>

    <xsl:template name="marc_elements">
        <xsl:param name="tag"/>
        <xsl:param name="code"/>
        <xsl:param name="values"/>
        <xsl:for-each select="$values/value">
            <xsl:call-template name="insertElement">
                <xsl:with-param name="tag" select="$tag"/>
                <xsl:with-param name="code" select="$code"/>
                <xsl:with-param name="value" select="text()"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="not($values/value)">
            <xsl:call-template name="insertElement">
                <xsl:with-param name="tag" select="$tag"/>
                <xsl:with-param name="code" select="$code"/>
                <xsl:with-param name="value" select="$values/text()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>