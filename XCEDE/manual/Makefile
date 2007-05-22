CUSTOMXSL=docbook_custom.xsl
DOCBOOKXSL=/usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl
XALANJAR=${HOME}/xml/xalan-j_2_4_1/bin/xalan.jar
FOP=${HOME}/xml/fop-0.93/fop

all: manual_full.pdf

manual_full.xml: manual.xml chap_intro.xml chap_hierarchy.xml chap_events.xml chap_catalog.xml chap_data_resource.xml chap_provenance.xml chap_assessment.xml chap_protocol.xml app_schema.xml
	xmllint --xinclude manual.xml > manual_full.xml

manual_full.fo: manual_full.xml ${CUSTOMXSL}
	java -jar ${XALANJAR} -PARAM use.extensions 1 -PARAM textinsert.extension 1 -PARAM hyphenate.verbatim 1 -XSL ${CUSTOMXSL} -IN manual_full.xml -OUT manual_full.fo
#	xsltproc --stringparam use.extensions 1 --stringparam textinsert.extension 1 --stringparam hyphenate.verbatim 1 ${CUSTOMXSL} manual_full.xml > manual_full.fo

manual_full.pdf: manual_full.fo
	${FOP} -fo manual_full.fo -pdf manual_full.pdf
