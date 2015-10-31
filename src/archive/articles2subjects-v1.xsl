<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles by subject and hyperlinks them to the documents. Arthur Ryman, 2011-09-05 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:articles="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="articles">

	<xsl:import href="articles-common.xsl" />

	<xsl:output method="html" />

	<xsl:key use="articles:year" name="years" match="articles:article" />
	<xsl:key use="articles:document" name="documents" match="articles:article" />
	<xsl:key use="articles:fullName" name="authors" match="articles:author" />
	<xsl:key use="." name="subjects" match="articles:subject" />

	<xsl:template match="/">
		<html lang="en">

			<xsl:call-template name="head">
				<xsl:with-param name="title">
					<xsl:text>Jewish Genealogical Society of Canada (Toronto) - Shem Tov Subject Index</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

			<body>
				<xsl:call-template name="header" />

				<div style="width:780px; margin:0 auto; text-align: left;">
					<xsl:apply-templates select="articles:articles" />
				</div>

				<xsl:call-template name="footer" />
			</body>
		</html>
	</xsl:template>

	<!-- write all articles in subject order -->
	<xsl:template match="articles:articles">

		<h1>Toronto Shem Tov Articles - <a href="years.html">Year Index</a> | <a href="authors.html">Author Index</a> | Subject Index</h1>

		<!-- Write navigation links to each subject -->
		<div>
			<xsl:for-each
				select="//articles:subject[generate-id(.)=generate-id(key('subjects',.)[1])]">
				<xsl:sort select="." data-type="text" />

				<xsl:if test="position()!=1">
					<xsl:text> | </xsl:text>
				</xsl:if>

				<a href="#{.}">
					<xsl:value-of select="." />
				</a>
			</xsl:for-each>
		</div>

		<!-- write a section for each subject -->

		<xsl:for-each
			select="//articles:subject[generate-id(.)=generate-id(key('subjects',.)[1])]">
			<xsl:sort select="." data-type="text" />

			<xsl:variable name="subject" select="." />
			<h3>
				<a name="{$subject}">
					<xsl:value-of select="$subject" />
				</a>
			</h3>

			<!-- Write the documents for this subject sorted by date and page -->
			<xsl:for-each select="//articles:article[articles:subject=$subject]">
				<xsl:sort select="articles:year" data-type="number" />
				<xsl:sort select="articles:month" data-type="number" />
				<xsl:sort select="articles:page" data-type="number" />
				<xsl:apply-templates select="." />
			</xsl:for-each>

		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>