<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='xml' version='1.0' encoding='iso8859-2' indent='yes'/>
<xsl:strip-space elements="*"/>

<xsl:variable name="package-dir">../src</xsl:variable>
<xsl:variable name="bitmap-package">com.mlabs.resource.bitmap</xsl:variable>
<xsl:variable name="sound-package">com.mlabs.resource.sound</xsl:variable>
<xsl:variable name="resource-imports-package">com.mlabs.resource</xsl:variable>
<xsl:variable name="resource-imports-source-file">Resources.hx</xsl:variable>

<xsl:variable name="bitmap-dir" select="translate($bitmap-package, '.', '/')"/>
<xsl:variable name="sound-dir" select="translate($sound-package, '.', '/')"/>
<xsl:variable name="resource-imports" select="concat(translate($resource-imports-package, '.', '/'), '/', $resource-imports-source-file)"/>

<xsl:template match="/resources">
<xsl:document href="swfmill_res.xml" method="xml" encoding="iso8859-2" indent="yes">
<movie width="60" height="20" framerate="20" version="9">
   <frame>
      <library>
         <xsl:for-each select="bitmap">
            <bitmap id="{$resource-imports-package}.{@id}" import="{@import}"/>
         </xsl:for-each>
         
         <xsl:for-each select="sound">
            <sound id="{$resource-imports-package}.{@id}" import="{@import}"/>
         </xsl:for-each>
         
         <xsl:for-each select="clip">
            <clip id="{@id}" import="{@import}"/>
         </xsl:for-each>
      </library>
   </frame>
   <xsl:for-each select="font">
      <font id="{@id}" name="{@name}" import="{@import}"/>
   </xsl:for-each>
</movie>
</xsl:document>

<xsl:document href="{$package-dir}/{$resource-imports}" method="text">package <xsl:value-of select="$resource-imports-package"/>;

<xsl:for-each select="bitmap">class <xsl:value-of select="@id"/> extends flash.display.Bitmap {
   public function new() {
      super();
   }
}
</xsl:for-each>
   
<xsl:for-each select="sound">class <xsl:value-of select="@id"/> extends flash.media.Sound { }
</xsl:for-each>
</xsl:document>

</xsl:template>

<!--
<xsl:template name="bitmap-class" match="bitmap">
   <xsl:document href="{$package-dir}/{$bitmap-dir}/{@id}.hx" method="text">package <xsl:value-of select="$bitmap-package"/>;

class <xsl:value-of select="@id"/> extends flash.display.Bitmap {
   public function new() {
      super();
   }
}</xsl:document>
   <bitmap id="{$bitmap-package}.{@id}" import="{@import}"/>
</xsl:template>

<xsl:template name="bitmap-imports" match="bitmap">import <xsl:value-of select="concat($bitmap-package, '.', @id)"/>;
</xsl:template>

<xsl:template name="sound-class" match="sound">
   <xsl:document href="{$package-dir}/{$sound-dir}/{@id}.hx" method="text">package <xsl:value-of select="$sound-package"/>;

class <xsl:value-of select="@id"/> extends flash.media.Sound {
   public function new() {
      super();
   }
}</xsl:document>
   <sound id="{$sound-package}.{@id}" import="{@import}"/>
</xsl:template>

<xsl:template name="sound-imports" match="sound">import <xsl:value-of select="concat($sound-package, '.', @id)"/>;
</xsl:template>

<xsl:template match="font">
   <font id="{@id}" name="{@name}" import="{@import}"/>
</xsl:template>
-->

</xsl:stylesheet>

