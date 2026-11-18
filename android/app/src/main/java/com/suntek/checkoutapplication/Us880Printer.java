package com.suntek.checkoutapplication;

final class Us880Printer {

    static final int GRAY_DEFAULT = 3;
    static final int OVERHEAT_CELSIUS = 70;
    static final int TEAR_OFF_LINES = 5;
    static final int RESULT_OK = 0;
    static final int RESULT_BUSY = -4001;
    static final int RESULT_NO_PAPER = -4002;
    static final int RESULT_TIMEOUT = -4003;
    static final int RESULT_COVER_OPEN = -4004;
    static final int RESULT_OVERHEAT = -4005;

    private final PrintBackend backend;
    private boolean connected;

    Us880Printer() {
        this(new Us880PrintBackend());
    }

    Us880Printer(PrintBackend backend) {
        this.backend = backend;
    }

    String connect() {
        try {
            int result = backend.init();
            if (result != RESULT_OK) {
                connected = false;
                return "Printer init failed: " + describe(result);
            }
            connected = true;
            return null;
        } catch (UnsatisfiedLinkError error) {
            connected = false;
            return "Printer native library missing";
        } catch (Exception error) {
            connected = false;
            return "Printer init failed: " + error.getMessage();
        }
    }

    boolean isConnected() {
        return connected;
    }

    void close() {
        connected = false;
    }

    PrintResult print(ReceiptContent content) {
        if (!connected) {
            String error = connect();
            if (error != null) {
                return PrintResult.fail("Printer not connected: " + error);
            }
        }
        if (content == null || content.lines.isEmpty()) {
            return PrintResult.fail("Receipt is empty");
        }

        try {
            int init = backend.init();
            if (init != RESULT_OK) {
                return PrintResult.fail("Printer init failed: " + describe(init));
            }

            PrintResult hardware = checkHardware();
            if (!hardware.success) {
                return hardware;
            }

            int cache = backend.startCaching();
            if (cache != RESULT_OK) {
                return PrintResult.fail("Printer cache failed: " + describe(cache));
            }

            int gray = backend.setGray(GRAY_DEFAULT);
            if (gray != RESULT_OK) {
                return PrintResult.fail("Printer gray failed: " + describe(gray));
            }

            PrintResult lines = writeLines(content);
            if (!lines.success) {
                return lines;
            }

            PrintResult qr = writeQr(content.qrContent);
            if (!qr.success) {
                return qr;
            }

            int start = backend.start();
            if (start != RESULT_OK) {
                return PrintResult.fail(describe(start));
            }
            return PrintResult.ok();
        } catch (UnsatisfiedLinkError error) {
            connected = false;
            return PrintResult.fail("Printer native library missing");
        } catch (Exception error) {
            return PrintResult.fail("Print failed: " + error.getMessage());
        }
    }

    private PrintResult checkHardware() {
        int packed = backend.getTemperature();
        int status = packed >> 8;
        int celsius = packed & 0xFF;
        if (celsius >= OVERHEAT_CELSIUS) {
            return PrintResult.fail("Printer overheat");
        }
        if (status == 1) {
            return PrintResult.fail("Printer no paper");
        }
        return PrintResult.ok();
    }

    private PrintResult writeLines(ReceiptContent content) {
        for (ReceiptContent.Line line : content.lines) {
            int font = backend.setFont(line.bold, line.size);
            if (font != RESULT_OK) {
                return PrintResult.fail("Printer font failed: " + describe(font));
            }
            int align = backend.setAlign(line.align);
            if (align != RESULT_OK) {
                return PrintResult.fail("Printer align failed: " + describe(align));
            }
            int printed = backend.printStr(line.text + "\n");
            if (printed != RESULT_OK) {
                return PrintResult.fail("Printer write failed: " + describe(printed));
            }
        }
        return PrintResult.ok();
    }

    private PrintResult writeQr(String qrContent) {
        if (qrContent == null || qrContent.isEmpty()) {
            return feedTearOff();
        }
        int align = backend.setAlign(ReceiptContent.ALIGN_CENTER);
        if (align != RESULT_OK) {
            return PrintResult.fail("Printer align failed: " + describe(align));
        }
        int qr = backend.printQr(qrContent);
        if (qr != RESULT_OK) {
            return PrintResult.fail("Printer QR failed: " + describe(qr));
        }
        int caption = backend.printStr(ReceiptContent.QR_CAPTION + "\n");
        if (caption != RESULT_OK) {
            return PrintResult.fail("Printer write failed: " + describe(caption));
        }
        return feedTearOff();
    }

    private PrintResult feedTearOff() {
        int align = backend.setAlign(ReceiptContent.ALIGN_LEFT);
        if (align != RESULT_OK) {
            return PrintResult.fail("Printer align failed: " + describe(align));
        }
        for (int i = 0; i < TEAR_OFF_LINES; i++) {
            int feed = backend.printStr("\n");
            if (feed != RESULT_OK) {
                return PrintResult.fail("Printer feed failed: " + describe(feed));
            }
        }
        return PrintResult.ok();
    }

    static String describe(int code) {
        switch (code) {
            case RESULT_OK:
                return "ok";
            case RESULT_BUSY:
                return "printer busy";
            case RESULT_NO_PAPER:
                return "printer no paper";
            case RESULT_TIMEOUT:
                return "printer timeout";
            case RESULT_COVER_OPEN:
                return "printer cover closed";
            case RESULT_OVERHEAT:
                return "printer overheat";
            default:
                return "error code " + code;
        }
    }
}
