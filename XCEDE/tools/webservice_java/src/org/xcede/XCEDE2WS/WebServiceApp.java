package org.xcede.XCEDE2WS;

import org.xcede.XCEDE2WS.WebService;

import org.restlet.Application;
import org.restlet.Component;
import org.restlet.Context;
import org.restlet.Restlet;
import org.restlet.Router;
import org.restlet.data.Protocol;

public class WebServiceApp extends Application {
    public WebService ws = new WebService();

    public WebServiceApp(Context context) throws Exception {
	super(context);
    }

    public Restlet createRoot() {
	// Create a root router
	Router router = new Router(getContext());
	router.attach("", this.ws);
	return router;
    }
    public static void main(String [] args) throws Exception
    {
	Component component = new Component();
	component.getServers().add(Protocol.HTTP, 8182);
	component.getClients().add(Protocol.FILE);
	WebServiceApp wsa = new WebServiceApp(component.getContext());
	for (int i = 0; i < args.length; i++) {
	    wsa.ws.addXCEDEFile(args[i]);
	}
	component.getDefaultHost().attach(wsa);
	component.start();
    }
}
