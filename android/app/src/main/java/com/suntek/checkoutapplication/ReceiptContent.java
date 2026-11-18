package com.suntek.checkoutapplication;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;

final class ReceiptContent {

    static final int ALIGN_LEFT = 0;
    static final int ALIGN_CENTER = 2;
    static final int ALIGN_RIGHT = 4;
    static final int SIZE_SMALL = 16;
    static final int SIZE_NORMAL = 24;
    static final int SIZE_LARGE = 32;
    static final String QR_URL = "https://www.suntekai.com/";
    static final String QR_CAPTION = "www.suntekai.com";
    private static final String RULE = "--------------------------------";

    final List<Line> lines;
    final String qrContent;

    ReceiptContent(List<Line> lines, String qrContent) {
        this.lines = Collections.unmodifiableList(new ArrayList<>(lines));
        this.qrContent = qrContent;
    }

    static ReceiptContent order(
            List<OrderItem> items,
            String paymentMethod,
            double subtotal,
            double tax,
            double total,
            long orderId,
            Date printedAt
    ) {
        List<Line> lines = new ArrayList<>();
        lines.add(Line.centerBold("SUNTEK CHECKOUT", SIZE_LARGE));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Order: " + orderId));
        lines.add(Line.left("Time : " + formatTime(printedAt)));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Item        Price  Qty   Total"));
        lines.add(Line.left(RULE));
        for (OrderItem item : items) {
            lines.add(Line.left(formatItem(item)));
        }
        lines.add(Line.left(RULE));
        lines.add(Line.left(String.format(Locale.US, "Subtotal:           %7.2f", subtotal)));
        lines.add(Line.left(String.format(Locale.US, "Tax(5%%):            %7.2f", tax)));
        lines.add(Line.left(String.format(Locale.US, "Total:              %7.2f", total)));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Payment: " + paymentMethod));
        lines.add(Line.left("Thank you!"));
        return new ReceiptContent(lines, QR_URL);
    }

    static ReceiptContent multilingualTest() {
        List<Line> lines = new ArrayList<>();
        lines.add(Line.centerBold("SUNTEK", SIZE_LARGE));
        lines.add(Line.centerBold("MULTILINGUAL RECEIPT TEST", SIZE_NORMAL));
        lines.add(Line.center("SK1-15 KIOSK"));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Document No.: MET-2026-0815-001"));
        lines.add(Line.left("Date: 15/08/2026"));
        lines.add(Line.left("Time: 16:55"));
        lines.add(Line.left("Currency: EUR"));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Description          Qty.  Total"));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Coffee                 1  2,50 €"));
        lines.add(Line.left("Sandwich               1  4,20 €"));
        lines.add(Line.left("Mineral Water          1  1,30 €"));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Subtotal                   8,00 €"));
        lines.add(Line.left("VAT / IVA / TVA / MwSt.    1,50 €"));
        lines.add(Line.left(RULE));
        lines.add(Line.left("TOTAL                      8,00 €"));
        lines.add(Line.left(RULE));
        lines.add(Line.left("Payment Method: Card"));
        lines.add(Line.centerBold("EUROPEAN LANGUAGE TEST", SIZE_NORMAL));
        lines.add(Line.left("PORTUGUÊS"));
        lines.add(Line.left("Informação fiscal"));
        lines.add(Line.left("IVA incluído"));
        lines.add(Line.left("Solução de pagamento"));
        lines.add(Line.left("Saúde e atenção"));
        lines.add(Line.left("ESPAÑOL"));
        lines.add(Line.left("Información fiscal"));
        lines.add(Line.left("IVA incluido"));
        lines.add(Line.left("Facturación electrónica"));
        lines.add(Line.left("Atención al cliente"));
        lines.add(Line.left("FRANÇAIS"));
        lines.add(Line.left("Informations fiscales"));
        lines.add(Line.left("TVA incluse"));
        lines.add(Line.left("Reçu électronique"));
        lines.add(Line.left("Service clientèle"));
        lines.add(Line.left("DEUTSCH"));
        lines.add(Line.left("Steuerinformationen"));
        lines.add(Line.left("MwSt. enthalten"));
        lines.add(Line.left("Elektronische Rechnung"));
        lines.add(Line.left("Gebühren und Prüfung"));
        lines.add(Line.left("ITALIANO"));
        lines.add(Line.left("Informazioni fiscali"));
        lines.add(Line.left("IVA inclusa"));
        lines.add(Line.left("Ricevuta elettronica"));
        lines.add(Line.left("Città e servizi"));
        lines.add(Line.left("ENGLISH"));
        lines.add(Line.left("Fiscal information"));
        lines.add(Line.left("VAT included"));
        lines.add(Line.left("Electronic receipt"));
        lines.add(Line.left("Customer service"));
        lines.add(Line.centerBold("Special Character Test:", SIZE_NORMAL));
        lines.add(Line.center("á à â ã ä"));
        lines.add(Line.center("é è ê ë"));
        lines.add(Line.center("í ì î ï"));
        lines.add(Line.center("ó ò ô õ ö"));
        lines.add(Line.center("ú ù û ü"));
        lines.add(Line.center("ç ñ ß"));
        lines.add(Line.center("€  £"));
        lines.add(Line.center("PRINT TEST"));
        lines.add(Line.center("FOR DEMO PURPOSES"));
        lines.add(Line.center("NO FISCAL VALUE"));
        lines.add(Line.left("Powered by SUNTEK"));
        lines.add(Line.left("SK1-15 Printing Solution"));
        lines.add(Line.left("www.suntekai.com"));
        return new ReceiptContent(lines, QR_URL);
    }

    List<String> texts() {
        List<String> texts = new ArrayList<>();
        for (Line line : lines) {
            texts.add(line.text);
        }
        return texts;
    }

    private static String formatItem(OrderItem item) {
        String name = item.getProduct().getName();
        if (name.length() > 10) {
            name = name.substring(0, 10);
        }
        return String.format(Locale.US, "%-10s %5.2f %4d %7.2f",
                name,
                item.getProduct().getPrice(),
                item.getQuantity(),
                item.getTotalPrice());
    }

    private static String formatTime(Date printedAt) {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(printedAt);
    }

    static final class Line {
        final String text;
        final int align;
        final boolean bold;
        final int size;

        Line(String text, int align, boolean bold, int size) {
            this.text = text;
            this.align = align;
            this.bold = bold;
            this.size = size;
        }

        static Line left(String text) {
            return new Line(text, ALIGN_LEFT, false, SIZE_NORMAL);
        }

        static Line center(String text) {
            return new Line(text, ALIGN_CENTER, false, SIZE_NORMAL);
        }

        static Line centerBold(String text, int size) {
            return new Line(text, ALIGN_CENTER, true, size);
        }
    }
}
