FROM python:3.7-slim
EXPOSE 8000
WORKDIR /app
ENV PYTHONUNBUFFERED 1

# both files are explicitly required!
COPY ../Pipfile ../Pipfile.lock ./

RUN pip install pipenv && \
  apt-get update && \
  apt-get install -y --no-install-recommends gcc python3-dev libssl-dev iputils-ping curl unzip

# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#     unzip awscliv2.zip && \
#     ./aws/install

COPY iotd ./iotd
WORKDIR /app/iotd


RUN pipenv install 
RUN chmod +x /app/iotd/entrypoint.sh
ENTRYPOINT ["/app/iotd/entrypoint.sh"]
