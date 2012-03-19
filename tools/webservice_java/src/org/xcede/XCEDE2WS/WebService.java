package org.xcede.XCEDE2WS;

import java.lang.Exception;
import java.lang.String;
import java.lang.System;
import java.lang.reflect.*;
import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;
import java.util.Iterator;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.ByteArrayOutputStream;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.namespace.NamespaceContext;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.xpath.*;

import org.apache.xerces.parsers.DOMParser;
import org.apache.xerces.xs.*;
import org.apache.xpath.domapi.XPathEvaluatorImpl;
import org.apache.xpath.XPathAPI;

import org.w3c.dom.*;
//import org.w3c.dom.xpath.XPathEvaluator;
//import org.w3c.dom.xpath.XPathNSResolver;
//import org.w3c.dom.xpath.XPathResult;

import org.restlet.Application;
import org.restlet.Context;
import org.restlet.Component;
import org.restlet.Restlet;
import org.restlet.data.Request;
import org.restlet.data.Response;
import org.restlet.data.Reference;
import org.restlet.data.Status;
import org.restlet.data.MediaType;
import org.restlet.data.Form;

import org.xcede.XCEDE2WS.XCEDEXPathNSResolver;

public class WebService extends Restlet {
    public Document fulldoc = null;
    private String XCEDENS = new String("http://www.xcede.org/xcede-2");
    Set<String> exportedFuncs = new HashSet<String>();

    public WebService() throws Exception {
	Class c = this.getClass();
	Method ms[] = c.getDeclaredMethods();
	for (int i = 0; i < ms.length; i++) {
	    Method m = ms[i];
	    String mname = m.getName();
	    if (mname.startsWith("func_")) {
		System.out.println("Adding " + mname.substring(5));
		exportedFuncs.add(mname.substring(5));
	    }
	}
    }

    public void handle(Request request, Response response) {
	Reference uri = request.getResourceRef();
	Form form = uri.getQueryAsForm();
	String path = uri.getPath();
	if (!path.startsWith("/")) {
	    response.setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
	    response.setEntity("Malformed request", MediaType.TEXT_PLAIN);
	    return;
	}
	String funcname = path.substring(1);
	if (!exportedFuncs.contains(funcname)) {
	    response.setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
	    response.setEntity("There is no function by the name '" + funcname + "'\n", MediaType.TEXT_PLAIN);
	    return;
	}
	Map<String, String> params = new HashMap<String, String>();
	Iterator<String> pniter = form.getNames().iterator();
	while (pniter.hasNext()) {
	    String paramname = pniter.next();
	    params.put(paramname, form.getFirstValue(paramname));
	}
	try {
	    Method m = this.getClass().getMethod("func_" + funcname, Request.class, Response.class, params.getClass());
	    if (m == null) {
		response.setStatus(Status.SERVER_ERROR_INTERNAL);
		response.setEntity("There is no function by that name", MediaType.TEXT_PLAIN);
		return;
	    }
	    m.invoke(this, request, response, params);
	} catch (Exception e) {
	    e.printStackTrace();
	    System.err.println("Exception thrown: " + e.toString());
	}
    }

    /**
     * Add the contents of an XCEDE file to the in-memory XCEDE dataset
     */
    public void addXCEDEFile(String path) throws Exception {
	DOMParser parser = new DOMParser();
	parser.setFeature("http://xml.org/sax/features/validation", true);
	parser.setFeature("http://apache.org/xml/features/validation/schema", true);
	parser.setProperty("http://apache.org/xml/properties/dom/document-class-name", "org.apache.xerces.dom.PSVIDocumentImpl"); 
	URL xsdcore = ClassLoader.getSystemResource("org/xcede/XCEDE2WS/xcede-2.0-core.xsd");
	URL xsdmr = ClassLoader.getSystemResource("org/xcede/XCEDE2WS/xcede-2.0-mr.xsd");
	URL xsdfbirn = ClassLoader.getSystemResource("org/xcede/XCEDE2WS/xcede-fbirn-base.xsd");
	parser.setProperty("http://apache.org/xml/properties/schema/external-schemaLocation", "http://www.xcede.org/xcede-2 " + xsdmr + " http://www.xcede.org/xcede-2 " + xsdcore + " http://www.xcede.org/xcede-2/extensions/fbirn " + xsdfbirn);
	parser.parse(path);
	Document doc = parser.getDocument();

	if (! doc.getDocumentElement().isSupported("psvi", "1.0")) {
	    throw new Exception("DOM implementation does not support PSVI!");
	}
	Element root = doc.getDocumentElement();
	
	Vector v = new Vector();
	v.add((Node)root);
	while (v.size() > 0) {
	    Node n = (Node)v.remove(v.size() - 1);
	    for (Node child = n.getFirstChild(); child != null; child = child.getNextSibling()) {
		v.add((Node)child);
	    }
	    if (n.getNodeType() == Node.ELEMENT_NODE) {
		NamedNodeMap nnm = n.getAttributes();
		for (int i = 0; i < nnm.getLength(); i++) {
		    Attr a = (Attr)nnm.item(i);
		    if (!a.getSpecified()) {
			AttributePSVI ap = (AttributePSVI)a;
			String nv = ap.getSchemaNormalizedValue();
			a.setNodeValue(nv);
		    }
		}
	    }
	}

	if (fulldoc == null) {
	    fulldoc = doc;
	} else {
	    Element fullroot = this.fulldoc.getDocumentElement();
	    for (Node child = root.getFirstChild(); child != null; child = child.getNextSibling()) {
		Node newnode = this.fulldoc.importNode(child, true);
		fullroot.appendChild(newnode);
	    }
	}
    }

    /**
     * Reads HTML documentation (if it exists) for the functions
     */
    protected String getFuncDoc(String funcname) {
	String htmlfile = new String("org/xcede/XCEDE2WS/func_" + funcname + ".html");
	try {
	    System.err.println("Looking for resource " + htmlfile);
	    BufferedReader in = new BufferedReader(new InputStreamReader(ClassLoader.getSystemResourceAsStream(htmlfile)));
	    String retval = new String("");
	    String line = null;
	    while ((line = in.readLine()) != null) {
		retval += line;
	    }
	    return retval;
	} catch (Exception e) {
	    return new String("");
	}
    }


    /**
     * Used to resolve the XCEDE namespace in XPath expressions
     */
    public static class XCEDENamespaceContext implements NamespaceContext
    {
        public String getNamespaceURI(String prefix)
        {
            if (prefix == null)
              throw new IllegalArgumentException("The prefix cannot be null.");

            if (prefix.equals("xcede"))
                return "http://www.xcede.org/xcede-2";
            else
                return null;
        }

        public String getPrefix(String namespace)
        {
            if (namespace == null)
              throw new IllegalArgumentException("The namespace uri cannot be null.");
	    if (namespace.equals("http://www.xcede.org/xcede-2"))
              return "xcede";
            else
              return null;
        }

        public Iterator getPrefixes(String namespace)
        {
            return null;
        }
    }

    ///////////////////////////////////////////////////////////////////////
    // Here are all the web service functions.
    // The web service function name must be preceded by func_ to be
    // exported to the web service.
    // If you want to disable a function, but want to keep the code here,
    // you could just rename it to "xfunc_..." if you wish.
    ///////////////////////////////////////////////////////////////////////
	;
    
    public void func_get_full_XCEDE(Request request, Response response, HashMap<String, String> params) throws Exception {
	Transformer tr = TransformerFactory.newInstance().newTransformer();
	tr.setOutputProperty(OutputKeys.INDENT, "yes");
	tr.setOutputProperty(OutputKeys.METHOD, "xml");
	tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	tr.transform(new DOMSource(this.fulldoc), new StreamResult(baos));
	response.setEntity(baos.toString(), MediaType.TEXT_PLAIN);
	return;
    }

    public void func_get_function_list(Request request, Response response, HashMap<String, String> params) throws Exception {
 	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
 	DocumentBuilder db = dbf.newDocumentBuilder();
	Document doc = db.newDocument();
	Element list = doc.createElement("list");
	doc.appendChild(list);
	String [] funclist = new String [exportedFuncs.size()];
	exportedFuncs.toArray(funclist);
	for (int i = 0; i < funclist.length; i++) {
	    String funcname = funclist[i];
	    Element item = (Element)list.appendChild(doc.createElement("item"));
	    item.setAttribute("id", "function");
	    Element namefield = (Element)item.appendChild(doc.createElement("field"));
	    namefield.setAttribute("id", "name");
	    namefield.appendChild(doc.createTextNode(funcname));
	    Element docfield = (Element)item.appendChild(doc.createElement("field"));
	    docfield.setAttribute("id", "documentation");
	    docfield.appendChild(doc.createCDATASection(getFuncDoc(funcname)));
	}
	Transformer tr = TransformerFactory.newInstance().newTransformer();
	tr.setOutputProperty(OutputKeys.INDENT, "yes");
	tr.setOutputProperty(OutputKeys.METHOD, "xml");
	tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	tr.transform(new DOMSource(doc), new StreamResult(baos));
	response.setEntity(baos.toString(), MediaType.TEXT_PLAIN);
    }

    public void func_apply_xpath(Request request, Response response, HashMap<String, String> params) throws Exception {
	if (!params.containsKey("xpath")) {
	    response.setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
	    response.setEntity("apply_xpath: Missing param 'xpath'", MediaType.TEXT_PLAIN);
	    return;
	}
	XPathFactory xpf = XPathFactory.newInstance();
	XPath xp = xpf.newXPath();
	xp.setNamespaceContext(new XCEDENamespaceContext());
	XPathExpression xpe = xp.compile(params.get("xpath"));
	NodeList result = (NodeList)xpe.evaluate(this.fulldoc, XPathConstants.NODESET);
  
 	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
 	DocumentBuilder db = dbf.newDocumentBuilder();
	Document doc = db.newDocument();
	Element list = doc.createElement("list");
	doc.appendChild(list);
	for (int i = 0; i < result.getLength(); i++) {
	    Node n = result.item(i);
	    Element item = (Element)list.appendChild(doc.createElement("item"));
	    item.setAttribute("id", "XPath result");
	    item.appendChild(doc.importNode(n, true));
	}
	Transformer tr = TransformerFactory.newInstance().newTransformer();
	tr.setOutputProperty(OutputKeys.INDENT, "yes");
	tr.setOutputProperty(OutputKeys.METHOD, "xml");
	tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	tr.transform(new DOMSource(doc), new StreamResult(baos));
	response.setEntity(baos.toString(), MediaType.TEXT_PLAIN);
    }
}
