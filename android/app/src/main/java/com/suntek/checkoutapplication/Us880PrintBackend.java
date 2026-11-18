package com.suntek.checkoutapplication;

import android.graphics.Typeface;

import com.pos.devices.Printer;

import java.nio.charset.StandardCharsets;

final class Us880PrintBackend implements PrintBackend {

    @Override
    public int init() {
        return Printer.DLL_PrnInit();
    }

    @Override
    public int startCaching() {
        return Printer.DLL_PrnStartCaching();
    }

    @Override
    public int setGray(int gray) {
        return Printer.DLL_PrnSetGray(gray);
    }

    @Override
    public int getTemperature() {
        return Printer.DLL_PrnGetTemperature();
    }

    @Override
    public int setFont(boolean bold, int size) {
        Typeface typeface = Typeface.create(
                Typeface.DEFAULT,
                bold ? Typeface.BOLD : Typeface.NORMAL
        );
        return Printer.DLL_PrnSetFont(typeface, 0x00, size);
    }

    @Override
    public int setAlign(int align) {
        return Printer.DLL_PrnSetAlignStyle(align);
    }

    @Override
    public int printStr(String text) {
        return Printer.DLL_PrnStr(text);
    }

    @Override
    public int printQr(String content) {
        return Printer.DLL_PrnQRCode(content.getBytes(StandardCharsets.UTF_8), 0);
    }

    @Override
    public int start() {
        final int[] result = {Printer.PRINTER_PARAMETER_STATUS_ERROR};
        Printer.DLL_PrnStart(value -> result[0] = value);
        return result[0];
    }
}
