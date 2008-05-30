DOCBOOKXSL=/usr/share/sgml/docbook/xsl-stylesheets

CLASSPATH=src:xalan-j_2_7_1/serializer.jar:xalan-j_2_7_1/xercesImpl.jar:xalan-j_2_7_1/xml-apis.jar:xalan-j_2_7_1/xalan.jar:/home/gadde/java:restlet-1.0.10/lib/com.noelios.restlet.jar:restlet-1.0.10/lib/org.restlet.jar:restlet-1.0.10/lib/com.noelios.restlet.ext.simple_3.1.jar:restlet-1.0.10/lib/org.simpleframework_3.1/org.simpleframework.jar
JAVAC=/usr/java/jdk1.6.0_06/bin/javac
WSSRCDIR=src/org/xcede/XCEDE2WS

all: func_html ${WSSRCDIR}/XCEDEXPathNSResolver.class ${WSSRCDIR}/WebService.class ${WSSRCDIR}/WebServiceApp.class

.PHONY: func_html
func_html:
	@if [ ${WSSRCDIR}/func_get_full_XCEDE.html -ot ../../webspec/func_get_full_XCEDE.xml ] ; then echo "Creating HTML" ; for i in ../../webspec/func_*.xml ; do htmlfile=`basename $$i .xml`.html ; if [ $$i -nt $$htmlfile ] ; then xsltproc ${DOCBOOKXSL}/html/docbook.xsl $$i > ${WSSRCDIR}/$$htmlfile ; fi ; done ; fi

${WSSRCDIR}/WebService.class: ${WSSRCDIR}/WebService.java
	${JAVAC} -Xlint:deprecation -classpath ${CLASSPATH} ${WSSRCDIR}/WebService.java

${WSSRCDIR}/WebServiceApp.class: ${WSSRCDIR}/WebServiceApp.java
	${JAVAC} -Xlint:deprecation -classpath ${CLASSPATH} ${WSSRCDIR}/WebServiceApp.java

${WSSRCDIR}/XCEDEXPathNSResolver.class: ${WSSRCDIR}/XCEDEXPathNSResolver.java
	${JAVAC} -Xlint:deprecation -classpath ${CLASSPATH} ${WSSRCDIR}/XCEDEXPathNSResolver.java
