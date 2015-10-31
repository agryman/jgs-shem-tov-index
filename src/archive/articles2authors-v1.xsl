<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles by author and hyperlinks them to the documents. Arthur Ryman, 2011-09-05 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:articles="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="articles">

	<xsl:import href="articles-common.xsl" />

	<xsl:output method="html" />

	<xsl:key use="articles:year" name="years" match="articles:article" />
	<xsl:key use="articles:document" name="documents" match="articles:article" />
	<xsl:key use="articles:fullName" name="authors" match="articles:author" />
	<xsl:key use="." name="subjects" match="articles:subject" />
	<xsl:key use="substring(.,1,1)" name="surname-initials" match="articles:surname" />

	<xsl:template match="/">
		<html lang="en">

			<xsl:call-template name="head">
				<xsl:with-param name="title">
					<xsl:text>Jewish Genealogical Society of Canada (Toronto) - Shem Tov Author Index</xsl:text>
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

	<!-- write all articles in chronological order -->
	<xsl:template match="articles:articles">

		<h1>
			Toronto Shem Tov Articles -
			<a href="years.html">Year Index</a>
			| Author Index |
			<a href="subjects.html">Subject Index</a>
		</h1>

		<!-- Write navigation links to each author -->
		<div>
			<xsl:for-each
				select="//articles:author[generate-id(.)=generate-id(key('authors',articles:fullName)[1])]">
				<xsl:sort select="articles:surname" data-type="text" />
				<xsl:sort select="articles:firstName" data-type="text" />

				<xsl:if test="position()!=1">
					<xsl:text> | </xsl:text>
				</xsl:if>

				<a href="#{articles:fullName}">
					<xsl:value-of select="articles:fullName" />
				</a>
			</xsl:for-each>
		</div>

		<!-- write a section for each author -->

		<xsl:for-each
			select="//articles:author[generate-id(.)=generate-id(key('authors',articles:fullName)[1])]">
			<xsl:sort select="articles:surname" data-type="text" />
			<xsl:sort select="articles:firstName" data-type="text" />

			<xsl:variable name="fullName" select="articles:fullName" />
			<h3>
				<a name="{$fullName}">
					<xsl:value-of select="$fullName" />
				</a>
			</h3>

			<!-- Write the documents for this author sorted by date and page -->
			<xsl:for-each
				select="//articles:article[articles:author/articles:fullName=$fullName]">
				<xsl:sort select="articles:year" data-type="number" />
				<xsl:sort select="articles:month" data-type="number" />
				<xsl:sort select="articles:page" data-type="number" />
				<xsl:apply-templates select="." />
			</xsl:for-each>

		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>