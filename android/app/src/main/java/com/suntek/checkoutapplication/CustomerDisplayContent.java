package com.suntek.checkoutapplication;

import java.util.Locale;
import java.util.Objects;

final class CustomerDisplayContent {

    static final int CONTENT_CUSTOM = 5;

    final String title;
    final String headline;
    final String detail;

    CustomerDisplayContent(String title, String headline, String detail) {
        this.title = title;
        this.headline = headline;
        this.detail = detail;
    }

    static CustomerDisplayContent idle() {
        return new CustomerDisplayContent("SUNTEK", "Welcome", "Please add items");
    }

    static CustomerDisplayContent order(double total, int itemCount) {
        String items = itemCount == 1 ? "1 item" : itemCount + " items";
        return new CustomerDisplayContent(
                "TOTAL",
                String.format(Locale.US, "$%.2f", total),
                items
        );
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CustomerDisplayContent)) {
            return false;
        }
        CustomerDisplayContent that = (CustomerDisplayContent) other;
        return Objects.equals(title, that.title)
                && Objects.equals(headline, that.headline)
                && Objects.equals(detail, that.detail);
    }

    @Override
    public int hashCode() {
        return Objects.hash(title, headline, detail);
    }
}
