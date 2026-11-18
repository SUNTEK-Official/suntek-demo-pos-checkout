package com.suntek.checkoutapplication;

final class PrintResult {
    final boolean success;
    final String message;

    private PrintResult(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    static PrintResult ok() {
        return new PrintResult(true, "ok");
    }

    static PrintResult fail(String message) {
        return new PrintResult(false, message);
    }
}
