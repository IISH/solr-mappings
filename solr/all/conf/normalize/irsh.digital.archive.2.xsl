<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        exclude-result-prefixes="iisg marc">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="article">

        <xsl:variable name="identifier"
                      select="concat('10622/', front/journal-meta/issn[@pub-type='ppub'], '.', front/article-meta/volume, '.', front/article-meta/issue)"/>
        <xsl:variable name="isShownByPdf"
                      select="concat('http://hdl.handle.net/10622/', front/article-meta/article-id[@pub-id-type='pii'], '?locatt=view:master')"/>
        <xsl:variable name="isShownByThumbnail"
                      select="concat('http://hdl.handle.net/10622/', front/article-meta/article-id[@pub-id-type='pii'], '?locatt=view:level3')"/>
        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>
                        <xsl:value-of select="concat('http://hdl.handle.net/', $identifier)"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:copy-of select="$isShownByPdf"/>
                    </iisg:isShownBy>
                    <iisg:isShownBy>
                        <xsl:copy-of select="$isShownByThumbnail"/>
                    </iisg:isShownBy>
                    <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="$marc_controlfield_005"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>

            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">

                    <marc:leader>00857nas a22001810a 45 0</marc:leader>
                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>
                    <marc:controlfield tag="003">NL-AMISG</marc:controlfield>
                    <marc:controlfield tag="005">
                        <xsl:value-of select="$marc_controlfield_005"/>
                    </marc:controlfield>
                    <marc:controlfield tag="008">199902suuuuuuuu||||||||||||||||||||eng d</marc:controlfield>

                    <xsl:if test="front/article-meta/contrib-group/contrib/name/given-name and front/article-meta/contrib-group/contrib/name/surname">
                        <xsl:call-template name="insertSingleElement">
                            <xsl:with-param name="tag">100</xsl:with-param>
                            <xsl:with-param name="code">a</xsl:with-param>
                            <xsl:with-param name="value"
                                            select="concat(front/article-meta/contrib-group/contrib/name/given-name, ', ', front/article-meta/contrib-group/contrib/name/surname)"/>
                        </xsl:call-template>
                    </xsl:if>

                    <marc:datafield tag="260" ind0=" " ind1=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="concat(front/journal-meta/publisher/publisher-loc, ' :')"/>
                        </marc:subfield>
                        <marc:subfield code="b">
                            <xsl:value-of select="concat(front/journal-meta/publisher/publisher-name, ',')"/>
                        </marc:subfield>
                        <marc:subfield code="c">
                            <xsl:value-of select="front/article-meta/pub-date/year"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">300</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value"
                                        select="concat(front/article-meta/counts/page-count/@count, ' p.')"/>
                    </xsl:call-template>

                    <marc:datafield tag="245" ind0=" " ind1=" ">
                        <marc:subfield code="a">
                            <xsl:choose>
                                <xsl:when test="front/article-meta/title-group/article-title">
                                    <xsl:value-of select="front/article-meta/title-group/article-title"/>
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="concat('Article from the ', front/journal-meta/journal-title, ', ', front/article-meta/volume, '(', front/article-meta/pub-date[@pub-type='ppub']/year, ') no.', front/article-meta/issue, ', p. ', front/article-meta/fpage, '-', front/article-meta/lpage, '.')"/></xsl:otherwise>
                            </xsl:choose>
                        </marc:subfield>
                    </marc:datafield>

                    <marc:datafield tag="500" ind0=" " ind1=" ">
                        <marc:subfield code="a">
                            <xsl:value-of
                                    select="concat('From the ', front/journal-meta/journal-title, ', ', front/article-meta/volume, '(', front/article-meta/pub-date[@pub-type='ppub']/year, ') no.', front/article-meta/issue, ', p. ', front/article-meta/fpage, '-', front/article-meta/lpage, '.')"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag">520</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value" select="front/article-meta/abstract"/>
                    </xsl:call-template>

                    <xsl:if test="front/article-meta/permissions/copyright-statement">
                        <xsl:call-template name="insertSingleElement">
                            <xsl:with-param name="tag">845</xsl:with-param>
                            <xsl:with-param name="code">a</xsl:with-param>
                            <xsl:with-param name="value" select="front/article-meta/permissions/copyright-statement"/>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">856</xsl:with-param>
                        <xsl:with-param name="code">u</xsl:with-param>
                        <xsl:with-param name="value" select="$isShownByPdf"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">856</xsl:with-param>
                        <xsl:with-param name="code">u</xsl:with-param>
                        <xsl:with-param name="value" select="$isShownByThumbnail"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">902</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value" select="$identifier"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

</xsl:stylesheet>