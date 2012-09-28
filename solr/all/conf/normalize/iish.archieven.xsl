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

                    <xsl:if test="//origination/persname">
                        <marc:datafield tag="100" ind1="1" ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of select="//origination/persname[1]"/>
                            </marc:subfield>
                            <marc:subfield code="e">creator</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <xsl:if test="//origination/corpname">

                        <xsl:variable name="tmp110"
                                      select="normalize-space(substring-before(//origination/corpname[1], '. '))"/>
                        <xsl:variable name="tmp111"
                                      select="normalize-space(substring-after(//origination/corpname[1], '. '))"/>
                        <xsl:choose>
                            <xsl:when test="$tmp111">
                                <marc:datafield tag="110" ind1="2" ind2=" ">
                                    <marc:subfield code="a">
                                        <xsl:value-of select="$tmp110"/>
                                    </marc:subfield>
                                    <marc:subfield code="b">
                                        <xsl:value-of select="$tmp111"/>
                                    </marc:subfield>
                                    <marc:subfield code="e">creator</marc:subfield>
                                </marc:datafield>
                            </xsl:when>
                            <xsl:otherwise>
                                <marc:datafield tag="110" ind1="2" ind2=" ">
                                    <marc:subfield code="a">
                                        <xsl:value-of select="$tmp110"/>
                                    </marc:subfield>
                                    <marc:subfield code="e">creator</marc:subfield>
                                </marc:datafield>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:if>
                    <xsl:if test="//origination/name">
                        <marc:datafield tag="111" ind1="2" ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of select="//origination/name[1]"/>
                            </marc:subfield>
                            <marc:subfield code="e">creator</marc:subfield>
                        </marc:datafield>
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
                        <xsl:variable name="href" select="//accessrestrict/p[2]/extref/@href"/>
                        <xsl:if test="$href">
                            <marc:subfield code="c">
                                <xsl:value-of select="$href"/>
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
                        <xsl:variable name="geocode" select="normalize-space(.)"/>
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'651'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value">
                                <xsl:choose>
                                    <xsl:when test="$geocode='ao'">ao</xsl:when>
                                    <xsl:when test="$geocode='ar'">ag</xsl:when>
                                    <xsl:when test="$geocode='am'">ai</xsl:when>
                                    <xsl:when test="$geocode='au'">au</xsl:when>
                                    <xsl:when test="$geocode='at'">at</xsl:when>
                                    <xsl:when test="$geocode='az'">aj</xsl:when>
                                    <xsl:when test="$geocode='bd'">bg</xsl:when>
                                    <xsl:when test="$geocode='be'">be</xsl:when>
                                    <xsl:when test="$geocode='bo'">bo</xsl:when>
                                    <xsl:when test="$geocode='br'">bl</xsl:when>
                                    <xsl:when test="$geocode='bg'">bu</xsl:when>
                                    <xsl:when test="$geocode='kh'">cb</xsl:when>
                                    <xsl:when test="$geocode='cm'">cm</xsl:when>
                                    <xsl:when test="$geocode='cl'">cl</xsl:when>
                                    <xsl:when test="$geocode='cn'">ch</xsl:when>
                                    <xsl:when test="$geocode='hr'">ci</xsl:when>
                                    <xsl:when test="$geocode='cu'">cu</xsl:when>
                                    <xsl:when test="$geocode='cz'">xr</xsl:when>
                                    <xsl:when test="$geocode='cs'">cs</xsl:when>
                                    <xsl:when test="$geocode='cshh'">cs</xsl:when>
                                    <xsl:when test="$geocode='dk'">dk</xsl:when>
                                    <xsl:when test="$geocode='eg'">ua</xsl:when>
                                    <xsl:when test="$geocode='sv'">es</xsl:when>
                                    <xsl:when test="$geocode='fr'">fr</xsl:when>
                                    <xsl:when test="$geocode='ge'">gs</xsl:when>
                                    <xsl:when test="$geocode='de'">gw</xsl:when>
                                    <xsl:when test="$geocode='gr'">gr</xsl:when>
                                    <xsl:when test="$geocode='gd'">gd</xsl:when>
                                    <xsl:when test="$geocode='gt'">gt</xsl:when>
                                    <xsl:when test="$geocode='hk'">hk</xsl:when>
                                    <xsl:when test="$geocode='hu'">hu</xsl:when>
                                    <xsl:when test="$geocode='in'">ii</xsl:when>
                                    <xsl:when test="$geocode='id'">io</xsl:when>
                                    <xsl:when test="$geocode='ia'">vp</xsl:when>
                                    <xsl:when test="$geocode='ir'">ir</xsl:when>
                                    <xsl:when test="$geocode='iq'">iq</xsl:when>
                                    <xsl:when test="$geocode='ie'">ie</xsl:when>
                                    <xsl:when test="$geocode='il'">is</xsl:when>
                                    <xsl:when test="$geocode='it'">it</xsl:when>
                                    <xsl:when test="$geocode='lv'">lv</xsl:when>
                                    <xsl:when test="$geocode='lb'">le</xsl:when>
                                    <xsl:when test="$geocode='mk'">xn</xsl:when>
                                    <xsl:when test="$geocode='my'">my</xsl:when>
                                    <xsl:when test="$geocode='mx'">mx</xsl:when>
                                    <xsl:when test="$geocode='bu'">br</xsl:when>
                                    <xsl:when test="$geocode='mm'">br</xsl:when>
                                    <xsl:when test="$geocode='na'">sx</xsl:when>
                                    <xsl:when test="$geocode='nl'">ne</xsl:when>
                                    <xsl:when test="$geocode='ni'">nq</xsl:when>
                                    <xsl:when test="$geocode='ne'">ng</xsl:when>
                                    <xsl:when test="$geocode='ng'">nr</xsl:when>
                                    <xsl:when test="$geocode='pk'">pk</xsl:when>
                                    <xsl:when test="$geocode='py'">py</xsl:when>
                                    <xsl:when test="$geocode='pe'">pe</xsl:when>
                                    <xsl:when test="$geocode='ph'">ph</xsl:when>
                                    <xsl:when test="$geocode='pl'">pl</xsl:when>
                                    <xsl:when test="$geocode='pt'">po</xsl:when>
                                    <xsl:when test="$geocode='pr'">pr</xsl:when>
                                    <xsl:when test="$geocode='ro'">ru</xsl:when>
                                    <xsl:when test="$geocode='ru'">ru</xsl:when>
                                    <xsl:when test="$geocode='sa'">su</xsl:when>
                                    <xsl:when test="$geocode='si'">xv</xsl:when>
                                    <xsl:when test="$geocode='za'">sa</xsl:when>
                                    <xsl:when test="$geocode='su'">xxr</xsl:when>
                                    <xsl:when test="$geocode='suhh'">xxr</xsl:when>
                                    <xsl:when test="$geocode='es'">sp</xsl:when>
                                    <xsl:when test="$geocode='lk'">ce</xsl:when>
                                    <xsl:when test="$geocode='sd'">sj</xsl:when>
                                    <xsl:when test="$geocode='sr'">sr</xsl:when>
                                    <xsl:when test="$geocode='se'">sw</xsl:when>
                                    <xsl:when test="$geocode='ch'">sz</xsl:when>
                                    <xsl:when test="$geocode='th'">th</xsl:when>
                                    <xsl:when test="$geocode='tr'">tu</xsl:when>
                                    <xsl:when test="$geocode='uk'">xxk</xsl:when>
                                    <xsl:when test="$geocode='us'">xxu</xsl:when>
                                    <xsl:when test="$geocode='vn'">vm</xsl:when>
                                    <xsl:when test="$geocode='yu'">yu</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$geocode"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>

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