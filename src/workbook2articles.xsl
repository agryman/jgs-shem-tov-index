<?xml version="1.0" encoding="UTF-8"?>
<!-- Transforms the Shem Tov Index Excel XML Workbook into a simpler XML 
	format as described by the schema issues.xsd. Change Log: 2011-09-04 Arthur 
	Ryman (arthur.ryman@gmail.com) Created. -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:tns="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="ss">

	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />

	<xsl:template match="/ss:Workbook">
		<tns:articles>
			<xsl:apply-templates select="ss:Worksheet" />
		</tns:articles>
	</xsl:template>

	<!-- Each row of the table contains the following fields: 1 Title, 2 Year, 
		3 Month, 4 Volume, 5 Issue, 6 Page, 7 Author1Surname, 8 Author1FirstName, 
		9 Author2Surname, 10 Author2FirstName, 11 Author3Surname, 12 Author3FirstName, 
		13 Subject1, 14 Subject2, 15 Subject3, 16 Subject4, 17 Subject5 -->

	<xsl:template match="ss:Worksheet">
		<xsl:for-each select="ss:Table/ss:Row">

			<xsl:variable name="title" select="normalize-space(ss:Cell[1]/ss:Data)" />

			<xsl:variable name="year" select="normalize-space(ss:Cell[2]/ss:Data)" />

			<xsl:variable name="month" select="normalize-space(ss:Cell[3]/ss:Data)" />

			<xsl:variable name="volume" select="normalize-space(ss:Cell[4]/ss:Data)" />

			<xsl:variable name="issue" select="normalize-space(ss:Cell[5]/ss:Data)" />

			<xsl:variable name="page" select="normalize-space(ss:Cell[6]/ss:Data)" />

			<xsl:variable name="surname1" select="normalize-space(ss:Cell[7]/ss:Data)" />

			<xsl:variable name="firstName1" select="normalize-space(ss:Cell[8]/ss:Data)" />

			<xsl:variable name="surname2" select="normalize-space(ss:Cell[9]/ss:Data)" />

			<xsl:variable name="firstName2" select="normalize-space(ss:Cell[10]/ss:Data)" />

			<xsl:variable name="surname3" select="normalize-space(ss:Cell[11]/ss:Data)" />

			<xsl:variable name="firstName3" select="normalize-space(ss:Cell[12]/ss:Data)" />

			<xsl:variable name="subject1" select="normalize-space(ss:Cell[13]/ss:Data)" />

			<xsl:variable name="subject2" select="normalize-space(ss:Cell[14]/ss:Data)" />

			<xsl:variable name="subject3" select="normalize-space(ss:Cell[15]/ss:Data)" />

			<xsl:variable name="subject4" select="normalize-space(ss:Cell[16]/ss:Data)" />

			<xsl:variable name="subject5" select="normalize-space(ss:Cell[17]/ss:Data)" />

			<xsl:if test="position()&gt;1">

				<tns:article>

					<xsl:call-template name="document">
						<xsl:with-param name="year" select="$year" />
						<xsl:with-param name="month" select="$month" />
					</xsl:call-template>

					<tns:title>
						<xsl:value-of select="$title" />
					</tns:title>

					<tns:year>
						<xsl:value-of select="floor($year)" />
					</tns:year>

					<tns:month>
						<xsl:value-of select="floor($month)" />
					</tns:month>

					<tns:yyyy-mm>
						<xsl:value-of
							select="concat(format-number($year,'0000'),'-',format-number($month,'00'))" />
					</tns:yyyy-mm>

					<tns:volume>
						<xsl:value-of select="$volume" />
					</tns:volume>

					<tns:issue>
						<xsl:value-of select="floor($issue)" />
					</tns:issue>

					<tns:page>
						<xsl:value-of select="floor($page)" />
					</tns:page>

					<xsl:call-template name="author">
						<xsl:with-param name="position" select="'1'" />
						<xsl:with-param name="surname" select="$surname1" />
						<xsl:with-param name="firstName" select="$firstName1" />
					</xsl:call-template>

					<xsl:call-template name="author">
						<xsl:with-param name="position" select="'2'" />
						<xsl:with-param name="surname" select="$surname2" />
						<xsl:with-param name="firstName" select="$firstName2" />
					</xsl:call-template>

					<xsl:call-template name="author">
						<xsl:with-param name="position" select="'3'" />
						<xsl:with-param name="surname" select="$surname3" />
						<xsl:with-param name="firstName" select="$firstName3" />
					</xsl:call-template>

					<xsl:call-template name="subject">
						<xsl:with-param name="position" select="'1'" />
						<xsl:with-param name="subject" select="$subject1" />
					</xsl:call-template>

					<xsl:call-template name="subject">
						<xsl:with-param name="position" select="'2'" />
						<xsl:with-param name="subject" select="$subject2" />
					</xsl:call-template>

					<xsl:call-template name="subject">
						<xsl:with-param name="position" select="'3'" />
						<xsl:with-param name="subject" select="$subject3" />
					</xsl:call-template>

					<xsl:call-template name="subject">
						<xsl:with-param name="position" select="'4'" />
						<xsl:with-param name="subject" select="$subject4" />
					</xsl:call-template>

					<xsl:call-template name="subject">
						<xsl:with-param name="position" select="'5'" />
						<xsl:with-param name="subject" select="$subject5" />
					</xsl:call-template>

				</tns:article>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- writes the link to the document, e.g. http://www.jgstoronto.ca/documents/Toronto-Shem-Tov-2000-03.pdf -->
	<xsl:template name="document">
		<xsl:param name="year" />
		<xsl:param name="month" />

		<!-- convert year to a 4-digit string -->
		<xsl:variable name="yyyy" select="format-number($year,'0000')" />

		<!-- convert month to a 2-digit string with zero padding -->
		<xsl:variable name="mm" select="format-number($month,'00')" />

		<!-- write the document link -->
		<!-- assume PDFs are in the same directory as the index files -->
		<tns:document>
			<xsl:value-of
			select="concat('Toronto-Shem-Tov-',$yyyy,'-',$mm,'.pdf')" />
		</tns:document>

	</xsl:template>

	<!-- writes the author -->
	<xsl:template name="author">
		<xsl:param name="position" />
		<xsl:param name="surname" />
		<xsl:param name="firstName" />
		<xsl:if test="$surname!='n/a' or $firstName!='n/a'">
			<tns:author position="{$position}">

				<!-- write the surname -->
				<xsl:if test="$surname!='n/a'">
					<tns:surname>
						<xsl:value-of select="$surname" />
					</tns:surname>
				</xsl:if>

				<!-- write the first name -->
				<xsl:if test="$firstName!='n/a'">
					<tns:firstName>
						<xsl:value-of select="$firstName" />
					</tns:firstName>
				</xsl:if>

				<!-- write the full name -->
				<tns:fullName>
					<xsl:choose>
						<xsl:when test="$surname='n/a'">
							<xsl:value-of select="$firstName" />
						</xsl:when>
						<xsl:when test="$firstName='n/a'">
							<xsl:value-of select="$surname" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($firstName,' ',$surname)" />
						</xsl:otherwise>
					</xsl:choose>
				</tns:fullName>

			</tns:author>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subject">
		<xsl:param name="position" />
		<xsl:param name="subject" />
		<xsl:if test="$subject!='n/a'">
			<tns:subject position="{$position}">
				<xsl:value-of select="$subject" />
			</tns:subject>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>