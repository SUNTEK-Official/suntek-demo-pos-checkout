package com.suntek.checkoutapplication;

final class SpiLcdNative {

    static {
        System.loadLibrary("spi_lcd");
    }

    private SpiLcdNative() {
    }

    static native int nativeScreenOn();

    static native int nativeScreenOff();

    static native int nativeRefresh(byte[] pixels);
}
