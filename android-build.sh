sudo apt-get update && sudo apt-get install -yq file build-essential wget git g++ cmake pkg-config bison flex \
                        lib32stdc++6

# # Rust & Cargo
# curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="~/.cargo/bin:$PATH"
rustup target add aarch64-linux-android armv7-linux-androideabi arm-linux-androideabi

# Android NDK and toolchain 
wget -q https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip && \
        unzip -qq android-ndk-r16b-linux-x86_64.zip && \
        rm android-ndk-r16b-linux-x86_64.zip
export NDK_HOME="$PWD/android-ndk-r16b"

mkdir NDK

# build toolchain for arm 
${NDK_HOME}/build/tools/make-standalone-toolchain.sh \
--arch=arm --install-dir=NDK/arm --platform=android-26

# build toolchain for aarch64 
${NDK_HOME}/build/tools/make-standalone-toolchain.sh \
--arch=arm64 --install-dir=NDK/aarch64 --platform=android-26

sudo sh -c "echo '[target.arm-linux-androideabi] 
ar = \"arm-linux-androideabi-ar\" 
linker = \"arm-linux-androideabi-clang\" 
 
[target.aarch64-linux-android] 
ar = \"aarch64-linux-android-ar\" 
linker = \"aarch64-linux-android-clang\"' > ~/.cargo/config" 

export PATH="$PATH:$PWD/NDK/arm/bin" 	
export PATH="$PATH:$PWD/NDK/aarch64/bin"

# debug
# ls NDK/arm/bin
# ls NDK/aarch64/bin

cargo build --target="arm-linux-androideabi" --release
cargo build --target="aarch64-linux-android" --release

zip -j  "torchbear-arm".zip target/arm-linux-androideabi/release/torchbear
zip -j "torchbear-aarch64".zip target/aarch64-linux-android/release/torchbear



