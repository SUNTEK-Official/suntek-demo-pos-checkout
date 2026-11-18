package com.suntek.checkoutapplication;

/**
 * Unified speech recognition abstraction for POS/Kiosk checkout flows.
 * Implement with Android SpeechRecognizer, offline Vosk, or a customer-supplied STT backend.
 */
public interface IVoiceRecognizer {

    interface Listener {
        void onReady();

        void onPartialResult(String text);

        void onFinalResult(String text);

        void onError(String message);
    }

    void setLanguage(String bcp47LanguageCode);

    void start(Listener listener);

    void stop();

    void release();

    boolean isListening();
}
