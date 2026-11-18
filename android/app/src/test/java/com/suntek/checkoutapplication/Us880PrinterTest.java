package com.suntek.checkoutapplication;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class Us880PrinterTest {

    @Test
    public void connectSucceedsWhenInitReturnsOk() {
        FakePrintBackend backend = new FakePrintBackend();
        Us880Printer printer = new Us880Printer(backend);

        assertNull(printer.connect());
        assertTrue(printer.isConnected());
        assertEquals(1, backend.initCount);
    }

    @Test
    public void connectFailsWhenInitReturnsError() {
        FakePrintBackend backend = new FakePrintBackend();
        backend.initResult = Us880Printer.RESULT_BUSY;
        Us880Printer printer = new Us880Printer(backend);

        String error = printer.connect();
        assertEquals("Printer init failed: printer busy", error);
        assertFalse(printer.isConnected());
    }

    @Test
    public void printConnectsAutomaticallyWhenNotYetConnected() {
        FakePrintBackend backend = new FakePrintBackend();
        Us880Printer printer = new Us880Printer(backend);

        PrintResult result = printer.print(sampleOrder());
        assertTrue(result.success);
        assertTrue(printer.isConnected());
        assertEquals(2, backend.initCount);
        assertEquals(1, backend.startCount);
    }

    @Test
    public void printReportsConnectFailureWhenInitFails() {
        FakePrintBackend backend = new FakePrintBackend();
        backend.initResult = Us880Printer.RESULT_NO_PAPER;
        Us880Printer printer = new Us880Printer(backend);

        PrintResult result = printer.print(sampleOrder());
        assertFalse(result.success);
        assertEquals("Printer not connected: Printer init failed: printer no paper", result.message);
        assertFalse(printer.isConnected());
        assertEquals(0, backend.startCount);
    }

    @Test
    public void printRejectsEmptyReceipt() {
        FakePrintBackend backend = new FakePrintBackend();
        Us880Printer printer = connected(backend);

        PrintResult result = printer.print(new ReceiptContent(new ArrayList<>(), null));
        assertFalse(result.success);
        assertEquals("Receipt is empty", result.message);
        assertEquals(0, backend.startCount);
    }

    @Test
    public void printStopsWhenPrinterHasNoPaper() {
        FakePrintBackend backend = new FakePrintBackend();
        backend.temperature = (1 << 8) | 40;
        Us880Printer printer = connected(backend);

        PrintResult result = printer.print(sampleOrder());
        assertFalse(result.success);
        assertEquals("Printer no paper", result.message);
        assertEquals(0, backend.startCount);
    }

    @Test
    public void printStopsWhenPrinterOverheats() {
        FakePrintBackend backend = new FakePrintBackend();
        backend.temperature = 72;
        Us880Printer printer = connected(backend);

        PrintResult result = printer.print(sampleOrder());
        assertFalse(result.success);
        assertEquals("Printer overheat", result.message);
        assertEquals(0, backend.startCount);
    }

    @Test
    public void printSendsTextQrCaptionAndStartsJob() {
        FakePrintBackend backend = new FakePrintBackend();
        Us880Printer printer = connected(backend);

        PrintResult result = printer.print(sampleOrder());
        assertTrue(result.success);
        assertEquals(1, backend.startCount);
        assertTrue(backend.printedTexts.contains("SUNTEK CHECKOUT\n"));
        assertTrue(backend.printedTexts.contains("Payment: cash payment\n"));
        assertTrue(backend.printedTexts.contains("Thank you!\n"));
        assertTrue(backend.printedTexts.contains(ReceiptContent.QR_CAPTION + "\n"));
        assertEquals(1, backend.qrContents.size());
        assertEquals(ReceiptContent.QR_URL, backend.qrContents.get(0));
        assertTrue(backend.aligns.contains(ReceiptContent.ALIGN_CENTER));
        assertEquals(Us880Printer.GRAY_DEFAULT, backend.lastGray);
        assertEquals(Us880Printer.TEAR_OFF_LINES, countNewlines(backend.printedTexts));
    }

    @Test
    public void printPassesEuropeanCharactersThrough() {
        FakePrintBackend backend = new FakePrintBackend();
        Us880Printer printer = connected(backend);

        PrintResult result = printer.print(ReceiptContent.multilingualTest());
        assertTrue(result.success);
        assertTrue(backend.printedTexts.contains("PORTUGUÊS\n"));
        assertTrue(backend.printedTexts.contains("Informação fiscal\n"));
        assertTrue(backend.printedTexts.contains("á à â ã ä\n"));
        assertTrue(backend.printedTexts.contains("€  £\n"));
    }

    @Test
    public void printReportsStartFailure() {
        FakePrintBackend backend = new FakePrintBackend();
        backend.startResult = Us880Printer.RESULT_COVER_OPEN;
        Us880Printer printer = connected(backend);

        PrintResult result = printer.print(sampleOrder());
        assertFalse(result.success);
        assertEquals("printer cover closed", result.message);
    }

    @Test
    public void describeMapsKnownResultCodes() {
        assertEquals("ok", Us880Printer.describe(Us880Printer.RESULT_OK));
        assertEquals("printer no paper", Us880Printer.describe(Us880Printer.RESULT_NO_PAPER));
        assertEquals("printer overheat", Us880Printer.describe(Us880Printer.RESULT_OVERHEAT));
        assertEquals("error code -99", Us880Printer.describe(-99));
    }

    private static Us880Printer connected(FakePrintBackend backend) {
        Us880Printer printer = new Us880Printer(backend);
        assertNull(printer.connect());
        return printer;
    }

    private static ReceiptContent sampleOrder() {
        List<OrderItem> items = new ArrayList<>();
        items.add(new OrderItem(new Product("1", "Cola", 3.00, 0)));
        return ReceiptContent.order(items, "cash payment", 3.00, 0.15, 3.15, 1001L, new Date());
    }

    private static int countNewlines(List<String> texts) {
        int count = 0;
        for (String text : texts) {
            if ("\n".equals(text)) {
                count++;
            }
        }
        return count;
    }

    private static final class FakePrintBackend implements PrintBackend {
        int initResult = Us880Printer.RESULT_OK;
        int cacheResult = Us880Printer.RESULT_OK;
        int grayResult = Us880Printer.RESULT_OK;
        int fontResult = Us880Printer.RESULT_OK;
        int alignResult = Us880Printer.RESULT_OK;
        int printResult = Us880Printer.RESULT_OK;
        int qrResult = Us880Printer.RESULT_OK;
        int startResult = Us880Printer.RESULT_OK;
        int temperature = 40;
        int initCount;
        int startCount;
        int lastGray = -1;
        final List<String> printedTexts = new ArrayList<>();
        final List<String> qrContents = new ArrayList<>();
        final List<Integer> aligns = new ArrayList<>();

        @Override
        public int init() {
            initCount++;
            return initResult;
        }

        @Override
        public int startCaching() {
            return cacheResult;
        }

        @Override
        public int setGray(int gray) {
            lastGray = gray;
            return grayResult;
        }

        @Override
        public int getTemperature() {
            return temperature;
        }

        @Override
        public int setFont(boolean bold, int size) {
            return fontResult;
        }

        @Override
        public int setAlign(int align) {
            aligns.add(align);
            return alignResult;
        }

        @Override
        public int printStr(String text) {
            printedTexts.add(text);
            return printResult;
        }

        @Override
        public int printQr(String content) {
            qrContents.add(content);
            return qrResult;
        }

        @Override
        public int start() {
            startCount++;
            return startResult;
        }
    }
}
