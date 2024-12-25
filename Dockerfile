# FROM python:3.10


# WORKDIR /app

# COPY . /app

# RUN pip install --no-cache-dir -r requirements.txt

# RUN apt-get update && apt-get install -y wget unzip && \
#     wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \ 
#     apt install -y ./google-chrome-stable_current_amd64.deb && \
#     rm google-chrome-stable_current_amd64.deb && \ 
#     apt-get clean

# CMD ["python", "main.py"]



# FROM python:3.10

# WORKDIR /app

# COPY . /app

# # Install required libraries for running Chrome
# RUN apt-get update && apt-get install -y \
#     wget \
#     unzip \
#     libx11-6 \
#     libx11-xcb1 \
#     libxcomposite1 \
#     libxcursor1 \
#     libxdamage1 \
#     libxrandr2 \
#     libxi6 \
#     libxtst6 \
#     libnss3 \
#     libxss1 \
#     libglib2.0-0 \
#     libgtk-3-0 \
#     libasound2 \
#     fonts-liberation \
#     libfontconfig1 \
#     libu2f-udev \
#     xdg-utils \
#     && apt-get clean


# # Install necessary tools for downloading and unzipping the file
# RUN wget https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chrome-linux64.zip && \
#     unzip chrome-linux64.zip && \
#     rm chrome-linux64.zip && \
#     mkdir -p /opt/google && \
#     mv chrome-linux64 /opt/google/chrome && \
#     apt-get clean

# # Add Chrome's binary to the PATH so it can be used directly
# ENV PATH="/opt/google/chrome:$PATH"

# # Install Python dependencies
# RUN pip install --no-cache-dir -r requirements.txt

# RUN chmod +x /opt/google/chrome/chrome

# CMD ["python", "main.py"]



# ====================================================================================
# ====================================================================================
# ====================================================================================
# ====================================================================================


# Use the official Python 3.10 image
FROM python:3.10

# Set working directory inside the container
WORKDIR /app



# Install system dependencies for Chrome/ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libx11-6 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxrandr2 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libxss1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libasound2 \
    fonts-liberation \
    libfontconfig1 \
    libu2f-udev \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

###########################################
# 1) Download and Install Chrome (Browser)
###########################################
# - We download the chrome-linux64.zip from Chrome for Testing.
# - Unzip it into /opt/google-chrome, then link its binary in /usr/bin so commands
#   like `google-chrome --version` will work.
###########################################
RUN wget --no-verbose https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chrome-linux64.zip \
    && unzip chrome-linux64.zip \
    && rm chrome-linux64.zip \
    && mv chrome-linux64 /opt/google-chrome \
    && ln -s /opt/google-chrome/chrome /usr/bin/google-chrome

###########################################
# 2) Download and Install ChromeDriver
###########################################
# - We download the chromedriver-linux64.zip from the same version so everything matches.
# - Unzip it into /usr/bin/chromedriver, then make it executable.
###########################################
RUN wget --no-verbose https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip \
    && rm chromedriver-linux64.zip \
    && mv chromedriver-linux64 /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver

###########################################
# 3) Install Python dependencies
###########################################
# - Make sure requirements.txt includes:
#   - selenium>=4.6 (so you can also use Selenium Manager if desired)
#   - webdriver_manager (if you’re using it in code)
#   - BeautifulSoup4 (bs4)
#   - any other dependencies
###########################################

# Copy everything from your project into /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

###########################################
# 4) Set the default command
###########################################
CMD ["python", "main.py"]



# FROM python:3.10

# WORKDIR /app

# # Install prerequisites.
# RUN apt-get update && apt-get install -y \
#     wget \
#     gnupg2 \
#     ca-certificates \
#     unzip

# ########################################
# # 1) Install Google Chrome (ARM64)
# #    We use the official .deb from Google
# ########################################
# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_arm64.deb -O chrome_arm64.deb \
#     && dpkg -i chrome_arm64.deb || apt-get -fy install \
#     && rm chrome_arm64.deb

# ########################################
# # 2) Install Python dependencies
# #    IMPORTANT: ensure "selenium >= 4.10"
# ########################################
# COPY . /app

# RUN pip install --no-cache-dir -r requirements.txt

# # For debugging, let's verify Chrome installed correctly:
# # RUN google-chrome --version

# ########################################
# # 3) Default command
# ########################################
# CMD ["python", "main.py"]
