<?xml version="1.0" encoding="UTF-8"?>

<!-- Transforms the articles.xml file into a Web page that lists all the 
	articles and hyperlinks them to the documents. Arthur Ryman, 2011-09-04 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:articles="http://www.jgstoronto.ca/schemas/articles.xsd#"
	exclude-result-prefixes="articles">

	<xsl:variable name="copy" select="'&#169;'" />
	<xsl:variable name="nbsp" select="'&#160;'" />

	<xsl:template name="head">
		<xsl:param name="title" />
		<head>
			<title>
				<xsl:value-of select="$title" />
			</title>
			<meta name="description"
				content="Shem Tov is the quarterly newsletter of the Jewish Genealogical Society of Canada (Toronto)." />
			<meta name="keywords" content="Jewish, genealogy, Toronto" />
			<meta name="robots" content="index, follow" />
			<meta name="author" content="Arthur Ryman" />
			<link href="shem-tov-index.css" rel="stylesheet" type="text/css"
				media="screen" />
		</head>
	</xsl:template>

	<xsl:template name="header">
		<div class="header">
			<div class="banner">
				<a href="http://www.jgstoronto.ca" title="Jewish Genealogical Society of Canada (Toronto)">
					<img src="JGSsmall.png" alt="Jewish Genealogical Society of Canada (Toronto)" />
				</a>
			</div>

			<nav>
				<ul>
					<li id="year-link">
						<a href="index.html">Year Index</a>
					</li>
					<li id="author-link">
						<a href="authors.html">Author Index</a>
					</li>
					<li id="subject-link">
						<a href="subjects.html">Subject Index</a>
					</li>
				</ul>
			</nav>
		</div>
	</xsl:template>

	<xsl:template name="footer">
		<div class="footer">Copyright&#160;&#169;&#160;2011,
			2015 Jewish
			Genealogical Society of Canada (Toronto). All Rights Reserved.
		</div>
	</xsl:template>

	<!-- write the description of an article with hyperlinks -->
	<xsl:template match="articles:article">
		<p>
			<!-- write the title -->
			<span class="title">
				<xsl:value-of select="articles:title" />
			</span>
			<xsl:text>, </xsl:text>

			<!-- write and link to the document -->
			<a href="index.html#{articles:yyyy-mm}">
				<xsl:call-template name="month-year-vol-no">
					<xsl:with-param name="article" select="." />
				</xsl:call-template>
			</a>
			<xsl:text>, </xsl:text>

			<!-- write the page number -->
			<xsl:text>p</xsl:text>
			<xsl:value-of select="articles:page" />
			<xsl:text>. </xsl:text>

			<!-- write and link to the authors and subjects -->
			<xsl:call-template name="authors-and-subjects">
				<xsl:with-param name="article" select="." />
			</xsl:call-template>
		</p>
	</xsl:template>

	<!-- writes the name of a month, e.g. month 3 is March -->
	<xsl:template name="month-name">
		<xsl:param name="month" />
		<xsl:choose>
			<xsl:when test="$month=1">
				<xsl:text>January</xsl:text>
			</xsl:when>
			<xsl:when test="$month=2">
				<xsl:text>February</xsl:text>
			</xsl:when>
			<xsl:when test="$month=3">
				<xsl:text>March</xsl:text>
			</xsl:when>
			<xsl:when test="$month=4">
				<xsl:text>April</xsl:text>
			</xsl:when>
			<xsl:when test="$month=5">
				<xsl:text>May</xsl:text>
			</xsl:when>
			<xsl:when test="$month=6">
				<xsl:text>June</xsl:text>
			</xsl:when>
			<xsl:when test="$month=7">
				<xsl:text>July</xsl:text>
			</xsl:when>
			<xsl:when test="$month=8">
				<xsl:text>August</xsl:text>
			</xsl:when>
			<xsl:when test="$month=9">
				<xsl:text>September</xsl:text>
			</xsl:when>
			<xsl:when test="$month=10">
				<xsl:text>October</xsl:text>
			</xsl:when>
			<xsl:when test="$month=11">
				<xsl:text>November</xsl:text>
			</xsl:when>
			<xsl:when test="$month=12">
				<xsl:text>December</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Invalid Month</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- writes the description of a newsletter, e.g. September, Vol. IV -->
	<xsl:template name="month-vol">
		<xsl:param name="article" />
		<xsl:call-template name="month-name">
			<xsl:with-param name="month" select="$article/articles:month" />
		</xsl:call-template>
		<xsl:text>, Vol. </xsl:text>
		<xsl:value-of select="$article/articles:volume" />
	</xsl:template>

	<!-- writes the description of a newsletter, e.g. September, No. 3 -->
	<xsl:template name="month-no">
		<xsl:param name="article" />
		<xsl:call-template name="month-name">
			<xsl:with-param name="month" select="$article/articles:month" />
		</xsl:call-template>
		<xsl:text>, No. </xsl:text>
		<xsl:value-of select="$article/articles:issue" />
	</xsl:template>

	<!-- writes the description of a newsletter, e.g. September, Vol. IV, No. 3 -->
	<xsl:template name="month-vol-no">
		<xsl:param name="article" />
		<xsl:call-template name="month-name">
			<xsl:with-param name="month" select="$article/articles:month" />
		</xsl:call-template>
		<xsl:text>, Vol. </xsl:text>
		<xsl:value-of select="$article/articles:volume" />
		<xsl:text>, No. </xsl:text>
		<xsl:value-of select="$article/articles:issue" />
	</xsl:template>

	<!-- writes the description of a newsletter, e.g. September 1988, Vol. IV -->
	<xsl:template name="month-year-vol">
		<xsl:param name="article" />
		<xsl:call-template name="month-name">
			<xsl:with-param name="month" select="$article/articles:month" />
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$article/articles:year" />
		<xsl:text>, Vol. </xsl:text>
		<xsl:value-of select="$article/articles:volume" />
	</xsl:template>

	<!-- writes the description of a newsletter, e.g. September 1988, Vol. IV, 
		No. 2 -->
	<xsl:template name="month-year-vol-no">
		<xsl:param name="article" />
		<xsl:call-template name="month-year-vol">
			<xsl:with-param name="article" select="$article" />
		</xsl:call-template>
		<xsl:text>, No. </xsl:text>
		<xsl:value-of select="$article/articles:issue" />
	</xsl:template>

	<xsl:template name="authors-and-subjects">
		<xsl:param name="article" />

		<!-- write and link to the authors -->
		<xsl:for-each select="$article/articles:author">
			<xsl:choose>
				<xsl:when test="position()=1">
					<xsl:choose>
						<xsl:when test="last()=1">
							<xsl:text>Author: </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Authors: </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>; </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<a href="authors.html#{articles:fullName}">
				<xsl:value-of select="articles:fullName" />
			</a>
			<xsl:if test="position()=last()">
				<xsl:text>. </xsl:text>
			</xsl:if>
		</xsl:for-each>

		<!-- write and link to the subjects -->
		<xsl:for-each select="$article/articles:subject">
			<xsl:choose>
				<xsl:when test="position()=1">
					<xsl:choose>
						<xsl:when test="last()=1">
							<xsl:text>Subject: </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Subjects: </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>; </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<a href="subjects.html#{.}">
				<xsl:value-of select="." />
			</a>
			<xsl:if test="position()=last()">
				<xsl:text>. </xsl:text>
			</xsl:if>
		</xsl:for-each>

		<!-- write the PDF download link -->
		<xsl:text>Download: </xsl:text>
		<a href="{$article/articles:document}" title="Toronto Shem Tov, {$article/articles:yyyy-mm}">
			<xsl:text>PDF</xsl:text>
		</a>
		<xsl:text>. </xsl:text>

	</xsl:template>

</xsl:stylesheet>