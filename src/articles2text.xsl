<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles as plain text. Arthur Ryman, 2011-09-11 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:articles="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="articles">

	<xsl:import href="articles-common.xsl" />

	<xsl:output method="html" />

	<xsl:key use="." name="years" match="articles:year" />
	<xsl:key use="articles:document" name="articles-by-document"
		match="articles:article" />

	<xsl:template match="/">
		<html lang="en">

			<xsl:call-template name="head">
				<xsl:with-param name="title">
					<xsl:text>Jewish Genealogical Society of Canada (Toronto) - Shem Tov - Year Index (Text Format)</xsl:text>
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
			Toronto Shem Tov - Year Index (Text Format)
		</h1>

		<!-- Write navigation links to each year -->
		<table class="toc">
			<xsl:for-each
				select="//articles:year[generate-id(.)=generate-id(key('years',.)[1])]">
				<xsl:sort select="." data-type="number" />
				<xsl:variable name="year" select="." />
				<tr>
					<th>
						<a href="#{format-number($year,'0000')}">
							<xsl:value-of select="$year" />
						</a>
					</th>
					<td>
						<ul>
							<xsl:for-each
								select="//articles:article[articles:year=$year and generate-id(.)=generate-id(key('articles-by-document',articles:document)[1])]">
								<xsl:sort select="articles:month" data-type="number" />
								<xsl:variable name="document" select="articles:document" />
								<li>
									<a href="#{articles:yyyy-mm}">
										<xsl:call-template name="month-vol-no">
											<xsl:with-param name="article" select="." />
										</xsl:call-template>
									</a>
								</li>

							</xsl:for-each>
						</ul>
					</td>
				</tr>
			</xsl:for-each>
		</table>

		<xsl:for-each
			select="//articles:year[generate-id(.)=generate-id(key('years',.)[1])]">
			<xsl:sort select="." data-type="number" />
			<xsl:variable name="year" select="." />

			<h2>
				<a name="{format-number($year,'0000')}">
					<xsl:value-of select="$year" />
				</a>
			</h2>

			<!-- Write the documents for this year sorted by month -->
			<xsl:for-each
				select="//articles:article[articles:year=$year and generate-id(.)=generate-id(key('articles-by-document',articles:document)[1])]">
				<xsl:sort select="articles:month" data-type="number" />
				<xsl:variable name="document" select="articles:document" />
				<h3>
					<a href="{articles:document}" name="{articles:yyyy-mm}">
						<xsl:call-template name="month-year-vol-no">
							<xsl:with-param name="article" select="." />
						</xsl:call-template>
					</a>
				</h3>

				<!-- Write the articles in this document sorted by page number -->
				<xsl:for-each select="//articles:article[articles:document=$document]">
					<xsl:sort select="articles:page" data-type="number" />
					<xsl:call-template name="article-text">
						<xsl:with-param name="article" select="."></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>

		</xsl:for-each>

	</xsl:template>

	<xsl:template name="article-text">
		<xsl:param name="article" />
		<div>
			<xsl:value-of select="articles:title" />
			<xsl:text>, p</xsl:text>
			<xsl:value-of select="articles:page" />
			<xsl:for-each select="articles:author/articles:fullName">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="." />
			</xsl:for-each>
			<xsl:for-each select="articles:subject">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="." />
			</xsl:for-each>
			<xsl:text>.</xsl:text>
		</div>
	</xsl:template>

</xsl:stylesheet>