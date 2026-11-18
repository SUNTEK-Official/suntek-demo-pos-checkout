package com.suntek.checkoutapplication;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class ReceiptContentTest {

    @Test
    public void orderReceiptIncludesHeaderItemsTotalsAndQr() {
        List<OrderItem> items = new ArrayList<>();
        items.add(new OrderItem(new Product("1", "Cola", 3.00, 0)));
        items.add(twoBurgers());

        Date printedAt = new Date(1_766_534_400_000L);
        ReceiptContent receipt = ReceiptContent.order(
                items,
                "cash payment",
                33.00,
                1.65,
                34.65,
                1001L,
                printedAt
        );

        List<String> texts = receipt.texts();
        assertEquals("SUNTEK CHECKOUT", texts.get(0));
        assertEquals(ReceiptContent.ALIGN_CENTER, receipt.lines.get(0).align);
        assertTrue(receipt.lines.get(0).bold);
        assertTrue(contains(texts, "Order: 1001"));
        assertTrue(contains(texts, "Cola"));
        assertTrue(contains(texts, "Hamburger"));
        assertTrue(contains(texts, "  2 "));
        assertTrue(contains(texts, "15.00"));
        assertTrue(contains(texts, "30.00"));
        assertTrue(contains(texts, "Subtotal:"));
        assertTrue(contains(texts, "33.00"));
        assertTrue(contains(texts, "1.65"));
        assertTrue(contains(texts, "34.65"));
        assertTrue(contains(texts, "Payment: cash payment"));
        assertTrue(contains(texts, "Thank you!"));
        assertEquals(ReceiptContent.QR_URL, receipt.qrContent);
    }

    @Test
    public void longItemNameIsTruncatedToTenChars() {
        List<OrderItem> items = new ArrayList<>();
        items.add(new OrderItem(new Product("1", "Mineral Water Extra", 2.00, 0)));

        ReceiptContent receipt = ReceiptContent.order(
                items, "cash payment", 2.00, 0.10, 2.10, 1L, new Date()
        );

        assertTrue(contains(receipt.texts(), "Mineral Wa"));
        assertFalse(contains(receipt.texts(), "Mineral Water Extra"));
    }

    @Test
    public void multilingualReceiptKeepsEuropeanCharactersAndQr() {
        ReceiptContent receipt = ReceiptContent.multilingualTest();
        List<String> texts = receipt.texts();

        assertTrue(contains(texts, "SUNTEK"));
        assertTrue(contains(texts, "PORTUGUÊS"));
        assertTrue(contains(texts, "Informação fiscal"));
        assertTrue(contains(texts, "IVA incluído"));
        assertTrue(contains(texts, "Información fiscal"));
        assertTrue(contains(texts, "TVA incluse"));
        assertTrue(contains(texts, "MwSt. enthalten"));
        assertTrue(contains(texts, "Ricevuta elettronica"));
        assertTrue(contains(texts, "á à â ã ä"));
        assertTrue(contains(texts, "ç ñ ß"));
        assertTrue(contains(texts, "€  £"));
        assertEquals(ReceiptContent.QR_URL, receipt.qrContent);
        assertEquals(ReceiptContent.ALIGN_CENTER, receipt.lines.get(0).align);
    }

    @Test
    public void receiptLinesAreImmutableCopy() {
        List<OrderItem> items = new ArrayList<>();
        items.add(new OrderItem(new Product("1", "Cola", 3.00, 0)));
        ReceiptContent receipt = ReceiptContent.order(
                items, "cash payment", 3.00, 0.15, 3.15, 1L, new Date()
        );

        try {
            receipt.lines.add(ReceiptContent.Line.left("mutated"));
            throw new AssertionError("lines should be unmodifiable");
        } catch (UnsupportedOperationException expected) {
            assertEquals(ReceiptContent.QR_URL, receipt.qrContent);
        }
    }

    private static OrderItem twoBurgers() {
        OrderItem item = new OrderItem(new Product("4", "Hamburger", 15.00, 0));
        item.incrementQuantity();
        return item;
    }

    private static boolean contains(List<String> texts, String needle) {
        for (String text : texts) {
            if (text.contains(needle)) {
                return true;
            }
        }
        return false;
    }
}
