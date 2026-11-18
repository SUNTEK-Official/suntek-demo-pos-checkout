# Changelog

All notable changes to this repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-11-18

### Added
- Initial v1.0.0 Apache-2.0 retail & self-service checkout reference release (`android/` + `windows/`).
- Bundled complete Android POS checkout UI (`MainActivity`, `Us880Printer`, `Us880PrintBackend`, `AgenewSublcdBackend`, `SpiLcdNative`, `UsbPrinterConnection`, `IVoiceRecognizer`) with `printerlib.jar` and `libprinter_dll.so`.
- Included Windows Qt 6 QML checkout application (`windows/CMakeLists.txt`, `POSDllLoader`, `POS_SDK.dll`).
