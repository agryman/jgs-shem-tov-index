<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles by subject and hyperlinks them to the documents. Arthur Ryman, 2011-09-05 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:articles="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="articles">

	<xsl:import href="articles-common.xsl" />

	<xsl:output method="html" />

	<xsl:key use="." name="subjects" match="articles:subject" />
	<xsl:key use="substring(.,1,1)" name="subjects-by-initial"
		match="articles:subject" />

	<xsl:template match="/">
		<html lang="en">

			<xsl:call-template name="head">
				<xsl:with-param name="title">
					<xsl:text>Jewish Genealogical Society of Canada (Toronto) - Shem Tov - Subject Index</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

			<body id="subject-page">
				<xsl:call-template name="header" />

				<div class="main">
					<xsl:apply-templates select="articles:articles" />
				</div>

				<xsl:call-template name="footer" />
			</body>
		</html>
	</xsl:template>

	<!-- write all subject and their articles -->
	<xsl:template match="articles:articles">

		<h1>Toronto Shem Tov - Subject Index</h1>

		<!-- Write navigation links to each subject -->
		<table class="toc">
			<tbody>
				<xsl:for-each
					select="//articles:subject[generate-id(.)=generate-id(key('subjects-by-initial',substring(.,1,1))[1])]">
					<xsl:sort select="substring(.,1,1)" data-type="text" />

					<xsl:variable name="subject-initial" select="substring(.,1,1)" />
					<tr>
						<th>
							<a href="#{$subject-initial}">
								<xsl:value-of select="$subject-initial" />
							</a>
						</th>
						<td>
							<ul>
								<xsl:for-each
									select="//articles:subject[substring(.,1,1)=$subject-initial][generate-id(.)=generate-id(key('subjects',.)[1])]">
									<xsl:sort select="." data-type="text" />

									<li>
										<a href="#{.}">
											<xsl:value-of select="." />
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
			select="//articles:subject[generate-id(.)=generate-id(key('subjects-by-initial',substring(.,1,1))[1])]">
			<xsl:sort select="substring(.,1,1)" data-type="text" />

			<xsl:variable name="subject-initial" select="substring(.,1,1)" />

			<!-- write a section for each subject initial -->
			<h2 id="{$subject-initial}">
				<xsl:value-of select="$subject-initial" />
			</h2>

			<!-- write a section for each subject -->
			<xsl:for-each
				select="//articles:subject[substring(.,1,1)=$subject-initial][generate-id(.)=generate-id(key('subjects',.)[1])]">
				<xsl:sort select="." data-type="text" />

				<xsl:variable name="subject" select="." />
				<h3 id="{$subject}">
					<xsl:value-of select="$subject" />
				</h3>

				<!-- write the documents for this subject sorted by date and page -->
				<xsl:for-each select="//articles:article[articles:subject=$subject]">
					<xsl:sort select="articles:year" data-type="number" />
					<xsl:sort select="articles:month" data-type="number" />
					<xsl:sort select="articles:page" data-type="number" />
					<xsl:apply-templates select="." />
				</xsl:for-each>

			</xsl:for-each>

		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>