#!/vendor/bin/sh

mount -o rw,remount /system_root;
cat /system_root/init.rc | grep 'import /init.spectrum.rc';
if [ $? -ne 0 ]; then
  sed -i -e '/init.usb.rc/a\' -e 'import /init.spectrum.rc' /system_root/init.rc
fi;
mount -o ro,remount /system_root;

# end boot time fs tune
echo "2048" > /sys/block/sda/queue/read_ahead_kb
echo "128" > /sys/block/sda/queue/nr_requests
echo "1" > /sys/block/sda/queue/iostats
echo "anxiety"> /sys/block/sda/queue/scheduler
echo "2084" > /sys/block/sde/queue/read_ahead_kb
echo "128" > /sys/block/sde/queue/nr_requests
echo "1" > /sys/block/sde/queue/iostats
echo "anxiety" > /sys/block/sde/queue/scheduler

#enable dynamic fsync
echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active

# Disable GPU frequency based throttling because it is actually not even needed anymore after all the GPU related enhancements and minor changes that I've done so far;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Optimize and lower both the battery drain and overall power consumption that is caused by the Schedutil governor by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any notable traces of the "semi-typical" smoothness regressions;

# This sysfs file actually mirrors the 'target_freq' tunable that can be found at the '/sys/class/kgsl/kgsl-3d0/devfreq' path. Set this to lowest possible frequency for lowest possible amount of power consumption from the Adreno 540 GPU;
echo "257" > /sys/kernel/gpu/gpu_min_clock

# Done!
#