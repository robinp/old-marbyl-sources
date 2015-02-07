all: res.swf

clean:
	@rm -f res.swf res.deps

res.swf: resources.xsl resources.xml $(shell cat res.deps)
	@echo Building resource library
	/usr/bin/xsltproc resources.xsl resources.xml
	@/usr/local/bin/swfmill -v simple swfmill_res.xml res.swf 2>&1 | tee res.deps.temp
	gawk "BEGIN{FS=\"[ ,']+\"}/^Importing/{print \$$3}" res.deps.temp > res.deps
	@rm -f swfmill_res.xml res.deps.temp

