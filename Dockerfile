FROM openjdk:8-jdk
MAINTAINER devops@smarsh.com

# Install Maven and other build deps
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      maven \
      wget \
      unzip \
      curl \
    && rm -rf /var/lib/apt/lists/*

# Configure Maven
RUN mkdir -p /etc/maven/
COPY settings.xml /etc/maven/settings.xml

# Install .NET CLI dependencies
# From https://github.com/dotnet/dotnet-docker
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libc6 \
      libcurl3 \
      libgcc1 \
      libgssapi-krb5-2 \
      libicu52 \
      liblttng-ust0 \
      libssl1.0.0 \
      libstdc++6 \
      libunwind8 \
      libuuid1 \
      nuget \
      zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Configure Nuget
RUN mkdir -p ~/.config/NuGet
COPY NuGet.Config ~/.config/NuGet/NuGet.Config

# Install .NET Core SDK
# From https://github.com/dotnet/dotnet-docker
ENV DOTNET_SDK_VERSION 1.0.1
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install sonar-scanner
# From https://docs.sonarqube.org/display/SONARQUBE52/Installing+and+Configuring+SonarQube+Scanner
RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.0.702-linux.zip \
    && unzip sonar-scanner-cli-3.0.0.702-linux.zip \
    && rm sonar-scanner-cli-3.0.0.702-linux.zip \
    && ln -s /sonar-scanner-3.0.0.702-linux/bin/sonar-scanner /bin/
copy sonar-scanner.properties /sonar-scanner-3.0.0.702-linux/conf/sonar-scanner.properties
