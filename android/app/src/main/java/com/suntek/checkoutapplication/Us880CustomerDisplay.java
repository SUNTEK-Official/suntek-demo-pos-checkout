package com.suntek.checkoutapplication;

final class Us880CustomerDisplay {

    private final SublcdBackend backend;
    private boolean connected;

    Us880CustomerDisplay() {
        this(new AgenewSublcdBackend());
    }

    Us880CustomerDisplay(SublcdBackend backend) {
        this.backend = backend;
    }

    synchronized String connect() {
        try {
            backend.powerOn();
            try {
                backend.setContentVisible(CustomerDisplayContent.CONTENT_CUSTOM, true);
            } catch (Throwable ignored) {
            }
            backend.setCustomContent(CustomerDisplayContent.idle());
            connected = true;
            return null;
        } catch (Throwable error) {
            connected = false;
            return "Customer display init failed: " + error.getMessage();
        }
    }

    synchronized boolean isConnected() {
        return connected;
    }

    synchronized void showTotal(double total, int itemCount) {
        if (!ensureConnected()) {
            return;
        }
        try {
            backend.setCustomContent(CustomerDisplayContent.order(total, itemCount));
        } catch (Throwable ignored) {
            connected = false;
        }
    }

    synchronized void showIdle() {
        if (!ensureConnected()) {
            return;
        }
        try {
            backend.setCustomContent(CustomerDisplayContent.idle());
        } catch (Throwable ignored) {
            connected = false;
        }
    }

    synchronized void close() {
        if (connected) {
            try {
                backend.setCustomContent(CustomerDisplayContent.idle());
                backend.powerOff();
            } catch (Throwable ignored) {
            }
        }
        connected = false;
    }

    private boolean ensureConnected() {
        if (connected) {
            return true;
        }
        return connect() == null;
    }
}
