DOCBOOKXSL=/usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl 
FOP=${HOME}/xml/fop-0.93/fop

all: manual_full.pdf

manual_full.xml: manual.xml chap_intro.xml chap_hierarchy.xml chap_events.xml chap_catalog.xml chap_data_resource.xml chap_provenance.xml
	xmllint --xinclude manual.xml > manual_full.xml

manual_full.pdf: manual_full.xml
	${FOP} -xsl ${DOCBOOKXSL} -xml manual_full.xml -pdf manual_full.pdf
