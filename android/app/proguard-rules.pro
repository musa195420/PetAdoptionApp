# Stripe warnings (keep as-is)
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# ======= TensorFlow Lite Core =======
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.c.** { *; }
-keep class org.tensorflow.** { *; }

# ======= GPU Delegate =======
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend { *; }

# ======= NNAPI Delegate =======
-keep class org.tensorflow.lite.nnapi.** { *; }

# ======= Support Library =======
-keep class org.tensorflow.lite.support.** { *; }

# ======= Suppress Warnings =======
-dontwarn org.tensorflow.lite.**
-dontwarn org.tensorflow.**