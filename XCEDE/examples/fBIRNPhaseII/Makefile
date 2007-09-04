merge:
	cp ../../tools/xcede_merge/xcede_merge.xsl .
	rm -f merged.xml
	echo '<?xml version="1.0"?><XCEDE xmlns="http://www.xcede.org/xcede-2"/>' > merged.xml
	for i in $$( find . -name '*.xcede' ) ; do rm -f tmpmerged.xml ; xsltproc --stringparam mergedoc merged.xml xcede_merge.xsl $$i > tmpmerged.xml ; rm -f merged.xml ; mv tmpmerged.xml merged.xml ; done
