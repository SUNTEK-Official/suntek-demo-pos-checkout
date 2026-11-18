package com.suntek.checkoutapplication;

interface SublcdBackend {
    void powerOn();

    void powerOff();

    void setContentVisible(int contentId, boolean visible);

    void setCustomContent(CustomerDisplayContent content);
}
