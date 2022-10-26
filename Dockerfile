FROM debian:bullseye

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        autoconf \
        automake \
        build-essential \
        bzip2 \
        clang-format \
        clang-tidy \
        cloc \
        cmake \
        curl \
        doxygen \
        flex \
        g++ \
        gcc \
        git \
        graphviz \
        lcov \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsasl2-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        make \
        mpich \
        ninja-build \
        perl \
        python3-pip \
        valgrind \
        xz-utils \
        zlib1g-dev \
        && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -o cppcheck-1.90.tar.gz -L https://github.com/danmar/cppcheck/archive/1.90.tar.gz && \
    tar xf cppcheck-1.90.tar.gz && \
    cd cppcheck-1.90 && \
    mkdir build && \
    cmake ../cppcheck-1.90 && \
    make -j8 install && \
    cd .. && \
    rm -rf cppcheck-1.90*

RUN pip3 install conan==1.53.0 coverage==4.4.2 flake8==3.5.0 gcovr==4.1 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

RUN git clone http://github.com/ess-dmsc/conan-configuration.git && \
    cd conan-configuration && \
    git checkout 126940cf54a8a0181d46f93f8aa733543cbac359 && \
    cd .. && \
    conan config install conan-configuration && \
    rm -rf conan-configuration

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

RUN conan config set general.revisions_enabled=True

USER jenkins

WORKDIR /home/jenkins
