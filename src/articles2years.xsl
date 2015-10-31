<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles and hyperlinks them to the documents. Arthur Ryman, 2011-09-04 -->

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
					<xsl:text>Jewish Genealogical Society of Canada (Toronto) - Shem Tov - Year Index</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

			<body id="year-page">
				<xsl:call-template name="header" />

				<div class="main">
					<xsl:apply-templates select="articles:articles" />
				</div>

				<xsl:call-template name="footer" />
			</body>
		</html>
	</xsl:template>

	<!-- write all articles in chronological order -->
	<xsl:template match="articles:articles">

		<h1>Toronto Shem Tov - Year Index</h1>

		<!-- Write navigation links to each year -->
		<table class="toc">
			<tbody>
				<xsl:for-each
					select="//articles:year[generate-id(.)=generate-id(key('years',.)[1])]">
					<xsl:sort select="." data-type="number" />

					<xsl:variable name="year" select="." />
					<xsl:variable name="volume" select="../articles:volume" />
					<tr>
						<th>
							<a href="#{format-number($year,'0000')}">
								<xsl:value-of select="$year" />
								<xsl:text>, Vol. </xsl:text>
								<xsl:value-of select="$volume" />
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
											<xsl:call-template name="month-no">
												<xsl:with-param name="article" select="." />
											</xsl:call-template>
										</a>
									</li>
								</xsl:for-each>
							</ul>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>

		<xsl:for-each
			select="//articles:year[generate-id(.)=generate-id(key('years',.)[1])]">
			<xsl:sort select="." data-type="number" />
			<xsl:variable name="year" select="." />
			<xsl:variable name="volume" select="../articles:volume" />

			<h2 id="{format-number($year,'0000')}">
				<xsl:value-of select="$year" />
				<xsl:text>, Vol. </xsl:text>
				<xsl:value-of select="$volume" />
			</h2>

			<!-- Write the documents for this year sorted by month -->
			<xsl:for-each
				select="//articles:article[articles:year=$year and generate-id(.)=generate-id(key('articles-by-document',articles:document)[1])]">
				<xsl:sort select="articles:month" data-type="number" />
				<xsl:variable name="document" select="articles:document" />
				<h3 id="{articles:yyyy-mm}">
					<a href="{articles:document}">
						<xsl:call-template name="month-year-vol-no">
							<xsl:with-param name="article" select="." />
						</xsl:call-template>
					</a>
				</h3>

				<!-- Write the articles in this document sorted by page number -->
				<xsl:for-each select="//articles:article[articles:document=$document]">
					<xsl:sort select="articles:page" data-type="number" />
					<xsl:apply-templates select="." />
				</xsl:for-each>
			</xsl:for-each>

		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>