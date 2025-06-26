package com.coderstack.clinicgrid.logging;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.WriteListener;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

public class CachedBodyHttpServletResponse extends HttpServletResponseWrapper {

    private final ByteArrayOutputStream cachedBody;
    private final ServletOutputStream outputStream;
    private final PrintWriter writer;

    public CachedBodyHttpServletResponse(HttpServletResponse response) {
        super(response);
        this.cachedBody = new ByteArrayOutputStream();
        this.outputStream = new ServletOutputStream() {
            @Override public void write(int b) {
                cachedBody.write(b);
            }
            @Override public boolean isReady() {
                return true;
            }
            @Override public void setWriteListener(WriteListener listener) { }
        };
        this.writer = new PrintWriter(cachedBody);
    }

    public byte[] getCachedBody() {
        return cachedBody.toByteArray();
    }

    @Override
    public ServletOutputStream getOutputStream() {
        return outputStream;
    }

    @Override
    public PrintWriter getWriter() {
        return writer;
    }

    public void copyBodyToResponse() throws IOException {
        getResponse().getOutputStream().write(getCachedBody());
        getResponse().flushBuffer();
    }
}