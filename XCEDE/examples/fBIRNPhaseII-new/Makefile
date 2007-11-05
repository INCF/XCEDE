XCEDESCHEMA=/home/gadde/birn-cvs/BIRN/XCEDE/xcede-2.0-mr.xsd
FBIRNSCHEMA=/home/gadde/birn-cvs/BIRN/XCEDE/extensions/fbirn/xcede-fbirn-base.xsd

INPUTS=ACQUISITIONlist.xcede ACQUISITION.xcede ANALYSIS.xml AssessmentProtocolExample.xcede CATALOG.xcede EPISODE.xcede EVENTS.xcede PROJECT.xcede STUDY.xcede SUBJECT.xcede VISIT.xcede

all: merged.xml merged.html xcede2html.css

merged.xml: ../../tools/xcede_merge/xcede_merge.xsl ${INPUTS}
	cp ../../tools/xcede_merge/xcede_merge.xsl .
	rm -f merged.xml
	echo '<?xml version="1.0"?><XCEDE xmlns="http://www.xcede.org/xcede-2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.xcede.org/xcede-2 '"${XCEDESCHEMA}"' http://www.xcede.org/xcede-2/extensions/fbirn '"${FBIRNSCHEMA}"'" />' > merged.xml
	for i in ${INPUTS} ; do rm -f tmpmerged.xml ; xsltproc --stringparam mergedoc merged.xml xcede_merge.xsl $$i > tmpmerged.xml ; rm -f merged.xml ; mv tmpmerged.xml merged.xml ; done

merged.html: merged.xml ../../tools/xcede2html/xcede2html.xsl ../../extensions/fbirn/xcede2html_fbirn.xsl
	rm -f merged.html
	xsltproc ../../extensions/fbirn/xcede2html_fbirn.xsl merged.xml > merged.html

xcede2html.css: ../../tools/xcede2html/xcede2html.css
	cp ../../tools/xcede2html/xcede2html.css .

