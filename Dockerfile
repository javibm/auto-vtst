FROM ubuntu

ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_NDK  /opt/android-ndk

ENV ANDROID_BUILD_TOOLS_VERSION="25.0.2"
ENV ANDROID_SDK_VERSION="25.2.5"

RUN apt-get -qq update && apt-get -qq install -y \
    software-properties-common python-software-properties bzip2 unzip openssh-client lib32z1 git imagemagick curl gconf-service lib32gcc1 lib32stdc++6 libasound2 libc6 libc6-i386 libcairo2 libcap2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libgl1-mesa-glx libglib2.0-0 libglu1-mesa libgtk2.0-0 libnspr4 libnss3 libpango1.0-0 libstdc++6 libx11-6 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxtst6 zlib1g debconf npm xdg-utils lsb-release libpq5 xvfb libsoup2.4-1 libarchive13 libpng-dev python-pip python3-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Install android sdk
RUN wget -q -O android-sdk.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip  && \
    unzip android-sdk.zip && \
    rm -fr android-sdk.zip && \
    mkdir $ANDROID_HOME && \
    mv tools $ANDROID_HOME && \

# Install Android components
echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter android-25 && \
echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter platform-tools && \
echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS_VERSION} && \
echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \
echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \
echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository

RUN mkdir -p /root/.cache/unity3d && mkdir -p /root/.local/share/unity3d/Unity && mkdir -p /root/.local/share/unity3d/Certificates

# Environment variables
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/build-tools/${ANDROID_BUILD_TOOLS_VERSION}

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ADD get-unity.sh /app/get-unity.sh
ADD run-unity.sh /app/run-unity.sh
# ADD 5/Unity_v5.x.ulf /root/.local/share/unity3d/Unity/Unity_v5.x.ulf
ADD Unity_lic.ulf /root/.local/share/unity3d/Unity/Unity_lic.ulf
ADD CACerts.pem /root/.local/share/unity3d/Certificates/CACerts.pem
RUN chmod +x /app/get-unity.sh && \
    chmod +x /app/run-unity.sh
RUN /app/get-unity.sh
ENV PATH="/app:${PATH}"