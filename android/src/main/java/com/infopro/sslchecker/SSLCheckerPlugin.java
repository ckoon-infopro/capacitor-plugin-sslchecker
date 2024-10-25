package com.infopro.sslchecker;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import org.json.JSONException;

@CapacitorPlugin(name = "SSLChecker")
public class SSLCheckerPlugin extends Plugin {

    private SSLChecker implementation = new SSLChecker();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void verify(PluginCall call) {
        String url = call.getString("url");
        JSArray fingerprints = call.getArray("fingerprints");

        JSObject ret = new JSObject();
        ret.put("value", implementation.verify(url, fingerprints));
        call.resolve(ret);
    }
}
