package com.suntek.checkoutapplication;

interface PrintBackend {
    int init();

    int startCaching();

    int setGray(int gray);

    int getTemperature();

    int setFont(boolean bold, int size);

    int setAlign(int align);

    int printStr(String text);

    int printQr(String content);

    int start();
}
