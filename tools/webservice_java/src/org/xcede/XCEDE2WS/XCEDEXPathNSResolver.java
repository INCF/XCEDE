package org.xcede.XCEDE2WS;

import org.w3c.dom.xpath.XPathNSResolver;
import javax.xml.namespace.NamespaceContext;

public class XCEDEXPathNSResolver implements XPathNSResolver
{
    public XCEDEXPathNSResolver() {
    }
    
    public String lookupNamespaceURI(String prefix) {
	if ("xcede".equals(prefix)) {
	    return "http://www.xcede.org/xcede-2";
	} else {
	    return null;
	}
    }
}  
