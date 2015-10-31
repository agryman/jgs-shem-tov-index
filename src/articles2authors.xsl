<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles by author and hyperlinks them to the documents. Arthur Ryman, 2011-09-05 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:articles="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="articles">

	<xsl:import href="articles-common.xsl" />

	<xsl:output method="html" />

	<xsl:key use="articles:fullName" name="authors-by-fullname"
		match="articles:author" />
	<xsl:key use="substring(.,1,1)" name="surnames-by-initial"
		match="articles:surname" />

	<xsl:template match="/">
		<html lang="en">

			<xsl:call-template name="head">
				<xsl:with-param name="title">
					<xsl:text>Jewish Genealogical Society of Canada (Toronto) - Shem Tov - Author Index</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

			<body id="author-page">
				<xsl:call-template name="header" />

				<div class="main">
					<xsl:apply-templates select="articles:articles" />
				</div>

				<xsl:call-template name="footer" />
			</body>
		</html>
	</xsl:template>

	<!-- write all authors and their articles -->
	<xsl:template match="articles:articles">

		<h1>Toronto Shem Tov - Author Index</h1>

		<!-- Write navigation links to each author -->
		<table class="toc">
			<tbody>
				<xsl:for-each
					select="//articles:surname[generate-id(.)=generate-id(key('surnames-by-initial',substring(.,1,1))[1])]">
					<xsl:sort select="substring(.,1,1)" />

					<xsl:variable name="surname-initial" select="substring(.,1,1)" />
					<tr>
						<th>
							<a href="#{$surname-initial}">
								<xsl:value-of select="$surname-initial" />
							</a>
						</th>
						<td>
							<ul>
								<xsl:for-each
									select="//articles:author[substring(articles:surname,1,1)=$surname-initial][generate-id(.)=generate-id(key('authors-by-fullname',articles:fullName)[1])]">
									<xsl:sort select="articles:surname" data-type="text" />
									<xsl:sort select="articles:firstName" data-type="text" />

									<li>
										<a href="#{articles:fullName}">
											<xsl:value-of select="articles:fullName" />
										</a>
									</li>
								</xsl:for-each>
							</ul>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>

		<!-- write a heading for each surname initial -->

		<xsl:for-each
			select="//articles:surname[generate-id(.)=generate-id(key('surnames-by-initial',substring(.,1,1))[1])]">
			<xsl:sort select="substring(.,1,1)" />

			<xsl:variable name="surname-initial" select="substring(.,1,1)" />

			<h2 id="{$surname-initial}">
				<xsl:value-of select="$surname-initial" />
			</h2>

			<xsl:for-each
				select="//articles:author[substring(articles:surname,1,1)=$surname-initial][generate-id(.)=generate-id(key('authors-by-fullname',articles:fullName)[1])]">
				<xsl:sort select="articles:surname" data-type="text" />
				<xsl:sort select="articles:firstName" data-type="text" />

				<!-- write a section for each author -->
				<xsl:variable name="fullName" select="articles:fullName" />
				<h3 id="{$fullName}">
					<xsl:value-of select="$fullName" />
				</h3>

				<!-- write the documents for this author sorted by date and page -->
				<xsl:for-each
					select="//articles:article[articles:author/articles:fullName=$fullName]">
					<xsl:sort select="articles:year" data-type="number" />
					<xsl:sort select="articles:month" data-type="number" />
					<xsl:sort select="articles:page" data-type="number" />
					<xsl:apply-templates select="." />
				</xsl:for-each>

			</xsl:for-each>
		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>