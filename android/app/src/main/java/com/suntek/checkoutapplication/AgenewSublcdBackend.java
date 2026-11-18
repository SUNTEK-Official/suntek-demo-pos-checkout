package com.suntek.checkoutapplication;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.os.IBinder;
import android.os.Parcel;
import android.util.Log;

import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

final class AgenewSublcdBackend implements SublcdBackend {

    static final int WIDTH = 320;
    static final int HEIGHT = 170;
    static final int FRAME_BYTES = WIDTH * HEIGHT * 2;
    private static final String SERVICE_NAME = "agenew_sublcd";
    private static final String DESCRIPTOR = "com.agenew.sublcd.ISublcd";
    private static final int TRANSACTION_SET_CONTENT_VISIBLE = IBinder.FIRST_CALL_TRANSACTION + 3;
    private static final int BACKGROUND = Color.rgb(11, 31, 58);
    private static final int TITLE_COLOR = Color.rgb(148, 163, 184);
    private static final int HEADLINE_COLOR = Color.rgb(250, 204, 21);
    private static final int DETAIL_COLOR = Color.WHITE;
    private static final String TAG = "AgenewSublcd";

    @Override
    public void powerOn() {
        int result = SpiLcdNative.nativeScreenOn();
        if (result <= 0) {
            throw new IllegalStateException("screenOn failed: " + result);
        }
        trySetCustomLayerVisible();
    }

    @Override
    public void powerOff() {
        int result = SpiLcdNative.nativeScreenOff();
        if (result <= 0) {
            throw new IllegalStateException("screenOff failed: " + result);
        }
    }

    @Override
    public void setContentVisible(int contentId, boolean visible) {
        transactSetContentVisible(contentId, visible);
    }

    @Override
    public void setCustomContent(CustomerDisplayContent content) {
        Bitmap bitmap = render(content);
        try {
            ByteBuffer buffer = ByteBuffer.allocate(FRAME_BYTES);
            buffer.order(ByteOrder.LITTLE_ENDIAN);
            bitmap.copyPixelsToBuffer(buffer);
            int result = SpiLcdNative.nativeRefresh(buffer.array());
            if (result <= 0) {
                throw new IllegalStateException("refreshScreen failed: " + result);
            }
            Log.i(TAG, "refreshScreen ok " + content.headline);
        } finally {
            bitmap.recycle();
        }
    }

    private void trySetCustomLayerVisible() {
        try {
            transactSetContentVisible(CustomerDisplayContent.CONTENT_CUSTOM, true);
        } catch (Exception error) {
            Log.w(TAG, "setContentVisible skipped: " + error.getMessage());
        }
    }

    private Bitmap render(CustomerDisplayContent content) {
        Bitmap bitmap = Bitmap.createBitmap(WIDTH, HEIGHT, Bitmap.Config.RGB_565);
        Canvas canvas = new Canvas(bitmap);
        canvas.drawColor(BACKGROUND);
        drawCentered(canvas, content.title, 36f, 22f, TITLE_COLOR, Typeface.DEFAULT);
        drawCentered(canvas, content.headline, 96f, 48f, HEADLINE_COLOR, Typeface.DEFAULT_BOLD);
        drawCentered(canvas, content.detail, 142f, 22f, DETAIL_COLOR, Typeface.DEFAULT);
        return bitmap;
    }

    private static void drawCentered(
            Canvas canvas,
            String text,
            float baselineY,
            float textSize,
            int color,
            Typeface typeface
    ) {
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(color);
        paint.setTextSize(textSize);
        paint.setTypeface(typeface);
        paint.setTextAlign(Paint.Align.CENTER);
        canvas.drawText(text, WIDTH / 2f, baselineY, paint);
    }

    private static void transactSetContentVisible(int contentId, boolean visible) {
        IBinder remote = lookupService();
        Parcel data = Parcel.obtain();
        Parcel reply = Parcel.obtain();
        try {
            data.writeInterfaceToken(DESCRIPTOR);
            data.writeInt(contentId);
            data.writeInt(visible ? 1 : 0);
            boolean ok = remote.transact(TRANSACTION_SET_CONTENT_VISIBLE, data, reply, 0);
            if (!ok) {
                throw new IllegalStateException("setContentVisible transact failed");
            }
            reply.readException();
        } catch (Exception error) {
            throw new IllegalStateException(error.getMessage(), error);
        } finally {
            reply.recycle();
            data.recycle();
        }
    }

    private static IBinder lookupService() {
        try {
            Class<?> serviceManager = Class.forName("android.os.ServiceManager");
            Method getService = serviceManager.getMethod("getService", String.class);
            Object remote = getService.invoke(null, SERVICE_NAME);
            if (remote instanceof IBinder) {
                return (IBinder) remote;
            }
            throw new IllegalStateException("agenew_sublcd service missing");
        } catch (Exception error) {
            throw new IllegalStateException("Cannot access agenew_sublcd: " + error.getMessage(), error);
        }
    }
}
