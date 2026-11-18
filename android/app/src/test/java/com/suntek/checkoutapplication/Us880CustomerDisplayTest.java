package com.suntek.checkoutapplication;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class Us880CustomerDisplayTest {

    @Test
    public void connectPowersOnAndShowsIdle() {
        FakeSublcdBackend backend = new FakeSublcdBackend();
        Us880CustomerDisplay display = new Us880CustomerDisplay(backend);

        assertNull(display.connect());
        assertTrue(display.isConnected());
        assertEquals(1, backend.powerOnCount);
        assertEquals(CustomerDisplayContent.CONTENT_CUSTOM, backend.lastContentId);
        assertTrue(backend.lastVisible);
        assertEquals(CustomerDisplayContent.idle(), backend.lastContent);
    }

    @Test
    public void connectReportsBackendFailure() {
        FakeSublcdBackend backend = new FakeSublcdBackend();
        backend.failMessage = "binder missing";
        Us880CustomerDisplay display = new Us880CustomerDisplay(backend);

        String error = display.connect();
        assertEquals("Customer display init failed: binder missing", error);
        assertFalse(display.isConnected());
    }

    @Test
    public void showTotalSendsAmountFrame() {
        FakeSublcdBackend backend = new FakeSublcdBackend();
        Us880CustomerDisplay display = connected(backend);

        display.showTotal(12.6, 3);

        assertEquals(CustomerDisplayContent.order(12.6, 3), backend.lastContent);
    }

    @Test
    public void showIdleRestoresWelcome() {
        FakeSublcdBackend backend = new FakeSublcdBackend();
        Us880CustomerDisplay display = connected(backend);

        display.showTotal(3.00, 1);
        display.showIdle();

        assertEquals(CustomerDisplayContent.idle(), backend.lastContent);
    }

    @Test
    public void showTotalConnectsAutomaticallyWhenNeeded() {
        FakeSublcdBackend backend = new FakeSublcdBackend();
        Us880CustomerDisplay display = new Us880CustomerDisplay(backend);

        display.showTotal(3.00, 1);

        assertTrue(display.isConnected());
        assertEquals(1, backend.powerOnCount);
        assertEquals(CustomerDisplayContent.order(3.00, 1), backend.lastContent);
    }

    private static Us880CustomerDisplay connected(FakeSublcdBackend backend) {
        Us880CustomerDisplay display = new Us880CustomerDisplay(backend);
        assertNull(display.connect());
        return display;
    }

    private static final class FakeSublcdBackend implements SublcdBackend {
        String failMessage;
        int powerOnCount;
        int lastContentId = -1;
        boolean lastVisible;
        CustomerDisplayContent lastContent;

        @Override
        public void powerOn() {
            failIfNeeded();
            powerOnCount++;
        }

        @Override
        public void powerOff() {
            failIfNeeded();
        }

        @Override
        public void setContentVisible(int contentId, boolean visible) {
            failIfNeeded();
            lastContentId = contentId;
            lastVisible = visible;
        }

        @Override
        public void setCustomContent(CustomerDisplayContent content) {
            failIfNeeded();
            lastContent = content;
        }

        private void failIfNeeded() {
            if (failMessage != null) {
                throw new IllegalStateException(failMessage);
            }
        }
    }
}
