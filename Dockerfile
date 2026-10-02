FROM ubuntu:noble AS builder

## Váriáveis de ambiente, no caso, coisas do ubuntu, do java, do android e o caminho do flutter
ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:/usr/local/flutter/bin"

# 1. Dependências do sistema + Java
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    unzip \
    wget \
    openjdk-17-jdk \
    libgtk-3-dev \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    && apt-get clean

# Wrapper para o 'tar' para evitar erros de permissão
RUN echo '#!/bin/sh' > /usr/local/bin/tar && \
    echo 'exec /bin/tar --no-same-owner "$@"' >> /usr/local/bin/tar && \
    chmod +x /usr/local/bin/tar

# 2. Android SDK - com versão fixa
## Sim, como o android studio não é mais necessário, pode se gerar um apk com isso
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -fsSL -o cmdline-tools.zip \
    "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" && \
    unzip -q cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    rm cmdline-tools.zip && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest

# 3. Aceitar licenças e instalar componentes Android
## Exatamente, ele está aceitando componentes q o android pede
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "platform-tools"

# 4. Flutter SDK - URL CORRIGIDA
## Está baixando a versão estável do flutter
RUN git clone https://github.com/flutter/flutter.git --depth 1 -b stable $FLUTTER_HOME

# 5. Configurar Flutter
## No analytics tira alguns servicos extras
## Enable web disponibiliza as ferramentas de wasm
## android sdk, mostra o sdk do android (doido né)
RUN flutter config --no-analytics && \
    flutter config --enable-web && \
    flutter config --android-sdk ${ANDROID_SDK_ROOT} && \
    yes | flutter doctor --android-licenses && \
    flutter doctor

# ========== RUNTIME (imagem final, muito menor) ==========
FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:/usr/local/flutter/bin"

# Apenas dependências de runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    libglu1-mesa \
    openjdk-17-jdk \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copiar apenas o que é necessário do builder
COPY --from=builder /usr/local/flutter /usr/local/flutter
COPY --from=builder /opt/android-sdk /opt/android-sdk

# Usuário não-root
RUN groupadd -r flutter && useradd -r -g flutter -u 1000 flutter
USER flutter

WORKDIR /app
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD flutter doctor || exit 1

CMD ["bash"]