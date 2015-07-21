<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" version="4.0"
                encoding="UTF-8" />
    <xsl:template match="/">
        <html>
            <head>
                <title><xsl:value-of select="powers/character" />'s Powers</title>
                <style>

                    .content::after{ clear:both;}
                    .left, .right {
                        width: 10cm;
                    }
                    .left {float:left;}
                    .right{float:right;}

                    .power {
                        font-family : "Mentor Sans Std";
                        font-weight : lighter;
                        margin-bottom : 10px;
                        display: inline-block;
                        width: 10cm;
                    }
                    .power div {
                        padding: 2px 10px;
                    }

                    .power .title {
                        font-weight : bold;
                    }

                    .encounter .title {
                        background-color:#951233;
                        color: #ffffff;
                    }

                    .daily .title {
                        background-color:#4b4c4d;
                        color: #ffffff;
                    }

                    .atWill .title{
                        background-color:#609768;
                        color: #ffffff;
                    }

                    .power .title .lvl {
                        float : right;
                        font-size:0.9em;
                        font-weight:normal;
                        padding-top: 2px;
                    }

                    .power div:nth-child(even) {
                        background: linear-gradient(to right,#dcdbcc, #ffffff); /* Standard syntax */
                    }

                    .power .desc {
                        font-family : "Mentor";
                        font-style:italic;
                    }

                    .type, .attributes, .actionType, .range, .target, .attack {
                        font-weight: normal;
                    }

                    .range {
                        margin-left:20px;
                    }
                </style>
            </head>
            <body>
                <div class="content">
                    <div class="left">
                        <xsl:variable name="nodes" select="powers/power"/>
                        <xsl:variable name="mid" select="count($nodes) div 2"/>
                        <xsl:for-each select="powers/power" >
                            <xsl:if test="position()-1 = floor($mid)">
                                <xsl:text disable-output-escaping="yes"><![CDATA[</div><div class="right">]]></xsl:text>
                            </xsl:if>
                            <div>
                                <xsl:attribute name="class">power <xsl:value-of select="type" /></xsl:attribute>
                                <div class="title">
                                    <span class="lvl">
                                        <xsl:value-of select="class" /><xsl:text> </xsl:text>
                                        <xsl:value-of select="supertype"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="level"/>
                                    </span>
                                    <xsl:value-of select="title"/>
                                </div>
                                <div class="desc">
                                    <xsl:value-of select="desc"/>
                                </div>
                                <div>
                                    <span class="type">
                                        <xsl:choose>
                                            <xsl:when test="type = 'atWill'"><xsl:text>À Volonté</xsl:text></xsl:when>
                                            <xsl:when test="type = 'encounter'"><xsl:text>Rencontre</xsl:text></xsl:when>
                                            <xsl:when test="type = 'daily'"><xsl:text>Quotidien</xsl:text></xsl:when>
                                        </xsl:choose>
                                    </span><xsl:text disable-output-escaping="yes"> <![CDATA[&diams;]]> </xsl:text>
                                    <xsl:apply-templates select="attributes" /><br />
                                    <span class="actionType">
                                        <xsl:choose>
                                            <xsl:when test="actionType = 'simple'"><xsl:text>Action simple</xsl:text></xsl:when>
                                            <xsl:when test="actionType = 'minor'"><xsl:text>Action mineure</xsl:text></xsl:when>
                                            <xsl:when test="actionType = 'immediateReaction'"><xsl:text>Réaction immédiate</xsl:text></xsl:when>
                                        </xsl:choose>
                                    </span>
                                    <xsl:apply-templates select="range" />
                                    <xsl:apply-templates select="target" />
                                    <xsl:apply-templates select="trigger" />
                                    <xsl:apply-templates select="attack" />
                                </div>
                                <xsl:if test="hit">
                                    <div>
                                        <strong>Réussite : </strong><xsl:value-of select="hit" />
                                    </div>
                                </xsl:if>
                                <xsl:if test="fail">
                                    <div><strong>Échec : </strong><xsl:copy-of select="fail"/></div>
                                </xsl:if>
                                <xsl:if test="effect">
                                    <div><strong>Effet : </strong><xsl:copy-of select="effect"/></div>
                                </xsl:if>
                                <xsl:if test="mods">
                                    <xsl:for-each select="mods/mod" >
                                        <div><xsl:copy-of select="current()"/></div>
                                    </xsl:for-each>
                                </xsl:if>
                            </div>
                        </xsl:for-each>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="attributes">
        <span class="attributes">
            <xsl:for-each select="attribute">
                <xsl:value-of select="." />
                <xsl:choose>
                    <xsl:when test="position() != last()">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </span>
    </xsl:template>

    <xsl:template match="range">
        <span class="range">
            <xsl:choose>
                <xsl:when test="type = 'blast'">Proximité</xsl:when>
                <xsl:when test="type = 'burst' and center > 0">Zone</xsl:when>
                <xsl:when test="type = 'burst'">Proximité</xsl:when>
                <xsl:when test="type = 'wall'">Décharge</xsl:when>
                <xsl:when test="type = 'cac'">Corps à corps</xsl:when>
                <xsl:when test="type = 'mine'">Personnelle</xsl:when>
            </xsl:choose>
        </span><xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="type = 'burst'">Explosion <xsl:value-of select="radius" /></xsl:when>
            <xsl:when test="type = 'blast'">Décharge <xsl:value-of select="radius" /></xsl:when>
            <xsl:when test="type = 'wall'">Mur <xsl:value-of select="radius" /></xsl:when>
            <xsl:when test="type = 'cac'">Arme</xsl:when>
        </xsl:choose>
        <xsl:if test="type = 'burst' and center > 0"> à <xsl:value-of select="center"/> cases ou moins</xsl:if>

        <br />
    </xsl:template>

    <xsl:template match="target">
        <span class="target">
            <xsl:text>Cible : </xsl:text>
        </span>
        <xsl:choose>
            <xsl:when test="current() = 'allEnemiesInBlast'">Chaque ennemis pris dans l'explosion</xsl:when>
            <xsl:when test="current() = 'allAlliesInBlast'">Chaque allié pris dans l'explosion</xsl:when>
            <xsl:when test="current() = 'one'">Une créature</xsl:when>
        </xsl:choose>
        <br />
    </xsl:template>

    <xsl:template match="trigger">
        <span class="target">
            <xsl:text>Déclencheur : </xsl:text>
        </span>
        <xsl:value-of select="current()" />
        <br />
    </xsl:template>

    <xsl:template match="attack">
        <span class="attack">
            <xsl:text>Attaque : </xsl:text>
        </span>
        <xsl:value-of select="stat" /> contre <xsl:value-of select="vs" /><br />
    </xsl:template>



</xsl:stylesheet>