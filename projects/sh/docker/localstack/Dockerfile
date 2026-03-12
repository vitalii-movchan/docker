# Start from the official LocalStack image
FROM localstack/localstack:4.13

# Optional: Install additional tools (e.g., aws CLI wrapper)
RUN pip install awscli-local

# Copy initialization scripts into the container
COPY  ./docker/localstack/init-aws.sh /etc/localstack/init/ready.d/init-aws.sh

# Ensure the script is executable
RUN chmod +x /etc/localstack/init/ready.d/init-aws.sh

# You can add more application-specific setup here, e.g., copy your lambda code
# COPY ./lambda-functions /etc/localstack/lambda-code

