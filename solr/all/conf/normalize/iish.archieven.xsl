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

            <xsl:variable name="geognames" select="tokenize(//controlaccess/geogname[1], ',')"/>
            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">

                    <xsl:variable name="language">
                        <xsl:choose>
                            <xsl:when test="//langmaterial[1] = 'Nederlands'">dut</xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="//langmaterial[1] = 'dut'">dut</xsl:when>
                                    <xsl:otherwise>eng</xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <marc:leader>00742nbm a22001930a 45 0</marc:leader>

                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>

                    <xsl:variable name="lm" select="tokenize(//langmaterial[1], ',')"/>

                    <marc:controlfield tag="008">
                        <xsl:variable name="tmp" select="normalize-space($geognames[1])"/>
                        <xsl:variable name="geocode">
                            <xsl:choose>
                                <xsl:when test="$tmp='ao'">ao</xsl:when>
                                <xsl:when test="$tmp='ar'">ag</xsl:when>
                                <xsl:when test="$tmp='am'">ai</xsl:when>
                                <xsl:when test="$tmp='au'">au</xsl:when>
                                <xsl:when test="$tmp='at'">at</xsl:when>
                                <xsl:when test="$tmp='az'">aj</xsl:when>
                                <xsl:when test="$tmp='bd'">bg</xsl:when>
                                <xsl:when test="$tmp='be'">be</xsl:when>
                                <xsl:when test="$tmp='bo'">bo</xsl:when>
                                <xsl:when test="$tmp='br'">bl</xsl:when>
                                <xsl:when test="$tmp='bg'">bu</xsl:when>
                                <xsl:when test="$tmp='kh'">cb</xsl:when>
                                <xsl:when test="$tmp='cm'">cm</xsl:when>
                                <xsl:when test="$tmp='cl'">cl</xsl:when>
                                <xsl:when test="$tmp='cn'">ch</xsl:when>
                                <xsl:when test="$tmp='hr'">ci</xsl:when>
                                <xsl:when test="$tmp='cu'">cu</xsl:when>
                                <xsl:when test="$tmp='cz'">xr</xsl:when>
                                <xsl:when test="$tmp='cs'">cs</xsl:when>
                                <xsl:when test="$tmp='cshh'">cs</xsl:when>
                                <xsl:when test="$tmp='dk'">dk</xsl:when>
                                <xsl:when test="$tmp='eg'">ua</xsl:when>
                                <xsl:when test="$tmp='sv'">es</xsl:when>
                                <xsl:when test="$tmp='fr'">fr</xsl:when>
                                <xsl:when test="$tmp='ge'">gs</xsl:when>
                                <xsl:when test="$tmp='de'">gw</xsl:when>
                                <xsl:when test="$tmp='gr'">gr</xsl:when>
                                <xsl:when test="$tmp='gd'">gd</xsl:when>
                                <xsl:when test="$tmp='gt'">gt</xsl:when>
                                <xsl:when test="$tmp='hk'">hk</xsl:when>
                                <xsl:when test="$tmp='hu'">hu</xsl:when>
                                <xsl:when test="$tmp='in'">ii</xsl:when>
                                <xsl:when test="$tmp='id'">io</xsl:when>
                                <xsl:when test="$tmp='ia'">vp</xsl:when>
                                <xsl:when test="$tmp='ir'">ir</xsl:when>
                                <xsl:when test="$tmp='iq'">iq</xsl:when>
                                <xsl:when test="$tmp='ie'">ie</xsl:when>
                                <xsl:when test="$tmp='il'">is</xsl:when>
                                <xsl:when test="$tmp='it'">it</xsl:when>
                                <xsl:when test="$tmp='lv'">lv</xsl:when>
                                <xsl:when test="$tmp='lb'">le</xsl:when>
                                <xsl:when test="$tmp='mk'">xn</xsl:when>
                                <xsl:when test="$tmp='my'">my</xsl:when>
                                <xsl:when test="$tmp='mx'">mx</xsl:when>
                                <xsl:when test="$tmp='bu'">br</xsl:when>
                                <xsl:when test="$tmp='mm'">br</xsl:when>
                                <xsl:when test="$tmp='na'">sx</xsl:when>
                                <xsl:when test="$tmp='nl'">ne</xsl:when>
                                <xsl:when test="$tmp='ni'">nq</xsl:when>
                                <xsl:when test="$tmp='ne'">ng</xsl:when>
                                <xsl:when test="$tmp='ng'">nr</xsl:when>
                                <xsl:when test="$tmp='pk'">pk</xsl:when>
                                <xsl:when test="$tmp='py'">py</xsl:when>
                                <xsl:when test="$tmp='pe'">pe</xsl:when>
                                <xsl:when test="$tmp='ph'">ph</xsl:when>
                                <xsl:when test="$tmp='pl'">pl</xsl:when>
                                <xsl:when test="$tmp='pt'">po</xsl:when>
                                <xsl:when test="$tmp='pr'">pr</xsl:when>
                                <xsl:when test="$tmp='ro'">ru</xsl:when>
                                <xsl:when test="$tmp='ru'">ru</xsl:when>
                                <xsl:when test="$tmp='sa'">su</xsl:when>
                                <xsl:when test="$tmp='si'">xv</xsl:when>
                                <xsl:when test="$tmp='za'">sa</xsl:when>
                                <xsl:when test="$tmp='su'">xxr</xsl:when>
                                <xsl:when test="$tmp='suhh'">xxr</xsl:when>
                                <xsl:when test="$tmp='es'">sp</xsl:when>
                                <xsl:when test="$tmp='lk'">ce</xsl:when>
                                <xsl:when test="$tmp='sd'">sj</xsl:when>
                                <xsl:when test="$tmp='sr'">sr</xsl:when>
                                <xsl:when test="$tmp='se'">sw</xsl:when>
                                <xsl:when test="$tmp='ch'">sz</xsl:when>
                                <xsl:when test="$tmp='th'">th</xsl:when>
                                <xsl:when test="$tmp='tr'">tu</xsl:when>
                                <xsl:when test="$tmp='uk'">xxk</xsl:when>
                                <xsl:when test="$tmp='us'">xxu</xsl:when>
                                <xsl:when test="$tmp='vn'">vm</xsl:when>
                                <xsl:when test="$tmp='yu'">yu</xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$tmp"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of
                                select="concat('199507suuuuuuuu', substring(concat($geocode, '   '), 1, 3),'|||||||||||||||||',substring(concat($language[1], '   '), 1, 3),' d')"/>
                    </marc:controlfield>

                    <xsl:if test="count($lm)>0">
                        <marc:datafield tag="041">
                            <xsl:for-each select="$lm">
                                <marc:subfield code="a">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </marc:subfield>
                            </xsl:for-each>
                        </marc:datafield>
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

                        <xsl:variable name="tmp111"
                                      select="normalize-space(substring-after(//origination/corpname[1], '. '))"/>
                        <xsl:choose>
                            <xsl:when test="$tmp111">
                                <marc:datafield tag="110" ind1="2" ind2=" ">
                                    <marc:subfield code="a">
                                        <xsl:value-of
                                                select="normalize-space(substring-before(//origination/corpname[1], '. '))"/>
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
                                        <xsl:value-of select="normalize-space(//origination/corpname[1])"/>
                                    </marc:subfield>
                                    <marc:subfield code="e">creator</marc:subfield>
                                </marc:datafield>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:if>
                    <xsl:if test="//origination/name">
                        <marc:datafield tag="130" ind1="2" ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of select="//origination/name[1]"/>
                            </marc:subfield>
                            <marc:subfield code="k">Collection</marc:subfield>
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
                            <xsl:with-param name="value" select="normalize-space(.)"/>
                        </xsl:call-template>
                    </xsl:for-each>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//repository/corpname"/>
                    </xsl:call-template>

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
