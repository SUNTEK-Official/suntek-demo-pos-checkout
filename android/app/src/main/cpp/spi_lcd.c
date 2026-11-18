#include <errno.h>
#include <fcntl.h>
#include <jni.h>
#include <unistd.h>
#include <sys/ioctl.h>

#define DEVICE_PATH "/dev/spi_lcd"
#define IOCTL_SCREEN_OFF 0x7301
#define IOCTL_SCREEN_ON 0x7302

static jint ioctlCommand(int command) {
    int fd = open(DEVICE_PATH, O_WRONLY);
    if (fd < 0) {
        return -errno;
    }
    int result = ioctl(fd, command);
    int status = result < 0 ? -errno : 1;
    close(fd);
    return status;
}

JNIEXPORT jint JNICALL
Java_com_suntek_checkoutapplication_SpiLcdNative_nativeScreenOn(JNIEnv *env, jclass clazz) {
    (void) env;
    (void) clazz;
    return ioctlCommand(IOCTL_SCREEN_ON);
}

JNIEXPORT jint JNICALL
Java_com_suntek_checkoutapplication_SpiLcdNative_nativeScreenOff(JNIEnv *env, jclass clazz) {
    (void) env;
    (void) clazz;
    return ioctlCommand(IOCTL_SCREEN_OFF);
}

JNIEXPORT jint JNICALL
Java_com_suntek_checkoutapplication_SpiLcdNative_nativeRefresh(
        JNIEnv *env,
        jclass clazz,
        jbyteArray pixels
) {
    (void) clazz;
    if (pixels == NULL) {
        return -EINVAL;
    }
    int fd = open(DEVICE_PATH, O_WRONLY);
    if (fd < 0) {
        return -errno;
    }
    jbyte *buffer = (*env)->GetByteArrayElements(env, pixels, NULL);
    jsize length = (*env)->GetArrayLength(env, pixels);
    ssize_t written = write(fd, buffer, (size_t) length);
    (*env)->ReleaseByteArrayElements(env, pixels, buffer, JNI_ABORT);
    close(fd);
    if (written < 0) {
        return -errno;
    }
    if (written != length) {
        return -EIO;
    }
    return 1;
}
