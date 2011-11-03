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
                    <iisg:isShownAt>
                        <xsl:value-of select="concat('http://hdl.handle.net/', $identifier)"/>
                    </iisg:isShownAt>
                    <xsl:for-each select="marc:datafield[@tag='856']/marc:subfield[@code='u']">
                        <iisg:isShownBy>
                            <xsl:value-of select="text()"/>
                        </iisg:isShownBy>
                    </xsl:for-each>
                    <iisg:date_modified>
                        <xsl:value-of select="$date_modified"/>
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

</xsl:stylesheet>