<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ead="urn:isbn:1-931666-22-9"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        exclude-result-prefixes="ead iisg marc">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:import href="../../../xslt/punctionation.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="Iisg">

        <xsl:variable name="identifier"
                      select="eadheader/eadid/@identifier"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <iisg:collectionName>iisg_ead</iisg:collectionName>
                    <iisg:collectionName>iisg.archieven.1</iisg:collectionName>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>
                        <xsl:value-of
                                select="concat('http://hdl.handle.net/', $identifier)"/>
                    </iisg:isShownAt>
                    <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="marc:controlfield[@tag='005']"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>

            <xsl:variable name="geognames" select="tokenize(//controlaccess/geogname, ',')"/>
            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">

                    <xsl:variable name="language">
                        <xsl:choose>
                            <xsl:when test="//langusage = 'Nederlands'">dut</xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="//langusage = 'dut'">dut</xsl:when>
                                    <xsl:otherwise>eng</xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <marc:leader>00742nbm a22001930a 45 0</marc:leader>

                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>
                    <marc:controlfield tag="008">
                        <xsl:value-of
                                select="concat('199507suuuuuuuu', $geognames[1],' |||||||||||||||||',$language,' d')"/>
                    </marc:controlfield>

                    <xsl:if test="$language">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'041'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value" select="substring($language, 1, 2)"/>
                        </xsl:call-template>
                    </xsl:if>

                    <marc:datafield tag="245" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="//archdesc/did/unittitle"/>
                        </marc:subfield>
                        <xsl:variable name="g" select="//archdesc/did/unitdate"/>
                        <xsl:if test="$g">
                            <marc:subfield code="g">
                                <xsl:value-of select="$g"/>
                            </marc:subfield>
                        </xsl:if>
                    </marc:datafield>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'300'"/>
                        <xsl:with-param name="code" select="'d'"/>
                        <xsl:with-param name="value" select="//archdesc/did/physdesc"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//repository/corpname"/>
                    </xsl:call-template>

                    <marc:datafield tag="506" ind1=" " ind2=" ">
                        <xsl:variable name="p1" select="//accessrestrict/p[1]"/>
                        <xsl:variable name="p2" select="//accessrestrict/p[2]"/>
                        <marc:subfield code="a">
                            <xsl:value-of select="$p1"/>
                        </marc:subfield>
                        <xsl:if test="$p2">
                            <marc:subfield code="b">
                                <xsl:value-of select="$p2"/>
                            </marc:subfield>
                        </xsl:if>
                    </marc:datafield>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'545'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//bioghist/p"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'520'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//scopecontent/p"/>
                    </xsl:call-template>

                    <xsl:for-each select="$geognames">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'651'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>


                    <xsl:if test="//origination/persname">
                        <marc:datafield tag="700" ind1="1" ind2=" ">
                            <marc:subfield code="a">
                                <xsl:call-template name="addLastComma">
                                    <xsl:with-param name="tmp" select="//origination/persname[1]"/>
                                </xsl:call-template>
                            </marc:subfield>
                            <marc:subfield code="e">collector</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <xsl:if test="//origination/corpname">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">
                                <xsl:call-template name="addLastComma">
                                    <xsl:with-param name="tmp" select="//origination/corpname[1]"/>
                                </xsl:call-template>
                            </marc:subfield>
                            <marc:subfield code="e">collector</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <xsl:if test="//origination/name">
                        <marc:datafield tag="711" ind1="2" ind2=" ">
                            <marc:subfield code="a">
                                <xsl:call-template name="addLastComma">
                                    <xsl:with-param name="tmp" select="//origination/name[1]"/>
                                </xsl:call-template>
                            </marc:subfield>
                            <marc:subfield code="e">collector</marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value"
                                        select="concat('http://api.socialhistoryservices.org/solr/all/oai?verb=GetRecord&amp;identifier=oai:socialhistoryservices.org:',$identifier,'&amp;metadataPrefix=ead')"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'902'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="$identifier"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

</xsl:stylesheet>