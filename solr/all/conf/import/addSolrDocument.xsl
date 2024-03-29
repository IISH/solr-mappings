<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="marc">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="resource"/>

    <xsl:template match="doc">
        <add>
            <doc>
                <xsl:copy-of select="field"/>
                <field name="resource">
                    <xsl:value-of select="$resource"/>
                </field>
            </doc>
        </add>
    </xsl:template>

</xsl:stylesheet>