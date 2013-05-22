<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        exclude-result-prefixes="iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="marc:record">

        <xsl:variable name="identifier" select="marc:datafield[@tag='902']/marc:subfield[@code='a']"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <!-- Hope sets. See API-4 -->
                    <xsl:call-template name="collectionGeheugen">
                        <xsl:with-param name="material" select="substring(marc:leader, 7, 2)"/>
                    </xsl:call-template>
                    <xsl:call-template name="non-digital">
                        <xsl:with-param name="material" select="substring(marc:leader, 7, 2)"/>
                    </xsl:call-template>
                    <xsl:call-template name="collector"/>
                    <iisg:isShownAt>
                        <xsl:value-of select="concat('http://hdl.handle.net/', $identifier)"/>
                    </iisg:isShownAt>
                    <xsl:for-each select="marc:datafield[@tag='856']/marc:subfield[@code='u']">
                        <iisg:isShownBy>
                            <xsl:value-of select="text()"/>
                        </iisg:isShownBy>
                    </xsl:for-each>
                    <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="marc:controlfield[@tag='005']"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>

            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">
                    <xsl:copy-of select="marc:leader"/>
                    <xsl:copy-of select="marc:controlfield"/>
                    <xsl:copy-of select="marc:datafield"/>
                </marc:record>
            </recordData>
        </record>

    </xsl:template>

    <xsl:template name="non-digital">
        <xsl:param name="material"/>
        <xsl:if test="not(//marc:datafield[@tag='856']/marc:subfield[@code='u']) and //marc:datafield[@tag='852']/marc:subfield[@code='c' and text()='IISG']">
            <iisg:collectionName>nondig</iisg:collectionName>
            <xsl:choose>
                <xsl:when test="$material='am'">
                    <iisg:collectionName>nondig.books</iisg:collectionName>
                </xsl:when>
                <xsl:when
                        test="$material='ac' and //marc:datafield[@tag='245']/marc:subfield[@code='k' and text()='Book collection']">
                    <iisg:collectionName>nondig.books</iisg:collectionName>
                </xsl:when>
                <xsl:when test="$material='as'">
                    <iisg:collectionName>nondig.serials</iisg:collectionName>
                </xsl:when>
                <xsl:when
                        test="$material='ac' and //marc:datafield[@tag='245']/marc:subfield[@code='k' and text()='Serial collection']">
                    <iisg:collectionName>nondig.serials</iisg:collectionName>
                </xsl:when>
                <xsl:when test="$material='gm'">
                    <iisg:collectionName>nondig.video</iisg:collectionName>
                </xsl:when>
                <xsl:when test="contains(',im,jm,ic,jc,', $material)">
                    <iisg:collectionName>nondig.audio</iisg:collectionName>
                </xsl:when>
                <xsl:when test="contains(',km,kc,', $material)">
                    <iisg:collectionName>nondig.visual</iisg:collectionName>
                </xsl:when>
                <xsl:when test="contains(',rm,rc,', $material)">
                    <iisg:collectionName>nondig.objects</iisg:collectionName>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="collectionGeheugen">
        <xsl:param name="material"/>
        <xsl:if test="contains(',rm,gm,pv,km,kc,', $material)">
            <xsl:if test="//marc:datafield[@tag='852']/marc:subfield[@code='p' and starts-with( text(), '30051')]">
                <xsl:for-each
                        select="marc:datafield[@tag='985']/marc:subfield[@code='a' and starts-with(text(), 'Geheugen')]">
                    <xsl:variable name="setSpec">
                        <xsl:choose>
                            <xsl:when test="text()='Geheugen1'">VIS-DutchLabourMovements</xsl:when>
                            <xsl:when test="text()='Geheugen3'">VIS-AHP</xsl:when>
                            <xsl:when test="text()='Geheugen5'">VIS-ParadisoMelkweg</xsl:when>
                            <xsl:when test="text()='Geheugen6'">VIS-DutchPoliticalSocialMovements</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="text()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <iisg:collectionName>
                        <xsl:value-of select="$setSpec"/>
                    </iisg:collectionName>
                </xsl:for-each>
                <xsl:if test="not(//marc:datafield[@tag='985']/marc:subfield[@code='a' and starts-with(text(), 'Geheugen')])
                            and //marc:datafield[@tag='852']/marc:subfield[@code='c' and text()='IISG']
                            and //marc:datafield[@tag='651']/marc:subfield[@code='a' and (
                                contains(text(),'Albania')
                                or contains(text(),'Austria')
                                or contains(text(),'Belgium')
                                or contains(text(),'Bulgaria')
                                or contains(text(),'Cyprus')
                                or contains(text(),'Czechoslovakia')
                                or contains(text(),'Finland')
                                or contains(text(),'France')
                                or contains(text(),'Germany')
                                or contains(text(),'Greece')
                                or contains(text(),'Hungary')
                                or contains(text(),'Ireland')
                                or contains(text(),'Italy')
                                or contains(text(),'Luxembourg')
                                or contains(text(),'Malta')
                                or contains(text(),'Netherlands')
                                or contains(text(),'Poland')
                                or contains(text(),'Portugal')
                                or contains(text(),'Romania')
                                or contains(text(),'Spain')
                                or contains(text(),'Switzerland')
                                or contains(text(),'Turkey')
                                or contains(text(),'United Kingdom')
                                or contains(text(),'Russia')
                                or contains(text(),'Yugoslavia') )]">
                    <iisg:collectionName>VIS-EuropeanSocialMovements</iisg:collectionName>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="collector">
        <xsl:variable name="collection" select="marc:datafield[@tag='852'][1]/marc:subfield[@code='c']"/>
        <xsl:if test="$collection">
            <xsl:for-each
                    select="marc:datafield[@tag='700' and marc:subfield[@code='e' and starts-with( text(),'collector')]]/marc:subfield[@code='a']">
                <xsl:call-template name="insertCollection">
                    <xsl:with-param name="collection"
                                    select="normalize-space(concat($collection, '.', translate( text(), ' ,.()[]{}', '')))"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
