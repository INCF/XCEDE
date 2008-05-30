# set this to the path to the "java" executable -- must be 1.5 or newer
JAVA=/usr/java/jdk1.6.0_06/bin/java

CLASSPATH=src:xalan-j_2_7_1/serializer.jar:xalan-j_2_7_1/xercesImpl.jar:xalan-j_2_7_1/xml-apis.jar:xalan-j_2_7_1/xalan.jar:restlet-1.0.10/lib/com.noelios.restlet.jar:restlet-1.0.10/lib/org.restlet.jar:restlet-1.0.10/lib/com.noelios.restlet.ext.simple_3.1.jar:restlet-1.0.10/lib/org.simpleframework_3.1/org.simpleframework.jar

${JAVA} -classpath ${CLASSPATH} org.xcede.XCEDE2WS.WebServiceApp example/*.xcede

