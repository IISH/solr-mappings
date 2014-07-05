<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/" xmlns:xls="http://www.w3.org/1999/XSL/Transform"
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
                    <xsl:call-template name="collectionGeheugenAndNonEuropeanMovement">
                        <xsl:with-param name="material" select="substring(marc:leader, 7, 2)"/>
                    </xsl:call-template>
                    <!-- See API-19  and API-22-->
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
                        <xsl:choose>
                            <xsl:when test="marc:datafield[@tag='903']">
                                <xsl:value-of select="marc:datafield[@tag='903']/marc:subfield[@code='a']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="insertDateModified">
                                    <xsl:with-param name="cfDate" select="$date_modified"/>
                                    <xsl:with-param name="fsDate" select="$date_modified"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </iisg:date_modified>

                </iisg:iisg>
            </extraRecordData>

            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">
                    <xsl:copy-of select="marc:leader"/>
                    <xsl:copy-of select="marc:controlfield"/>
                   <xsl:apply-templates select="marc:datafield"/>
                </marc:record>
            </recordData>
        </record>

    </xsl:template>

    <xsl:template match="marc:datafield">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='903']"/>

    <xsl:template name="non-digital">
        <xsl:param name="material"/>
        <xsl:if test="not(//marc:datafield[@tag='856']/marc:subfield[@code='u']) and //marc:datafield[@tag='852']/marc:subfield[@code='c' and text()='IISG']">
            <iisg:collectionName>nondig</iisg:collectionName>

            <xsl:choose>
                <!-- Serials -->
                <xsl:when test="contains('ar, as, ps', $material)">
                    <iisg:collectionName>nondig.serials</iisg:collectionName>
                </xsl:when>
                <!-- Books and brochures -->
                <xsl:when test="contains('am, pm', $material)">
                    <iisg:collectionName>nondig.books_and_brochures</iisg:collectionName>
                </xsl:when>
                <!-- Music and sound -->
                <xsl:when test="contains('im, pi, ic, jm', $material)">
                    <iisg:collectionName>nondig.music_and_sound</iisg:collectionName>
                </xsl:when>
                <!-- Documentation -->
                <xsl:when test="contains('do, oc', $material)">
                    <iisg:collectionName>nondig.documentation</iisg:collectionName>
                </xsl:when>
                <!-- Archives -->
                <xsl:when test="contains('bm, pc', $material)">
                    <iisg:collectionName>nondig.archives</iisg:collectionName>
                </xsl:when>
                <!-- Visual documents -->
                <xsl:when test="contains('av, rm, gm, pv, km, kc',$material)">
                    <iisg:collectionName>nondig.visual_documents</iisg:collectionName>
                </xsl:when>
                <!-- Other -->
                <xsl:otherwise>
                    <iisg:collectionName>nondig.other</iisg:collectionName>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:if>
    </xsl:template>

    <xsl:template name="collectionGeheugenAndNonEuropeanMovement">
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
                <xsl:if test="//marc:datafield[@tag='852']/marc:subfield[@code='c' and text()='IISG']">
                    <xsl:if test="not(//marc:datafield[@tag='985']/marc:subfield[@code='a' and starts-with(text(), 'Geheugen')])">
                        <xls:choose>
                            <xsl:when test="//marc:datafield[@tag='651'] and //marc:datafield[@tag='651']/marc:subfield[@code='a' and (
                                contains(normalize-space(text()),'Albania')
                                or contains(normalize-space(text()),'Austria')
                                or contains(normalize-space(text()),'Belgium')
                                or contains(normalize-space(text()),'Bulgaria')
                                or contains(normalize-space(text()),'Cyprus')
                                or contains(normalize-space(text()),'Czechoslovakia')
                                or contains(normalize-space(text()),'Finland')
                                or contains(normalize-space(text()),'France')
                                or contains(normalize-space(text()),'Germany')
                                or contains(normalize-space(text()),'Greece')
                                or contains(normalize-space(text()),'Hungary')
                                or contains(normalize-space(text()),'Ireland')
                                or contains(normalize-space(text()),'Italy')
                                or contains(normalize-space(text()),'Luxembourg')
                                or contains(normalize-space(text()),'Malta')
                                or contains(normalize-space(text()),'Netherlands')
                                or contains(normalize-space(text()),'Poland')
                                or contains(normalize-space(text()),'Portugal')
                                or contains(normalize-space(text()),'Romania')
                                or contains(normalize-space(text()),'Spain')
                                or contains(normalize-space(text()),'Switzerland')
                                or contains(normalize-space(text()),'Turkey')
                                or contains(normalize-space(text()),'United Kingdom')
                                or contains(normalize-space(text()),'Russia')
                                or contains(normalize-space(text()),'Yugoslavia'))]">
                                <iisg:collectionName>VIS-EuropeanSocialMovements</iisg:collectionName>
                            </xsl:when>
                            <xsl:otherwise>
                                <iisg:collectionName>VIS-NonEuropeanMovement</iisg:collectionName>
                            </xsl:otherwise>
                        </xls:choose>
                    </xsl:if>
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
