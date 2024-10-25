package com.infopro.sslchecker;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import javax.net.ssl.HttpsURLConnection;
import javax.security.cert.CertificateException;

import java.io.IOException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateEncodingException;

public class SSLChecker {

    public static final String LOG_TAG = "Capacitor/SSLChecker";

    private static char[] HEX_CHARS = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
            'F'};

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }

    public boolean verify(String serverUrl, JSONArray fingerprints) {
        Log.i(LOG_TAG, "serverUrl: " + serverUrl);
        Log.i(LOG_TAG, "fingerprints: " + String.valueOf(fingerprints));

        boolean valid = false;

        try {
            final String serverFingerprint = getFingerprint(serverUrl);

            for (int i = 0; i < fingerprints.length(); i++) {
                String fingerprint = fingerprints.getString(i);

                if (fingerprint.equalsIgnoreCase(serverFingerprint)) {
                    valid = true;
                }
            }

        } catch (Exception e) {
            Log.e(LOG_TAG, "Verification failed: " + e);
        }

        Log.i(LOG_TAG, "isFingerprintValid: " + String.valueOf(valid));

        return valid;
    }

    private static String getFingerprint(String serverUrl)
            throws IOException, NoSuchAlgorithmException, CertificateException, CertificateEncodingException {

        HttpsURLConnection con = null;

        try {
            con = (HttpsURLConnection) new URL(serverUrl).openConnection();
            con.setConnectTimeout(5000);
            con.connect();
            final Certificate cert = con.getServerCertificates()[0];
            final MessageDigest md = MessageDigest.getInstance("SHA256");
            md.update(cert.getEncoded());
            return dumpHex(md.digest());

        } finally {
            if (con != null) {
                con.disconnect();
            }
        }
    }

    private static String dumpHex(byte[] data) {
        final int n = data.length;
        final StringBuilder sb = new StringBuilder(n * 3 - 1);
        for (int i = 0; i < n; i++) {
            if (i > 0) {
                sb.append(' ');
            }
            sb.append(HEX_CHARS[(data[i] >> 4) & 0x0F]);
            sb.append(HEX_CHARS[data[i] & 0x0F]);
        }
        return sb.toString();
    }
}
