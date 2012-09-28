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
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'651'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value">
                                <xsl:choose>
                                    <xsl:when test="text()='ao'">ao</xsl:when>
                                    <xsl:when test="text()='ar'">ag</xsl:when>
                                    <xsl:when test="text()='am'">ai</xsl:when>
                                    <xsl:when test="text()='au'">au</xsl:when>
                                    <xsl:when test="text()='at'">at</xsl:when>
                                    <xsl:when test="text()='az'">aj</xsl:when>
                                    <xsl:when test="text()='bd'">bg</xsl:when>
                                    <xsl:when test="text()='be'">be</xsl:when>
                                    <xsl:when test="text()='bo'">bo</xsl:when>
                                    <xsl:when test="text()='br'">bl</xsl:when>
                                    <xsl:when test="text()='bg'">bu</xsl:when>
                                    <xsl:when test="text()='kh'">cb</xsl:when>
                                    <xsl:when test="text()='cm'">cm</xsl:when>
                                    <xsl:when test="text()='cl'">cl</xsl:when>
                                    <xsl:when test="text()='cn'">ch</xsl:when>
                                    <xsl:when test="text()='hr'">ci</xsl:when>
                                    <xsl:when test="text()='cu'">cu</xsl:when>
                                    <xsl:when test="text()='cz'">xr</xsl:when>
                                    <xsl:when test="text()='cs'">cs</xsl:when>
                                    <xsl:when test="text()='cshh'">cs</xsl:when>
                                    <xsl:when test="text()='dk'">dk</xsl:when>
                                    <xsl:when test="text()='eg'">ua</xsl:when>
                                    <xsl:when test="text()='sv'">es</xsl:when>
                                    <xsl:when test="text()='fr'">fr</xsl:when>
                                    <xsl:when test="text()='ge'">gs</xsl:when>
                                    <xsl:when test="text()='de'">gw</xsl:when>
                                    <xsl:when test="text()='gr'">gr</xsl:when>
                                    <xsl:when test="text()='gd'">gd</xsl:when>
                                    <xsl:when test="text()='gt'">gt</xsl:when>
                                    <xsl:when test="text()='hk'">hk</xsl:when>
                                    <xsl:when test="text()='hu'">hu</xsl:when>
                                    <xsl:when test="text()='in'">ii</xsl:when>
                                    <xsl:when test="text()='id'">io</xsl:when>
                                    <xsl:when test="text()='ia'">vp</xsl:when>
                                    <xsl:when test="text()='ir'">ir</xsl:when>
                                    <xsl:when test="text()='iq'">iq</xsl:when>
                                    <xsl:when test="text()='ie'">ie</xsl:when>
                                    <xsl:when test="text()='il'">is</xsl:when>
                                    <xsl:when test="text()='it'">it</xsl:when>
                                    <xsl:when test="text()='lv'">lv</xsl:when>
                                    <xsl:when test="text()='lb'">le</xsl:when>
                                    <xsl:when test="text()='mk'">xn</xsl:when>
                                    <xsl:when test="text()='my'">my</xsl:when>
                                    <xsl:when test="text()='mx'">mx</xsl:when>
                                    <xsl:when test="text()='bu'">br</xsl:when>
                                    <xsl:when test="text()='mm'">br</xsl:when>
                                    <xsl:when test="text()='na'">sx</xsl:when>
                                    <xsl:when test="text()='nl'">ne</xsl:when>
                                    <xsl:when test="text()='ni'">nq</xsl:when>
                                    <xsl:when test="text()='ne'">ng</xsl:when>
                                    <xsl:when test="text()='ng'">nr</xsl:when>
                                    <xsl:when test="text()='pk'">pk</xsl:when>
                                    <xsl:when test="text()='py'">py</xsl:when>
                                    <xsl:when test="text()='pe'">pe</xsl:when>
                                    <xsl:when test="text()='ph'">ph</xsl:when>
                                    <xsl:when test="text()='pl'">pl</xsl:when>
                                    <xsl:when test="text()='pt'">po</xsl:when>
                                    <xsl:when test="text()='pr'">pr</xsl:when>
                                    <xsl:when test="text()='ro'">ru</xsl:when>
                                    <xsl:when test="text()='ru'">ru</xsl:when>
                                    <xsl:when test="text()='sa'">su</xsl:when>
                                    <xsl:when test="text()='si'">xv</xsl:when>
                                    <xsl:when test="text()='za'">sa</xsl:when>
                                    <xsl:when test="text()='su'">xxr</xsl:when>
                                    <xsl:when test="text()='suhh'">xxr</xsl:when>
                                    <xsl:when test="text()='es'">sp</xsl:when>
                                    <xsl:when test="text()='lk'">ce</xsl:when>
                                    <xsl:when test="text()='sd'">sj</xsl:when>
                                    <xsl:when test="text()='sr'">sr</xsl:when>
                                    <xsl:when test="text()='se'">sw</xsl:when>
                                    <xsl:when test="text()='ch'">sz</xsl:when>
                                    <xsl:when test="text()='th'">th</xsl:when>
                                    <xsl:when test="text()='tr'">tu</xsl:when>
                                    <xsl:when test="text()='uk'">xxk</xsl:when>
                                    <xsl:when test="text()='us'">xxu</xsl:when>
                                    <xsl:when test="text()='vn'">vm</xsl:when>
                                    <xsl:when test="text()='yu'">yu</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="text()"/>
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