FROM python:3.12.1

WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install necessary dependencies and Chrome/ChromeDriver
RUN apt-get update && \
    apt-get install -y wget unzip xvfb libxi6 libgconf-2-4 libnss3 libxss1 libasound2 libgbm-dev && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1) && \
    wget https://chromedriver.storage.googleapis.com/${CHROME_VERSION}.0/chromedriver_linux64.zip -P /tmp && \
    unzip /tmp/chromedriver_linux64.zip -d /usr/local/bin && \
    rm /tmp/chromedriver_linux64.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Xvfb and ChromeDriver
ENV DISPLAY=:99
ENV PATH="/usr/local/bin:$PATH"

# Start Xvfb and run the Python script
CMD ["bash", "-c", "Xvfb :99 -screen 0 1024x768x16 & python 1XBetCrashUpdater.py"]
