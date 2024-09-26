FROM public.ecr.aws/sam/build-python3.12

# Install essential build tools and dependencies
RUN dnf groupinstall "Development Tools" -y && \
    dnf install wget tar bzip2 -y

# Set the installation directory to /var/task
ENV PREFIX=/var/task

# Build and install dependencies into /var/task
RUN wget https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.50.tar.bz2 && \
    tar -xvjf libgpg-error-1.50.tar.bz2 && cd libgpg-error-1.50 && \
    ./configure --prefix=$PREFIX --enable-install-gpg-error-config && make && make install && cd .. && \
    wget https://gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.1.tar.bz2 && \
    tar -xvjf libassuan-3.0.1.tar.bz2 && cd libassuan-3.0.1 && \
    ./configure --prefix=$PREFIX && make && make install && cd .. && \
    wget https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.7.tar.bz2 && \
    tar -xvjf libksba-1.6.7.tar.bz2 && cd libksba-1.6.7 && \
    ./configure --prefix=$PREFIX && make && make install && cd .. && \
    wget https://gnupg.org/ftp/gcrypt/npth/npth-1.7.tar.bz2 && \
    tar -xvjf npth-1.7.tar.bz2 && cd npth-1.7 && \
    ./configure --prefix=$PREFIX && make && make install && cd .. && \
    wget https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.0.tar.bz2 && \
    tar -xvjf libgcrypt-1.11.0.tar.bz2 && cd libgcrypt-1.11.0 && \
    ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX && make && make install && cd ..

# Build and install GPG into /var/task
RUN wget https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.5.tar.bz2 && \
    tar -xvjf gnupg-2.4.5.tar.bz2 && cd gnupg-2.4.5 && \
    ./configure --prefix=$PREFIX \
        --with-libgpg-error-prefix=$PREFIX \
        --with-libassuan-prefix=$PREFIX \
        --with-libgpg-error-prefix=$PREFIX \
        --with-libgcrypt-prefix=$PREFIX \
        --with-libassuan-prefix=$PREFIX \
        --with-ksba-prefix=$PREFIX \
        --with-npth-prefix=$PREFIX && \
    make && make install

RUN zip -r gpg-layer.zip bin lib

