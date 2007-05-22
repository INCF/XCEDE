CUSTOMXSL=docbook_custom.xsl
DOCBOOKXSL=/usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl
FOP=${HOME}/xml/fop-0.93/fop

all: manual_full.pdf

manual_full.xml: manual.xml chap_intro.xml chap_hierarchy.xml chap_events.xml chap_catalog.xml chap_data_resource.xml chap_provenance.xml chap_assessment.xml chap_protocol.xml app_schema.xml
	xmllint --xinclude manual.xml > manual_full.xml

manual_full.fo: manual_full.xml
	xsltproc --stringparam use.extensions 1 --stringparam textinsert.extension 1 ${CUSTOMXSL} manual_full.xml > manual_full.fo

manual_full.pdf: manual_full.fo
	${FOP} -fo manual_full.fo -pdf manual_full.pdf
