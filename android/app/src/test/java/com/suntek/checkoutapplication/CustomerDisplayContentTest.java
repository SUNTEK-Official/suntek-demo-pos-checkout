package com.suntek.checkoutapplication;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class CustomerDisplayContentTest {

    @Test
    public void idleShowsWelcomeMessage() {
        CustomerDisplayContent idle = CustomerDisplayContent.idle();

        assertEquals("SUNTEK", idle.title);
        assertEquals("Welcome", idle.headline);
        assertEquals("Please add items", idle.detail);
    }

    @Test
    public void orderShowsFormattedTotalAndItemCount() {
        CustomerDisplayContent order = CustomerDisplayContent.order(3.15, 2);

        assertEquals("TOTAL", order.title);
        assertEquals("$3.15", order.headline);
        assertEquals("2 items", order.detail);
    }

    @Test
    public void orderUsesSingularItemLabel() {
        CustomerDisplayContent order = CustomerDisplayContent.order(3.00, 1);

        assertEquals("$3.00", order.headline);
        assertEquals("1 item", order.detail);
    }
}
