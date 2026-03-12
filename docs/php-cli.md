# Dockerfile

# Set the entrypoint to the shell entrypoint using JSON array syntax
ENTRYPOINT ["/usr/local/bin/setup.sh"]

# Define the default command to run after the entrypoint script finishes
CMD ["php"]