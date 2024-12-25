# # Use the official Python 3.10 image
# FROM python:3.10

# # Set working directory inside the container
# WORKDIR /app



# # Install system dependencies for Chrome/ChromeDriver
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
#     && rm -rf /var/lib/apt/lists/*

# ###########################################
# # 1) Download and Install Chrome (Browser)
# ###########################################
# # - We download the chrome-linux64.zip from Chrome for Testing.
# # - Unzip it into /opt/google-chrome, then link its binary in /usr/bin so commands
# #   like `google-chrome --version` will work.
# ###########################################
# RUN wget --no-verbose https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chrome-linux64.zip \
#     && unzip chrome-linux64.zip \
#     && rm chrome-linux64.zip \
#     && mv chrome-linux64 /opt/google-chrome \
#     && ln -s /opt/google-chrome/chrome /usr/bin/google-chrome

# ###########################################
# # 2) Download and Install ChromeDriver
# ###########################################
# # - We download the chromedriver-linux64.zip from the same version so everything matches.
# # - Unzip it into /usr/bin/chromedriver, then make it executable.
# ###########################################
# RUN wget --no-verbose https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chromedriver-linux64.zip \
#     && unzip chromedriver-linux64.zip \
#     && rm chromedriver-linux64.zip \
#     && mv chromedriver-linux64 /usr/bin/chromedriver \
#     && chmod +x /usr/bin/chromedriver

# ###########################################
# # 3) Install Python dependencies
# ###########################################
# # - Make sure requirements.txt includes:
# #   - selenium>=4.6 (so you can also use Selenium Manager if desired)
# #   - webdriver_manager (if you’re using it in code)
# #   - BeautifulSoup4 (bs4)
# #   - any other dependencies
# ###########################################

# # Copy everything from your project into /app
# COPY . /app

# RUN pip install --no-cache-dir -r requirements.txt

# ###########################################
# # 4) Set the default command
# ###########################################
# CMD ["python", "main.py"]


# ========================================================================================
# ========================================================================================
# ========================================================================================
# ========================================================================================
# ========================================================================================


FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget curl unzip gnupg libnss3 libx11-6 libxcomposite1 libxcursor1 libxdamage1 \
        libxi6 libxtst6 libatk1.0-0 libasound2 libpangocairo-1.0-0 libxrandr2 \
        libxrender1 libxshmfence1 fonts-liberation libappindicator3-1 libdbusmenu-glib4 \
        libdbusmenu-gtk3-4 && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y /tmp/google-chrome.deb && \
    rm /tmp/google-chrome.deb

# Install ChromeDriver
RUN wget -q https://chromedriver.storage.googleapis.com/$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the main.py script
COPY main.py .

# Run the script
CMD ["python", "main.py"]
